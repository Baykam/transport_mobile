part of 'route_card.dart';


// ─────────────────────────────────────────────────────────────────
// RoundedIcon
// ─────────────────────────────────────────────────────────────────

class RoundedIcon extends StatelessWidget {
  const RoundedIcon({
    super.key, this.icon, this.borderColor, this.containerColor,
    this.iconColor, this.borderRadius, this.height, this.width,
    this.shape, this.iconSize,
  });

  final IconData? icon;
  final Color?    borderColor, containerColor, iconColor;
  final double?   borderRadius, height, width, iconSize;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: shape ?? BoxShape.rectangle,
        color: containerColor ?? const Color(0xFFFFD166).withOpacity(0.12),
        borderRadius: shape == null ? BorderRadius.circular(borderRadius ?? 7) : null,
        border: Border.all(color: borderColor ?? const Color(0xFFFFD166).withOpacity(0.2)),
      ),
      child: Icon(icon ?? Icons.add_rounded,
          color: iconColor ?? const Color(0xFFFFD166), size: iconSize ?? 13),
    );
  }
}
