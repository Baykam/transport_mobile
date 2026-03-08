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
part 'widgets/move_map_hint.dart';
part 'widgets/app_bar.dart';
class SelectLocationsMap extends StatefulWidget {
  const SelectLocationsMap({super.key});

  @override
  State<SelectLocationsMap> createState() => _SelectLocationsMapState();
}

class _SelectLocationsMapState extends State<SelectLocationsMap>
    with MixCreateLocations, TickerProviderStateMixin {

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
              needTopGradient: true,
            ),
          ),

          // ══ LAYER 2: App bar ════════════════════════════════════
          AppBarMap(
              topPad: topPad,
              isPickingLocation: _isPickingLocation,
            cancelPicking: _cancelPicking,
            onTapSearch: onTapSearch,
          ),

          // ══ LAYER 3: "Move map" hint ════════════════════════════
          MoveMapHint(
            isPickingLocation: _isPickingLocation,
            ptColor: ptColor,
            topPad: topPad,
            pt: pt,
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