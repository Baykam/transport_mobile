part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// Header row
// ─────────────────────────────────────────────────────────────────

class _RouteCardHeader extends StatelessWidget {
  final List<RoutePoint> points;
  final int filledCount;
  final bool allFilled;
  final bool isLoading;
  final bool canConfirm;
  final Animation<double> chevronTurns;
  final VoidCallback onTap;
  final Color Function(PointType) dotColor;

  const _RouteCardHeader({
    required this.points,
    required this.filledCount,
    required this.allFilled,
    required this.isLoading,
    required this.canConfirm,
    required this.chevronTurns,
    required this.onTap,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    const cyan   = Color(0xFF4CC9F0);
    const green  = Color(0xFF06D6A0);
    const orange = Color(0xFFFF6B35);

    final statusColor = canConfirm ? green : (allFilled ? cyan : orange);
    final statusText  = canConfirm
        ? 'Route ready ✓'
        : (isLoading ? 'Building route…' : 'Set route points');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Dot chain
            SizedBox(
              width: 72,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < points.length; i++) ...[
                    _MiniDot(color: dotColor(points[i].type), filled: points[i].address.isNotEmpty),
                    if (i < points.length - 1)
                      Container(
                        width: points.length > 3 ? 5 : 8,
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            dotColor(points[i].type).withOpacity(0.4),
                            dotColor(points[i + 1].type).withOpacity(0.4),
                          ]),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 13, fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (isLoading) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 10, height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: cyan.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: filledCount / points.length,
                      minHeight: 3,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$filledCount of ${points.length} locations set',
                    style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            RotationTransition(
              turns: chevronTurns,
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withOpacity(0.4), size: 22),
            ),
          ],
        ),
      ),
    );
  }
}


class _MiniDot extends StatelessWidget {
  const _MiniDot({required this.color, required this.filled});
  final Color color;
  final bool  filled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: 7, height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : Colors.transparent,
        border: Border.all(color: filled ? color : color.withOpacity(0.35), width: 1.5),
        boxShadow: filled ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 5)] : [],
      ),
    );
  }
}
