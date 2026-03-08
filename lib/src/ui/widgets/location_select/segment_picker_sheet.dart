part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// _SegmentPickerSheet
// ─────────────────────────────────────────────────────────────────

class _SegmentPickerSheet extends StatelessWidget {
  final int segmentIndex;
  final RoutePoint from, to;
  final SegmentTransport? current;
  final void Function(SegmentTransport) onSelect;

  const _SegmentPickerSheet({
    required this.segmentIndex, required this.from, required this.to,
    required this.current, required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141B2D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Symbols.route, color: Color(0xFFFF6B35), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Segment ${segmentIndex + 1} Transport',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    Text(
                      '${from.address.isEmpty ? from.label : from.address}  →  '
                          '${to.address.isEmpty ? to.label : to.address}',
                      style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.3,
            children: SegmentTransport.values.map((t) {
              final sel = current == t;
              return GestureDetector(
                onTap: () => onSelect(t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: sel ? t.color.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: sel ? t.color.withOpacity(0.6) : Colors.white.withOpacity(0.08),
                      width: sel ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(t.icon, color: sel ? t.color : Colors.white38, size: 26),
                      const SizedBox(height: 6),
                      Text(t.label,
                          style: TextStyle(
                              color: sel ? t.color : Colors.white54,
                              fontSize: 12,
                              fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                      if (sel) ...[
                        const SizedBox(height: 4),
                        Container(width: 20, height: 3,
                            decoration: BoxDecoration(color: t.color, borderRadius: BorderRadius.circular(2))),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
