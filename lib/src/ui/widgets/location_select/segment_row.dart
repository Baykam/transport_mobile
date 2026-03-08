part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// _SegmentRow
// ─────────────────────────────────────────────────────────────────

class _SegmentRow extends StatelessWidget {
  final int segmentIndex;
  final SegmentTransport? transport;
  final Color fromColor, toColor;
  final VoidCallback onTap;

  const _SegmentRow({
    required this.segmentIndex, required this.transport,
    required this.fromColor, required this.toColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chosen = transport != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: chosen ? transport!.color.withOpacity(0.08) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: chosen ? transport!.color.withOpacity(0.3) : Colors.white.withOpacity(0.07),
            width: chosen ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              width: 28, height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [fromColor, toColor]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            if (chosen) ...[
              Icon(transport!.icon, color: transport!.color, size: 15),
              const SizedBox(width: 6),
              Text(transport!.label,
                  style: TextStyle(color: transport!.color, fontSize: 12, fontWeight: FontWeight.w700)),
            ] else ...[
              Icon(Icons.add_rounded, color: Colors.white.withOpacity(0.25), size: 14),
              const SizedBox(width: 5),
              Text('Select transport',
                  style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 12)),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: (chosen ? transport!.color : Colors.white).withOpacity(0.07),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Seg ${segmentIndex + 1}',
                style: TextStyle(
                  color: chosen ? transport!.color.withOpacity(0.8) : Colors.white.withOpacity(0.2),
                  fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.2), size: 16),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}