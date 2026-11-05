import 'package:flutter/material.dart';
import 'package:starter_app/base/store/store_provider.dart';
import 'package:starter_app/features/counter/counter_screen.dart';
import 'package:starter_app/features/home/home_screen.dart';

class RouteScreen {
  static PageRoute<void> homePageRoute(RouteSettings settings) =>
      MaterialPageRoute(settings: settings, builder: (_) => const HomeScreen());

  static PageRoute<void> counterPageRoute(RouteSettings settings) {
    final storeProvider = StoreProvider.counter();
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => CounterScreen(storeProvider: storeProvider),
    );
  }

  RouteScreen._();
}
