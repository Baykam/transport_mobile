import 'package:go_router/go_router.dart';
import 'package:transport/src/ui/router/path.dart';
import 'package:transport/src/ui/screen/select_locations_map/select_locations_map.dart';

class CreateLocationsRoute extends GoRoute{
  CreateLocationsRoute({AppPath? appPath, super.routes}) : super(
    path: appPath?.path ?? AppPath.createLocationOnMap.path,
    name: appPath?.name ?? AppPath.createLocationOnMap.name,
    builder: (context, state) => SelectLocationsMap()
  );
}