import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_app/base/store/store_base.dart';
import 'package:starter_app/features/counter/counter_store.dart';
import 'package:starter_app/store/app_store.dart';

class StoreProvider {
  static final app = Provider<AppStore>((ref) {
    final store = AppStore();
    ref.onDispose(store.dispose);
    return store;
  });

  // Each route owns its provider so simultaneous visits cannot share state.
  static Provider<CounterStore> counter() =>
      createAutoDisposeStore((ref) => CounterStore());

  StoreProvider._();
}
