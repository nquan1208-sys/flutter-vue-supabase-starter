import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_app/base/dependency/router/router_provider.dart';
import 'package:starter_app/base/dependency/router/router_service.dart';

class AppService {
  static final router = Provider(
    (ref) => RouterService(routerProvider: RouterProvider()),
  );

  AppService._();
}
