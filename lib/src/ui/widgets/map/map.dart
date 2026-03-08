import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:transport/src/ui/widgets/map/funcs.dart';

class MapView extends StatefulWidget {
  const MapView({
    super.key,
    this.markers,
    this.onSecondaryTap,
    this.onLongPress,
    this.onTap,
    this.onPositionChanged,
    this.mapController,
    this.initialCenter = const LatLng(39.9334, 32.8597),
    this.initialZoom = 13.0,
    this.needButtons = true,
    this.polylines = const [],
  });

  final List<Marker>? markers;
  final Function(TapPosition, LatLng)? onTap;
  final Function(TapPosition, LatLng)? onLongPress;
  final Function(TapPosition, LatLng)? onSecondaryTap;
  final void Function(MapCamera, bool)? onPositionChanged;
  final MapController? mapController;
  final LatLng initialCenter;
  final double initialZoom;
  final bool needButtons;
  final List<Polyline> polylines;


  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  final MapController _insideController = MapController();
  final AlignOnUpdate _alignOnUpdate = AlignOnUpdate.never;

  StreamSubscription? _locationSub;
  final _locationStream =
  LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();

  LatLng? _currentLocation;
  late final MapFunctions _mapFunctions;
  late final MapController _mapController;

  // ── zoom level display ──
  double _zoomLevel = 13.0;

  // ── button press animation ──
  final Map<String, bool> _pressed = {
    'zoom_in': false,
    'zoom_out': false,
    'my_location': false,
  };

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? _insideController;
    _zoomLevel = widget.initialZoom;

    _mapFunctions = MapFunctions(
      controller: _mapController,
      vsync: this,
    );

    _locationSub = _locationStream.listen((data) {
      if (data != null && mounted) {
        setState(() {
          _currentLocation = LatLng(data.latitude, data.longitude);
        });
      }
    });
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null) {
      _mapFunctions.animatedMove(_currentLocation!, 15);
    }
  }

  void _zoom(double delta) {
    final next = (_mapController.camera.zoom + delta).clamp(3.0, 19.0);
    _mapController.move(_mapController.camera.center, next);
    setState(() => _zoomLevel = next);
  }

  Future<void> _animatePress(String key) async {
    setState(() => _pressed[key] = true);
    await Future.delayed(const Duration(milliseconds: 120));
    if (mounted) setState(() => _pressed[key] = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          // ── MAP ────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              maxZoom: 19,
              minZoom: 3,
              initialCenter: widget.initialCenter,
              initialZoom: widget.initialZoom,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onSecondaryTap: widget.onSecondaryTap,
              onPositionChanged: (camera, hasGesture) {
                widget.onPositionChanged?.call(camera, hasGesture);
                if (mounted) setState(() => _zoomLevel = camera.zoom);
              },
            ),
            children: [
              // Dark-tinted tile layer
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.your.superapp',
                maxZoom: 19,
                // tileBuilder: _darkTileBuilder,
              ),

              MarkerLayer(
                markers: widget.markers ?? [],
              ),

              PolylineLayer(polylines: widget.polylines),

              CurrentLocationLayer(
                alignPositionOnUpdate: _alignOnUpdate,
                positionStream: _locationStream,
                style: LocationMarkerStyle(
                  showHeadingSector: true,
                  marker: _CustomLocationMarker(),
                  markerSize: const Size(28, 28),
                  headingSectorColor:
                  const Color(0xFFFF6B35).withOpacity(0.25),
                  headingSectorRadius: 80,
                  accuracyCircleColor:
                  const Color(0xFF4CC9F0).withOpacity(0.08),
                ),
                moveAnimationDuration: Duration.zero,
              ),
            ],
          ),

          // ── Bottom vignette ────────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: 100,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF0D1117).withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Control buttons ────────────────────────────────────────
          if (widget.needButtons)
            Positioned(
              bottom: 40,
              right: 16,
              child: _MapControlPanel(
                zoomLevel: _zoomLevel,
                pressed: _pressed,
                hasLocation: _currentLocation != null,
                onZoomIn: () {
                  _animatePress('zoom_in');
                  _zoom(1);
                },
                onZoomOut: () {
                  _animatePress('zoom_out');
                  _zoom(-1);
                },
                onMyLocation: () {
                  _animatePress('my_location');
                  _goToCurrentLocation();
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Map Control Panel — zoom + location
// ─────────────────────────────────────────────────────────────────────────────

class _MapControlPanel extends StatelessWidget {
  final double zoomLevel;
  final Map<String, bool> pressed;
  final bool hasLocation;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;

  const _MapControlPanel({
    required this.zoomLevel,
    required this.pressed,
    required this.hasLocation,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Zoom cluster ──
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117).withOpacity(0.92),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.09)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _ControlBtn(
                heroTag: 'zoom_in',
                icon: Icons.add_rounded,
                isPressed: pressed['zoom_in'] ?? false,
                onTap: onZoomIn,
                topRadius: true,
              ),
              Divider(
                height: 1,
                color: Colors.white.withOpacity(0.07),
              ),
              // ── Zoom level badge ──
              SizedBox(
                width: 44,
                height: 32,
                child: Center(
                  child: Text(
                    zoomLevel.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.white.withOpacity(0.07),
              ),
              _ControlBtn(
                heroTag: 'zoom_out',
                icon: Icons.remove_rounded,
                isPressed: pressed['zoom_out'] ?? false,
                onTap: onZoomOut,
                bottomRadius: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ── My location ──
        AnimatedScale(
          scale: (pressed['my_location'] ?? false) ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: GestureDetector(
            onTap: onMyLocation,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: hasLocation
                    ? const Color(0xFFFF6B35)
                    : const Color(0xFF141B2D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasLocation
                      ? const Color(0xFFFF6B35)
                      : Colors.white.withOpacity(0.09),
                ),
                boxShadow: hasLocation
                    ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                hasLocation
                    ? Icons.my_location_rounded
                    : Icons.location_searching_rounded,
                color: hasLocation ? Colors.white : Colors.white38,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single control button (zoom in / zoom out)
// ─────────────────────────────────────────────────────────────────────────────

class _ControlBtn extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final bool isPressed;
  final VoidCallback onTap;
  final bool topRadius;
  final bool bottomRadius;

  const _ControlBtn({
    required this.heroTag,
    required this.icon,
    required this.isPressed,
    required this.onTap,
    this.topRadius = false,
    this.bottomRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.88 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isPressed
                ? Colors.white.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: topRadius ? const Radius.circular(13) : Radius.zero,
              topRight: topRadius ? const Radius.circular(13) : Radius.zero,
              bottomLeft:
              bottomRadius ? const Radius.circular(13) : Radius.zero,
              bottomRight:
              bottomRadius ? const Radius.circular(13) : Radius.zero,
            ),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom pulsing location dot
// ─────────────────────────────────────────────────────────────────────────────

class _CustomLocationMarker extends StatefulWidget {
  @override
  State<_CustomLocationMarker> createState() => _CustomLocationMarkerState();
}

class _CustomLocationMarkerState extends State<_CustomLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _ring;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _ring = CurvedAnimation(parent: _pulse, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Pulsing ring ──
          AnimatedBuilder(
            animation: _ring,
            builder: (_, __) => Transform.scale(
              scale: 1.0 + _ring.value * 1.2,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4CC9F0)
                        .withOpacity(1.0 - _ring.value),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // ── Core dot ──
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFF4CC9F0),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CC9F0).withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}