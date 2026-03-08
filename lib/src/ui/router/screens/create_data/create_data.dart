import 'package:go_router/go_router.dart';
import 'package:transport/src/ui/router/path.dart';
import 'package:transport/src/ui/screen/create_data/create_data.dart';

class CreateDataRoute extends GoRoute{
  CreateDataRoute({AppPath? appPath, super.routes}) : super(
    path: appPath?.path ?? AppPath.createData.path,
    name: appPath?.name ?? AppPath.createData.name,
    builder: (context, state) => TransportFormScreen(),
  );
}