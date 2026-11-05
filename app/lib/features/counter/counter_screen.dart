import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:starter_app/features/counter/counter_store.dart';
import 'package:starter_app/l10n/gen_l10n/app_localizations.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({required this.storeProvider, super.key});
  final Provider<CounterStore> storeProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.counterTitle)),
      body: SafeArea(
        child: Center(
          child: SignalBuilder(
            builder: (context) => Text(strings.countLabel(store.count.value)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: store.increment,
        tooltip: strings.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
