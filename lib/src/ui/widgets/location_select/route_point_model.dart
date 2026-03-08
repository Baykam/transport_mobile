part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// RoutePoint
// ─────────────────────────────────────────────────────────────────

class RoutePoint {
  final int id;
  final String label;
  String address;
  final PointType type;
  LatLng? latLng;

  RoutePoint({
    required this.id,
    required this.label,
    required this.address,
    required this.type,
    this.latLng,
  });
}