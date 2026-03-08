part of '../select_locations_map.dart';

class MapHint extends StatelessWidget {
  const MapHint({super.key, required this.needHint});
  final bool needHint;
  @override
  Widget build(BuildContext context) {
    final duration = kThemeAnimationDuration;
    return Center(
      child: AnimatedContainer(
        height: needHint ? 28 : 0,
        width: 120,
        duration: duration,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117).withOpacity(0.88),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.teal.withOpacity(0.35), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.teal.withOpacity(0.15), blurRadius: 16, spreadRadius: 2),
          ],
        ),
        child: AnimatedOpacity(
          opacity: needHint ? 1.0 : 0.0,
          duration: duration,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 7, height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow,
                    boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.6), blurRadius: 6)],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Move Map',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
