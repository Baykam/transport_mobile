part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// _Badge
// ─────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  const _Badge({required this.label, required this.color, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: outlined ? Border.all(color: color.withOpacity(0.35)) : null,
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
    );
  }
}