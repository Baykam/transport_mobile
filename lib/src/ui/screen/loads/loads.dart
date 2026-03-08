
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/ui/widgets/profile/profile_tile.dart';


class LoadsScreen extends StatelessWidget {
  const LoadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 30,
          children: [
            tabs(title: 'Cache', list: [
              UiData(title: 'Favorite', icon: Symbols.favorite),
              UiData(title: 'Latest',icon: Symbols.reviews),
              UiData(title: 'Phone', icon: Symbols.phone),
            ]),
            tabs(title: 'In Progress', list: [
              UiData(title: 'Loads', icon: Symbols.car_tag),
            ]),
            tabs(title: 'Completed', list: [
              UiData(title: 'Loads', icon: Symbols.car_defrost_left),
            ]),
          ]
        ),
      ),
    );
  }
}

class tabs extends StatelessWidget {
  const tabs({super.key, required this.title, required this.list});
  final String title;
  final List<UiData> list;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const Divider(),
        ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ProfileTile(
                  title: list[index].title ?? '',
                  icon: list[index].icon ?? Icons.person,
                  subtitle: list[index].subtitle,
              );
            },
        ),
      ],
    );
  }
}


class UiData{
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final IconData? navigateIcon;

  UiData({this.title, this.subtitle, this.icon, this.navigateIcon});
}
