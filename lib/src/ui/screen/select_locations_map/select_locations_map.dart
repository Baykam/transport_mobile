// select_locations_map.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/ui/router/path.dart';
import 'package:transport/src/ui/widgets/location_select/route_card.dart';
import 'package:transport/src/ui/widgets/location_select/route_polyline_service.dart';
import 'package:transport/src/ui/widgets/map/map.dart';

part 'mixin_create_locations.dart';
part 'widgets/search_bar.dart';
part 'widgets/map_center_pin.dart';
part 'widgets/location_confirm_panel.dart';

class SelectLocationsMap extends StatefulWidget {
  const SelectLocationsMap({super.key});

  @override
  State<SelectLocationsMap> createState() => _SelectLocationsMapState();
}

class _SelectLocationsMapState extends State<SelectLocationsMap>
    with MixCreateLocations, TickerProviderStateMixin {
  //
  // // ── Map controller ─────────────────────────────────────────────
  // final MapController _mapController = MapController();
  //
  // // ── Route points ───────────────────────────────────────────────
  // final List<RoutePoint> _points = [
  //   RoutePoint(id: 0, label: 'Pickup point',   address: 'Ashgabat / Parahat 3/1', type: PointType.pickup),
  //   RoutePoint(id: 3, label: 'Stop 1',         address: '',                        type: PointType.stop),
  //   RoutePoint(id: 4, label: 'Stop 2',         address: '',                        type: PointType.stop),
  //   RoutePoint(id: 1, label: 'Delivery point', address: 'somewhere in world',      type: PointType.delivery),
  // ];
  // int _activePointIndex = 0;
  //
  // // ── Location picking state ─────────────────────────────────────
  // bool   _isPickingLocation = false;
  // bool   _isPinAnimating    = false;
  // bool   _isMapMoving       = false;
  // String _pickedAddress     = '';
  // bool   _isGeocoding       = false;
  // Timer? _geocodeDebounce;
  // LatLng _pendingLatLng     = const LatLng(37.9601, 58.3261);
  //
  // // ── Polyline state ─────────────────────────────────────────────
  // // Keyed by segment index (0 = first→second point, 1 = second→third, …)
  // final Map<int, SegmentRoute> _segmentRoutes = {};
  // final Map<int, bool>         _segmentLoading = {};
  //
  // // ── Text controllers ───────────────────────────────────────────
  // final _weightCtrl = TextEditingController();
  // final _cbmCtrl    = TextEditingController();
  // final _priceCtrl  = TextEditingController();
  //
  // @override
  // void dispose() {
  //   _weightCtrl.dispose();
  //   _cbmCtrl.dispose();
  //   _priceCtrl.dispose();
  //   _geocodeDebounce?.cancel();
  //   super.dispose();
  // }
  //
  // // ════════════════════════════════════════════════════════════════
  // // Derived state helpers
  // // ════════════════════════════════════════════════════════════════
  //
  // Color _pointColor(PointType type) => switch (type) {
  //   PointType.pickup   => const Color(0xFF4CC9F0),
  //   PointType.stop     => const Color(0xFFFFD166),
  //   PointType.delivery => const Color(0xFFFF6B35),
  // };
  //
  // Color _segmentColor(int segIdx) {
  //   // Each segment fades between its two endpoint colours
  //   final ordered = _orderedPoints;
  //   if (segIdx >= ordered.length - 1) return const Color(0xFFFF6B35);
  //   return Color.lerp(
  //     _pointColor(ordered[segIdx].type),
  //     _pointColor(ordered[segIdx + 1].type),
  //     0.5,
  //   )!;
  // }
  //
  // List<RoutePoint> get _orderedPoints {
  //   final pickup   = _points.where((p) => p.type == PointType.pickup).toList();
  //   final stops    = _points.where((p) => p.type == PointType.stop).toList();
  //   final delivery = _points.where((p) => p.type == PointType.delivery).toList();
  //   return [...pickup, ...stops, ...delivery];
  // }
  //
  // /// How many segments need a route (both endpoints confirmed).
  // int get _requiredSegmentCount {
  //   final ordered = _orderedPoints;
  //   int count = 0;
  //   for (var i = 0; i < ordered.length - 1; i++) {
  //     if (ordered[i].latLng != null && ordered[i + 1].latLng != null) count++;
  //   }
  //   return count;
  // }
  //
  // /// true when every required segment has a REAL polyline (not fallback).
  // bool get _allPolylinesReal {
  //   if (_requiredSegmentCount == 0) return false;
  //   return _segmentRoutes.values
  //       .where((r) => r.isReal)
  //       .length == _requiredSegmentCount;
  // }
  //
  // bool get _anyLoading => _segmentLoading.values.any((v) => v);
  //
  // // ════════════════════════════════════════════════════════════════
  // // Marker builder
  // // ════════════════════════════════════════════════════════════════
  //
  // List<Marker> get _markers {
  //   int stopCounter = 0;
  //   return _orderedPoints
  //       .where((p) => p.latLng != null)
  //       .map((p) {
  //     if (p.type == PointType.stop) stopCounter++;
  //     return Marker(
  //       point: p.latLng!,
  //       width: 44,
  //       height: 62,
  //       alignment: Alignment.bottomCenter,
  //       child: RouteMarkerWidget(
  //         point: p,
  //         orderIndex: stopCounter,
  //         color: _pointColor(p.type),
  //       ),
  //     );
  //   })
  //       .toList();
  // }
  //
  // // ════════════════════════════════════════════════════════════════
  // // Polyline builder  →  passed to MapView
  // // ════════════════════════════════════════════════════════════════
  //
  // List<Polyline> get _polylines {
  //   final result = <Polyline>[];
  //   _segmentRoutes.forEach((segIdx, route) {
  //     if (route.points.length < 2) return;
  //
  //     final color = _segmentColor(segIdx);
  //
  //     if (route.isReal) {
  //       // Road-following route — solid with a glow under-stroke
  //       result.add(Polyline(
  //         points: route.points,
  //         color: Colors.black.withOpacity(0.35),
  //         strokeWidth: 7,
  //       ));
  //       result.add(Polyline(
  //         points: route.points,
  //         color: color,
  //         strokeWidth: 4.5,
  //       ));
  //       result.add(Polyline(
  //         points: route.points,
  //         color: color.withOpacity(0.25),
  //         strokeWidth: 12,
  //       ));
  //     } else {
  //       // Straight-line fallback — dashed look via two strokes
  //       result.add(Polyline(
  //         points: route.points,
  //         color: color.withOpacity(0.3),
  //         strokeWidth: 6,
  //         pattern: StrokePattern.dashed(segments: [12, 8]),
  //       ));
  //       result.add(Polyline(
  //         points: route.points,
  //         color: color.withOpacity(0.6),
  //         strokeWidth: 2,
  //         pattern: StrokePattern.dashed(segments: [12, 8]),
  //       ));
  //     }
  //   });
  //   return result;
  // }
  //
  // // ════════════════════════════════════════════════════════════════
  // // Point management
  // // ════════════════════════════════════════════════════════════════
  //
  // void _addStop() {
  //   if (_points.where((p) => p.type == PointType.stop).length >= 3) return;
  //   setState(() {
  //     _points.insert(
  //       _points.length - 1,
  //       RoutePoint(
  //         id: DateTime.now().millisecondsSinceEpoch,
  //         label: 'Stop ${_points.where((p) => p.type == PointType.stop).length + 1}',
  //         address: '',
  //         type: PointType.stop,
  //       ),
  //     );
  //   });
  //   // Invalidate affected segment routes
  //   _invalidateAllRoutes();
  // }
  //
  // void _removePoint(int id) {
  //   if (_points.length <= 2) return;
  //   setState(() => _points.removeWhere((p) => p.id == id));
  //   _invalidateAllRoutes();
  // }
  //
  // void _invalidateAllRoutes() {
  //   setState(() {
  //     _segmentRoutes.clear();
  //     _segmentLoading.clear();
  //   });
  // }
  //
  // // ════════════════════════════════════════════════════════════════
  // // Picking flow
  // // ════════════════════════════════════════════════════════════════
  //
  // void _onTapPoint(int index) {
  //   setState(() {
  //     _activePointIndex  = index;
  //     _isPickingLocation = true;
  //     _isPinAnimating    = true;
  //     _pickedAddress     = _points[index].address;
  //     _isGeocoding       = false;
  //     if (_points[index].latLng != null) {
  //       _pendingLatLng = _points[index].latLng!;
  //       _mapController.move(_pendingLatLng, _mapController.camera.zoom);
  //     }
  //   });
  //   Future.delayed(const Duration(milliseconds: 580), () {
  //     if (mounted) setState(() => _isPinAnimating = false);
  //   });
  // }
  //
  // void _onCameraMove(MapCamera camera, bool hasGesture) {
  //   _pendingLatLng = camera.center;
  //   if (!_isPickingLocation) return;
  //   _geocodeDebounce?.cancel();
  //   if (!_isMapMoving) setState(() => _isMapMoving = true);
  //   _geocodeDebounce = Timer(const Duration(milliseconds: 650), () {
  //     setState(() {
  //       _isMapMoving   = false;
  //       _isGeocoding   = true;
  //       _pickedAddress = '';
  //     });
  //     _reverseGeocode(camera.center);
  //   });
  // }
  //
  // Future<void> _reverseGeocode(LatLng position) async {
  //   if (!mounted) return;
  //   // 🔴 TODO: replace with real geocoding
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   if (!mounted) return;
  //   setState(() {
  //     _isGeocoding   = false;
  //     _pickedAddress = 'Bitarap Türkmenistan köç. 14, Ashgabat';
  //   });
  // }
  //
  // // ── Confirm: saves address + latLng, then fetches adjacent routes ─
  // void _confirmPickedLocation() {
  //   setState(() {
  //     _points[_activePointIndex].address = _pickedAddress;
  //     _points[_activePointIndex].latLng  = _pendingLatLng;
  //     _isPickingLocation = false;
  //   });
  //   _geocodeDebounce?.cancel();
  //
  //   // Re-fetch any segment that touches this point
  //   _fetchAdjacentSegments(_activePointIndex);
  // }
  //
  // void _cancelPicking() {
  //   setState(() => _isPickingLocation = false);
  //   _geocodeDebounce?.cancel();
  // }
  //
  // void _useMyLocation() {
  //   _mapController.move(const LatLng(37.9601, 58.3261), 15.5);
  // }
  //
  // // ════════════════════════════════════════════════════════════════
  // // Route fetching
  // // ════════════════════════════════════════════════════════════════
  //
  // /// Fetches the segment(s) that start or end at [pointIndex] in _orderedPoints.
  // Future<void> _fetchAdjacentSegments(int pointListIndex) async {
  //   final ordered = _orderedPoints;
  //
  //   // Find where this point sits in the ordered list
  //   final pointId = _points[pointListIndex].id;
  //   final orderedIdx = ordered.indexWhere((p) => p.id == pointId);
  //   if (orderedIdx < 0) return;
  //
  //   // Segments to (re)fetch: the one ending here and the one starting here
  //   final toFetch = <int>[];
  //   if (orderedIdx > 0 && ordered[orderedIdx - 1].latLng != null) {
  //     toFetch.add(orderedIdx - 1);
  //   }
  //   if (orderedIdx < ordered.length - 1 && ordered[orderedIdx + 1].latLng != null) {
  //     toFetch.add(orderedIdx);
  //   }
  //
  //   for (final segIdx in toFetch) {
  //     _fetchSegment(segIdx, ordered[segIdx], ordered[segIdx + 1]);
  //   }
  // }
  //
  // Future<void> _fetchSegment(
  //     int segIdx,
  //     RoutePoint from,
  //     RoutePoint to,
  //     ) async {
  //   if (from.latLng == null || to.latLng == null) return;
  //
  //   setState(() => _segmentLoading[segIdx] = true);
  //
  //   final route = await RoutePolylineService.fetch(from.latLng!, to.latLng!);
  //
  //   if (!mounted) return;
  //   setState(() {
  //     _segmentRoutes[segIdx]  = route;
  //     _segmentLoading[segIdx] = false;
  //   });
  // }
  //
  // // ════════════════════════════════════════════════════════════════
  // // Confirm route
  // // ════════════════════════════════════════════════════════════════
  //
  // void _onConfirm() => context.pushNamed(AppPath.createData.name);
  //
  // // ════════════════════════════════════════════════════════════════
  // // Build
  // // ════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final topPad  = MediaQuery.of(context).padding.top;
    final pt      = _isPickingLocation ? _points[_activePointIndex] : null;
    final ptColor = pt != null ? _pointColor(pt.type) : Colors.transparent;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [

          // ══ LAYER 0: Full-screen map ════════════════════════════
          Positioned.fill(
            child: MapView(
              markers: _markers,
              polylines: _polylines,           // ← road polylines
              mapController: _mapController,
              onPositionChanged: _onCameraMove,
              needButtons: !_isPickingLocation,
            ),
          ),

          // ══ LAYER 1: Top gradient ═══════════════════════════════
          Positioned(
            top: 0, left: 0, right: 0, height: 170,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),

          // ══ LAYER 2: App bar ════════════════════════════════════
          Positioned(
            top: topPad + 8, left: 12, right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleBtn(
                  icon: _isPickingLocation
                      ? Icons.close_rounded
                      : Icons.arrow_back_rounded,
                  onTap: _isPickingLocation ? _cancelPicking : () => context.pop(),
                  accent: _isPickingLocation,
                ),
                const SizedBox(width: 10),
                if (_isPickingLocation) Expanded(child: _SearchBar(onTap: onTapSearch)),
                const SizedBox(width: 10),
                _CircleBtn(icon: Symbols.layers, onTap: () {}),
              ],
            ),
          ),

          // ══ LAYER 3: "Move map" hint ════════════════════════════
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            top: topPad + 68, left: 0, right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isPickingLocation ? 1.0 : 0.0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117).withOpacity(0.88),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: ptColor.withOpacity(0.35), width: 1.2),
                      boxShadow: [
                        BoxShadow(color: ptColor.withOpacity(0.15), blurRadius: 16, spreadRadius: 2),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 7, height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ptColor,
                            boxShadow: [BoxShadow(color: ptColor.withOpacity(0.6), blurRadius: 6)],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          pt != null ? 'Move map · Set ${pt.label}' : '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.80),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ══ LAYER 4: Route card (collapsible) ══════════════════
          AnimatedPositioned(
            duration: const Duration(milliseconds: 320),
            curve: _isPickingLocation ? Curves.easeInCubic : Curves.easeOutCubic,
            top: _isPickingLocation ? topPad - 400.0 : topPad + 74.0,
            left: 12, right: 12,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: _isPickingLocation ? 0.0 : 1.0,
              child: RouteCardStack(
                points: _points,
                activeIndex: _activePointIndex,
                onTapPoint: _onTapPoint,
                onRemove: _removePoint,
                onAddStop: _addStop,
                // ↓ Only enable confirm when every segment has a REAL polyline
                canConfirm: _allPolylinesReal && !_anyLoading,
                isLoadingRoutes: _anyLoading,
                onConfirmRoute: _onConfirm,
              ),
            ),
          ),

          // ══ LAYER 5: Animated center pin ═══════════════════════
          if (_isPickingLocation)
            _MapCenterPin(
              isDropping: _isPinAnimating,
              isFloating: _isMapMoving,
              color: ptColor,
            ),

          // ══ LAYER 6: Bottom confirm panel ══════════════════════
          _LocationConfirmPanel(
            visible: _isPickingLocation,
            point: pt ?? _points[0],
            address: _pickedAddress,
            isGeocoding: _isGeocoding || _isMapMoving,
            pointColor: ptColor,
            onConfirm: _confirmPickedLocation,
            onUseMyLocation: _useMyLocation,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Circular icon button
// ─────────────────────────────────────────────────────────────────

class _CircleBtn extends StatefulWidget {
  const _CircleBtn({required this.icon, required this.onTap, this.accent = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool accent;

  @override
  State<_CircleBtn> createState() => _CircleBtnState();
}

class _CircleBtnState extends State<_CircleBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 42, height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.accent
                ? orange.withOpacity(_pressed ? 0.28 : 0.16)
                : const Color(0xFF0D1117).withOpacity(0.85),
            border: Border.all(
              color: widget.accent
                  ? orange.withOpacity(0.55)
                  : Colors.white.withOpacity(0.11),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.accent ? orange : Colors.black).withOpacity(0.30),
                blurRadius: 10, offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            widget.icon, size: 18,
            color: widget.accent ? orange : Colors.white.withOpacity(0.80),
          ),
        ),
      ),
    );
  }
}