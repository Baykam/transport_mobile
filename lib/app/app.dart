import 'package:flutter/material.dart';
import '../src/ui/router/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.instance.router,
      debugShowCheckedModeBanner: true,
      title: 'Transport',
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
    );
  }
}