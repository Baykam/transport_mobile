part of 'tab.dart';

mixin MixTab on  State<TabScreen>{
  void _onGoBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

}