import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.title, this.subtitle, required this.icon, this.navigateIcon, this.onTap});
  
  final String title;
  final String? subtitle;
  final IconData icon;
  final IconData? navigateIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: onTap ?? (){},
        leading: Icon(icon),
        title: Text(title),
        subtitle:subtitle != null ? Text(subtitle ?? '') : null,
        trailing: Icon(navigateIcon ?? Symbols.arrow_forward_ios),
      ),
    );
  }
}