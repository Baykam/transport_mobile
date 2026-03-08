import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/domain/model/simpleLoad.dart';

const Color _accent  = Color(0xFF818CF8);
const Color _surface = Color(0xFF0D1117);

class SimpleLoadMain extends StatelessWidget {
  const SimpleLoadMain({super.key, required this.simpleLoads, this.onPressed});
  final SimpleLoad simpleLoads;
  final Function(SimpleLoad? load)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: const Color(0xFF141B2D),
          child: InkWell(
            onTap: () => onPressed?.call(simpleLoads),
            splashColor: _accent.withOpacity(0.06),
            child: SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [

                  // ── Background image ──────────────────
                  Image.network(
                    'https://picsum.photos/600/300?image=10',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1E293B)),
                  ),

                  // ── Dark gradient overlay ─────────────
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.55),
                          Colors.black.withOpacity(0.88),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),

                  // ── Top: category badge + price ───────
                  Positioned(
                    top: 14,
                    left: 14,
                    right: 14,
                    child: Row(
                      children: [
                        // Category badge
                        if (simpleLoads.category != null)
                          _GlassBadge(
                            label: simpleLoads.category!.toUpperCase(),
                            color: _accent,
                          ),
                        const Spacer(),
                        // Price bubble
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _accent.withOpacity(0.45),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '\$${simpleLoads.price ?? '—'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Bottom: title + route + date ──────
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // Title
                        Text(
                          simpleLoads.title ?? 'No Title',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 10),

                        // Route pill
                        _RoutePill(
                          from: simpleLoads.startLocation,
                          to: simpleLoads.endLocation,
                          date: simpleLoads.finishDate,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Route pill — from ···· to + date
// ─────────────────────────────────────────────
class _RoutePill extends StatelessWidget {
  const _RoutePill({required this.from, required this.to, required this.date});
  final String? from;
  final String? to;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          // From
          const Icon(Symbols.trip_origin, color: _accent, size: 13),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              from ?? '—',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Dotted connector
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: CustomPaint(painter: _DotLinePainter()),
            ),
          ),

          // To
          Flexible(
            child: Text(
              to ?? '—',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Symbols.location_on, color: Color(0xFFEF476F), size: 13),

          // Date
          if (date != null) ...[
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 1,
              height: 14,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(width: 10),
            const Icon(Symbols.calendar_today, color: Color(0xFF6192D6), size: 11),
            const SizedBox(width: 4),
            Text(
              date!,
              style: const TextStyle(color: Color(0xFF264A7C), fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Glass badge
// ─────────────────────────────────────────────
class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withOpacity(0.95),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Dotted line painter
// ─────────────────────────────────────────────
class _DotLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashW = 3.0;
    const gap   = 4.0;
    double x = 0;
    final y = size.height / 2;

    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset((x + dashW).clamp(0, size.width), y), paint);
      x += dashW + gap;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}