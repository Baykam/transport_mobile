// route_polyline_service.dart
//
// Uses the FREE public OSRM demo server — no API key needed.
// Endpoint: https://router.project-osrm.org/route/v1/{profile}/{coords}
//
// Add to pubspec.yaml:
//   http: ^1.2.0
//
// For production consider self-hosting OSRM or switching to
// OpenRouteService (free tier) / GraphHopper (free tier).

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

enum RouteProfile { driving, walking, cycling }

extension RouteProfileExt on RouteProfile {
  String get osrmName => switch (this) {
    RouteProfile.driving  => 'driving',
    RouteProfile.walking  => 'foot',
    RouteProfile.cycling  => 'bike',
  };
}

class SegmentRoute {
  /// Decoded polyline points for drawing on the map.
  final List<LatLng> points;

  /// true  → came from OSRM (follows roads)
  /// false → straight-line fallback (OSRM unreachable / no route found)
  final bool isReal;

  /// Approx distance in metres (0 for fallback).
  final double distanceMeters;

  /// Approx duration in seconds (0 for fallback).
  final double durationSeconds;

  const SegmentRoute({
    required this.points,
    required this.isReal,
    this.distanceMeters = 0,
    this.durationSeconds = 0,
  });
}

class RoutePolylineService {
  static const _baseUrl = 'https://router.project-osrm.org/route/v1';
  static const _timeout = Duration(seconds: 8);

  /// Fetches a road-following route between [from] and [to].
  /// Returns a [SegmentRoute] — always non-null.
  /// On any failure (network, no route, timeout) returns a straight-line
  /// fallback so the UI never gets stuck.
  static Future<SegmentRoute> fetch(
      LatLng from,
      LatLng to, {
        RouteProfile profile = RouteProfile.driving,
      }) async {
    try {
      // OSRM expects lon,lat order
      final coords =
          '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';
      final uri = Uri.parse(
        '$_baseUrl/${profile.osrmName}/$coords'
            '?overview=full&geometries=geojson&steps=false',
      );

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200) return _fallback(from, to);

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] != 'Ok') return _fallback(from, to);

      final routes = json['routes'] as List<dynamic>;
      if (routes.isEmpty) return _fallback(from, to);

      final route    = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>;
      final coords_  = geometry['coordinates'] as List<dynamic>;

      final points = coords_
          .map((c) => LatLng(
        (c[1] as num).toDouble(), // lat
        (c[0] as num).toDouble(), // lon
      ))
          .toList();

      return SegmentRoute(
        points: points,
        isReal: true,
        distanceMeters: (route['distance'] as num).toDouble(),
        durationSeconds: (route['duration'] as num).toDouble(),
      );
    } catch (_) {
      return _fallback(from, to);
    }
  }

  /// Fetch routes for every consecutive pair of [points] that both have
  /// a non-null [latLng]. Returns a map keyed by segment index (0-based).
  ///
  /// Example: 3 points → keys 0 (A→B) and 1 (B→C).
  static Future<Map<int, SegmentRoute>> fetchAll(
      List<_HasLatLng> points, {
        RouteProfile profile = RouteProfile.driving,
      }) async {
    final result = <int, SegmentRoute>{};
    final futures = <Future<void>>[];

    for (var i = 0; i < points.length - 1; i++) {
      final from = points[i].latLng;
      final to   = points[i + 1].latLng;
      if (from == null || to == null) continue;

      final idx = i;
      futures.add(
        fetch(from, to, profile: profile).then((r) => result[idx] = r),
      );
    }

    await Future.wait(futures);
    return result;
  }

  // ── Straight-line fallback ─────────────────────────────────────
  static SegmentRoute _fallback(LatLng from, LatLng to) {
    return SegmentRoute(
      points: [from, to],
      isReal: false,
    );
  }
}

/// Minimal interface so [fetchAll] works with any class that has [latLng].
abstract class _HasLatLng {
  LatLng? get latLng;
}