import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:transport/src/helper/enum/UserRole.dart';

part 'mixin_tab.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with MixTab {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onGoBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Symbols.home),
            selectedIcon: Icon(Symbols.home, fill: 1.0),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Symbols.near_me),
            selectedIcon: Icon(Symbols.near_me, fill: 1.0),
            label: 'Nearest',
          ),
          NavigationDestination(
            icon: Icon(Symbols.local_shipping),
            selectedIcon: Icon(Symbols.local_shipping, fill: 1.0),
            label: 'Loads',
          ),
          NavigationDestination(
            icon: Icon(Symbols.chat),
            selectedIcon: Icon(Symbols.chat, fill: 1.0),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Symbols.settings),
            selectedIcon: Icon(Symbols.settings, fill: 1.0),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}