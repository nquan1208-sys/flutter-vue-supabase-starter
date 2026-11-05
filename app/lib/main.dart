import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:starter_app/base/dependency/app_service.dart';
import 'package:starter_app/base/dependency/router/utils/route_name.dart';
import 'package:starter_app/base/dependency/router/utils/route_page.dart';
import 'package:starter_app/base/store/store_provider.dart';
import 'package:starter_app/config/app_config.dart';
import 'package:starter_app/l10n/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.current = await AppConfig.load();
  await Supabase.initialize(
    url: AppConfig.current.supabaseUrl,
    publishableKey: AppConfig.current.supabasePublishableKey,
  );
  runApp(const ProviderScope(child: StarterApp()));
}

class StarterApp extends ConsumerWidget {
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStore = ref.watch(StoreProvider.app);
    final router = ref.watch(AppService.router);
    return SignalBuilder(
      builder: (context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        locale: appStore.locale.value,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(useMaterial3: true),
        darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        navigatorKey: router.navigatorKey,
        initialRoute: RouteName.home,
        onGenerateRoute: RoutePage.onGenerateRoute,
      ),
    );
  }
}
