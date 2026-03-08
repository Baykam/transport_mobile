// widgets/location_confirm_panel.dart
part of '../select_locations_map.dart';

/// Slides up from the bottom when the user is in picking mode.
///
/// Shows:
///  • Which point is being set (colored badge)
///  • Live address from reverse-geocode (or shimmer while loading)
///  • "My Location" shortcut button
///  • "Set Location" confirm button (disabled until address resolves)
class _LocationConfirmPanel extends StatelessWidget {
  const _LocationConfirmPanel({
    required this.visible,
    required this.point,
    required this.address,
    required this.isGeocoding,
    required this.pointColor,
    required this.onConfirm,
    required this.onUseMyLocation,
  });

  final bool       visible;
  final RoutePoint point;
  final String     address;
  final bool       isGeocoding;
  final Color      pointColor;
  final VoidCallback onConfirm;
  final VoidCallback onUseMyLocation;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    // Panel height: ~190 + safe area
    final panelH = 200.0 + bottomPad;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 340),
      curve: visible ? Curves.easeOutCubic : Curves.easeInCubic,
      bottom: visible ? 0 : -panelH,
      left: 0, right: 0,
      child: _PanelBody(
        point: point,
        address: address,
        isGeocoding: isGeocoding,
        pointColor: pointColor,
        bottomPad: bottomPad,
        onConfirm: onConfirm,
        onUseMyLocation: onUseMyLocation,
      ),
    );
  }
}

class _PanelBody extends StatelessWidget {
  const _PanelBody({
    required this.point,
    required this.address,
    required this.isGeocoding,
    required this.pointColor,
    required this.bottomPad,
    required this.onConfirm,
    required this.onUseMyLocation,
  });

  final RoutePoint   point;
  final String       address;
  final bool         isGeocoding;
  final Color        pointColor;
  final double       bottomPad;
  final VoidCallback onConfirm;
  final VoidCallback onUseMyLocation;

  bool get _canConfirm => address.isNotEmpty && !isGeocoding;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white.withOpacity(0.09)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 32,
              offset: const Offset(0, -6),
            ),
            // Subtle color bleed from point type
            BoxShadow(
              color: pointColor.withOpacity(0.06),
              blurRadius: 40,
              spreadRadius: 4,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 18 + bottomPad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Drag handle ─────────────────────────────────
              Center(
                child: Container(
                  width: 32, height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Header row ──────────────────────────────────
              Row(
                children: [
                  // Colored type icon
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pointColor.withOpacity(0.12),
                      border: Border.all(color: pointColor.withOpacity(0.30)),
                    ),
                    child: Icon(
                      _pointIcon(point.type),
                      color: pointColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Point type badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: pointColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _typeLabel(point.type),
                          style: TextStyle(
                            color: pointColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Set ${point.label}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Address display ──────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.07)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Symbols.location_on,
                      color: isGeocoding
                          ? Colors.white.withOpacity(0.25)
                          : pointColor,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: isGeocoding
                          ? _Shimmer()
                          : address.isEmpty
                          ? Text(
                        'Pan the map to pick a location',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.30),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                          : Text(
                        address,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Action row ───────────────────────────────────
              Row(
                children: [

                  // My Location button
                  _ActionBtn(
                    icon: Icons.my_location_rounded,
                    label: 'My location',
                    color: const Color(0xFF4CC9F0),
                    onTap: onUseMyLocation,
                    outlined: true,
                  ),

                  const SizedBox(width: 10),

                  // Set Location (confirm) button
                  Expanded(
                    flex: 2,
                    child: _ActionBtn(
                      icon: Icons.check_rounded,
                      label: 'Set location',
                      color: _canConfirm ? pointColor : Colors.white.withOpacity(0.2),
                      onTap: _canConfirm ? onConfirm : null,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _pointIcon(PointType t) => switch (t) {
    PointType.pickup   => Symbols.trip_origin,
    PointType.stop     => Symbols.radio_button_checked,
    PointType.delivery => Symbols.location_on,
  };

  String _typeLabel(PointType t) => switch (t) {
    PointType.pickup   => 'PICKUP',
    PointType.stop     => 'STOP',
    PointType.delivery => 'DELIVERY',
  };
}

// ── Shimmer loading bar ────────────────────────────────────────────

class _Shimmer extends StatefulWidget {
  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 11,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06 + _anim.value * 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 10,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04 + _anim.value * 0.07),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action button ──────────────────────────────────────────────────

class _ActionBtn extends StatefulWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.outlined = false,
    this.filled   = false,
  });

  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback? onTap;
  final bool         outlined;
  final bool         filled;

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final bg = widget.filled
        ? (enabled ? widget.color : Colors.white.withOpacity(0.06))
        : Colors.transparent;
    final border = widget.outlined || !widget.filled
        ? Border.all(
      color: enabled
          ? widget.color.withOpacity(widget.filled ? 0 : 0.35)
          : Colors.white.withOpacity(0.09),
    )
        : null;

    return GestureDetector(
      onTapDown:   (_) { if (enabled) setState(() => _pressed = true);  },
      onTapUp:     (_) { if (enabled) { setState(() => _pressed = false); widget.onTap!(); } },
      onTapCancel: ()  { setState(() => _pressed = false); },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: _pressed
                ? widget.color.withOpacity(0.22)
                : bg,
            borderRadius: BorderRadius.circular(13),
            border: border,
            boxShadow: widget.filled && enabled
                ? [BoxShadow(color: widget.color.withOpacity(0.30), blurRadius: 14, offset: const Offset(0, 4))]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 15,
                  color: enabled ? (widget.filled ? Colors.white : widget.color) : Colors.white24),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: enabled ? (widget.filled ? Colors.white : widget.color) : Colors.white24,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}