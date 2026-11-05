import 'package:starter_app/base/dependency/router/utils/route_name.dart';

class RouteInput {
  final String routeName;
  final Object? arguments;

  const RouteInput.home() : routeName = RouteName.home, arguments = null;
  const RouteInput.counter() : routeName = RouteName.counter, arguments = null;
}
