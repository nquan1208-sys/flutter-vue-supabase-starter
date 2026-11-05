import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:starter_app/base/store/auto_dispose_manager.dart';
import 'package:starter_app/base/store/store_base.dart';

class AppStore extends StoreBase {
  final _disposers = AutoDisposeManager();
  late final locale = signal(const Locale('vi')).manageBy(_disposers);

  void setLocale(Locale value) => locale.value = value;

  @override
  void dispose() {
    _disposers.cancelAll();
    super.dispose();
  }
}
