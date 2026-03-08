import 'package:go_router/go_router.dart';
import 'package:transport/src/ui/router/path.dart';
import 'package:transport/src/ui/screen/create_data/create_data.dart';
import 'package:transport/src/ui/screen/filter_load/filter_loads.dart';

class FilterLoadsRoute extends GoRoute{
  FilterLoadsRoute({AppPath? appPath, super.routes}) : super(
    path: appPath?.path ?? AppPath.filterLoads.path,
    name: appPath?.name ?? AppPath.filterLoads.name,
    builder: (context, state) => FilterLoads(),
  );
}