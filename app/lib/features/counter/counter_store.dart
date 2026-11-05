import 'package:signals_flutter/signals_flutter.dart';
import 'package:starter_app/base/store/auto_dispose_manager.dart';
import 'package:starter_app/base/store/store_base.dart';

class CounterStore extends StoreBase {
  final _disposers = AutoDisposeManager();
  late final count = signal(0).manageBy(_disposers);

  void increment() => count.value++;

  @override
  void dispose() {
    _disposers.cancelAll();
    super.dispose();
  }
}
