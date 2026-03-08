part of '../settings.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      children: [
        ProfileTile(
          title: 'Profile',
          subtitle: 'Profile',
          icon: Symbols.person,
        ),
        ProfileTile(
          title: 'Notifications',
          icon: Symbols.notifications,
        ),
        ProfileTile(
          title: 'Settings',
          icon: Symbols.settings,
        ),
      ],
    );
  }
}