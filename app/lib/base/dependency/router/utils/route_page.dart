import 'package:flutter/material.dart';
import 'package:starter_app/base/dependency/router/utils/route_name.dart';
import 'package:starter_app/base/dependency/router/utils/route_screen.dart';

class RoutePage {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) =>
      switch (settings.name) {
        RouteName.counter => RouteScreen.counterPageRoute(settings),
        _ => RouteScreen.homePageRoute(settings),
      };

  RoutePage._();
}
