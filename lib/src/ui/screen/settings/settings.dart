
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/ui/widgets/profile/profile_tile.dart';

part 'widgets/body.dart';
part 'widgets/appBar.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SettingsBody(),
    );
  }
}