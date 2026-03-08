
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/domain/model/simpleLoad.dart';
import 'package:transport/src/domain/model/simpleLoad2.dart';
import 'package:transport/src/helper/enum/UserRole.dart';
import 'package:transport/src/ui/router/path.dart';
import 'package:transport/src/ui/widgets/loads/load_card.dart';
import 'package:transport/src/ui/widgets/loads/simple_load.dart';

part 'widgets/body.dart';
part 'widgets/appbar.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SimpleLoad> loads = [];
  List<SimpleLoad2> secondLoad = [];
  UserRole userRole = UserRole.broker;
  @override
  void initState() {
    super.initState();
    loads = SimpleLoad().main();
    // secondLoad = SimpleLoad2().getTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        userRole: userRole,
          onPressed: (v) =>
              setState(() => userRole = v ?? UserRole.broker)),
      body: HomeBody(loads: loads,secondLoads: secondLoad),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Symbols.add, size: 24),
        onPressed: () => context.pushNamed(AppPath.createLocationOnMap.name),
      ),
    );
  }
}