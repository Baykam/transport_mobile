part of '../select_locations_map.dart';

class MoveMapHint extends StatelessWidget {
  const MoveMapHint({super.key, required this.topPad, required this.isPickingLocation, required this.ptColor, this.pt});
  final double topPad;
  final bool isPickingLocation;
  final Color ptColor;
  final RoutePoint? pt;
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      top: topPad + 68, left: 0, right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isPickingLocation ? 1.0 : 0.0,
        child: IgnorePointer(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117).withOpacity(0.88),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: ptColor.withOpacity(0.35), width: 1.2),
                boxShadow: [
                  BoxShadow(color: ptColor.withOpacity(0.15), blurRadius: 16, spreadRadius: 2),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 7, height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ptColor,
                      boxShadow: [BoxShadow(color: ptColor.withOpacity(0.6), blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pt != null ? 'Move map · Set ${pt?.label}' : '',
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
      ),
    );
  }
}
