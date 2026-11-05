import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_app/base/dependency/app_service.dart';
import 'package:starter_app/base/dependency/router/utils/route_input.dart';
import 'package:starter_app/base/store/store_provider.dart';
import 'package:starter_app/l10n/gen_l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.homeTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(strings.welcome, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => ref
                      .read(AppService.router)
                      .push(const RouteInput.counter()),
                  child: Text(strings.openCounter),
                ),
                const SizedBox(height: 24),
                Text(strings.language),
                DropdownButton<Locale>(
                  value: Localizations.localeOf(context),
                  hint: Text(strings.language),
                  items: const [
                    DropdownMenuItem(
                      value: Locale('vi'),
                      child: Text('Tiếng Việt'),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                  ],
                  onChanged: (locale) {
                    if (locale != null) {
                      ref.read(StoreProvider.app).setLocale(locale);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
