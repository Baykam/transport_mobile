import 'package:go_router/go_router.dart';
import 'package:transport/src/domain/model/simpleLoad.dart';
import 'package:transport/src/ui/router/path.dart';
import 'package:transport/src/ui/screen/detail/detail.dart';

class LoadDetailRoute extends GoRoute{
  LoadDetailRoute({AppPath? appPath, super.routes, super.redirect}) : super(
    path: appPath?.path ?? AppPath.loadDetail.path,
    name: appPath?.name ?? AppPath.loadDetail.name,
    builder: (context, state) {
      final map = state.extra as Map?;
      final loads = map?['load'] as SimpleLoad?;

      return LoadDetailScreen(load: loads ?? SimpleLoad());
    },
  );
}