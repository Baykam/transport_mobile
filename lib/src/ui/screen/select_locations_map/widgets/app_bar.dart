part of '../select_locations_map.dart';

class AppBarMap extends StatelessWidget {
  const AppBarMap({super.key, required this.topPad, required this.isPickingLocation, required this.cancelPicking, required this.onTapSearch});
  final double topPad;
  final bool isPickingLocation;
  final Function() cancelPicking,onTapSearch;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPad + 8, left: 12, right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleBtn(
            icon: isPickingLocation
                ? Icons.close_rounded
                : Icons.arrow_back_rounded,
            onTap: isPickingLocation ? cancelPicking : () => context.pop(),
            accent: isPickingLocation,
          ),
          const SizedBox(width: 10),
          if (isPickingLocation) Expanded(child: _SearchBar(onTap: onTapSearch)),
          const SizedBox(width: 10),
          _CircleBtn(icon: Symbols.layers, onTap: () {}),
        ],
      ),
    );
  }
}
