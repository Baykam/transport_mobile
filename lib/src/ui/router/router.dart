import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transport/src/ui/router/screens/create_data/create_data.dart';
import 'package:transport/src/ui/router/screens/create_location_on_map/create_locations.dart';
import 'package:transport/src/ui/screen/settings/settings.dart';
import 'path.dart';
import '../screen/error/error.dart';
import '../screen/tab/tab.dart';
import '../screen/home/home.dart';
import '../screen/chat/chat.dart';
import '../screen/loads/loads.dart';
import '../screen/nearest/nearest.dart';

class AppRouter {
  AppRouter._();
  static final AppRouter instance = AppRouter._();

  GoRouter get router => _router;

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final GlobalKey<NavigatorState> _nearestNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'nearest');
  static final GlobalKey<NavigatorState> _loadsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'loads');
  static final GlobalKey<NavigatorState> _chatNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'chat');
  static final GlobalKey<NavigatorState> _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

  static final GoRouter _router = GoRouter(
    navigatorKey: _navigatorKey,
    initialLocation: AppPath.home.path,
    errorBuilder: (context, state) => const ErrorScreen(),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return TabScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppPath.home.path,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  CreateLocationsRoute(
                    routes: [
                      CreateDataRoute()
                    ]
                  )
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _nearestNavigatorKey,
            routes: [
              GoRoute(
                path: AppPath.nearest.path,
                builder: (context, state) => const NearestScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _loadsNavigatorKey,
            routes: [
              GoRoute(
                path: AppPath.loads.path,
                builder: (context, state) => const LoadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _chatNavigatorKey,
            routes: [
              GoRoute(
                path: AppPath.chat.path,
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: AppPath.settings.path,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

}
