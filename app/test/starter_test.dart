import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/counter/counter_screen.dart';
import 'package:starter_app/features/counter/counter_store.dart';
import 'package:starter_app/main.dart';

void main() {
  test('counter owns and disposes its signal', () {
    final store = CounterStore();
    store.increment();
    expect(store.count.value, 1);
    store.dispose();
    expect(store.isDispose, isTrue);
    expect(store.count.disposed, isTrue);
  });

  testWidgets('counter resets after pop and language changes rebuild screens', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const StarterApp(),
      ),
    );
    expect(find.text('Trang chủ'), findsOneWidget);
    await tester.tap(find.text('Mở bộ đếm'));
    await tester.pumpAndSettle();
    final screen = tester.widget<CounterScreen>(find.byType(CounterScreen));
    final store = container.read(screen.storeProvider);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(find.text('Số đếm: 1'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(store.isDispose, isTrue);
    expect(store.count.disposed, isTrue);
    await tester.tap(find.byType(DropdownButton<Locale>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    await tester.tap(find.text('Open counter'));
    await tester.pumpAndSettle();
    expect(find.text('Count: 0'), findsOneWidget);
    expect(
      container.read(
        tester.widget<CounterScreen>(find.byType(CounterScreen)).storeProvider,
      ),
      isNot(same(store)),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
