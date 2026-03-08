// widgets/map_center_pin.dart
part of '../select_locations_map.dart';

/// Floating pin that sits at the exact center of the screen.
///
/// States:
///  • [isDropping] true  → plays a drop-from-above + elastic bounce animation
///  • [isFloating] true  → pin levitates up slightly (map is moving)
///  • idle              → pin rests at center, shadow below it
class _MapCenterPin extends StatefulWidget {
  const _MapCenterPin({
    required this.isDropping,
    required this.isFloating,
    required this.color,
  });

  final bool  isDropping;
  final bool  isFloating;
  final Color color;

  @override
  State<_MapCenterPin> createState() => _MapCenterPinState();
}

class _MapCenterPinState extends State<_MapCenterPin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Drop phase  (0.00 → 0.55): falls from -50 to 0
  late final Animation<double> _dropY;
  // Bounce phase (0.55 → 1.00): elastic settle
  late final Animation<double> _bounceScale;
  // Shadow grows as pin lands
  late final Animation<double> _shadowScale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 580),
    );

    _dropY = Tween<double>(begin: -52, end: 0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.58, curve: Curves.easeIn),
      ),
    );

    _bounceScale = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.55, 1.0, curve: Curves.elasticOut),
      ),
    );

    _shadowScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    if (widget.isDropping) _ctrl.forward(from: 0);
  }

  @override
  void didUpdateWidget(_MapCenterPin old) {
    super.didUpdateWidget(old);
    if (widget.isDropping && !old.isDropping) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            // While dropping, use drop animation; otherwise animate float
            final dropOffset = widget.isDropping ? _dropY.value : 0.0;
            final floatOffset = widget.isFloating ? -10.0 : 0.0;
            final totalY = dropOffset + floatOffset;

            final shadowOpacity = widget.isFloating ? 0.08 : 0.22;
            final shadowWidth   = widget.isFloating ? 8.0  : 18.0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Pin body ─────────────────────────────────────
                AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  offset: Offset(0, widget.isFloating ? -0.15 : 0),
                  child: Transform.translate(
                    offset: Offset(0, dropOffset),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pin icon with glow
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withOpacity(0.55),
                                blurRadius: 22,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Symbols.location_on,
                            size: 46,
                            color: widget.color,
                          ),
                        ),
                        // Stem tip dot
                        Container(
                          width: 5, height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // ── Shadow ellipse ────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: shadowWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(shadowOpacity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}