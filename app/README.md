# Starter mobile

Android/iOS Flutter app with Signals state, Riverpod dependency injection,
route-owned stores, English/Vietnamese localization, and local/dev/prod flavors.
English is the default language; language selection lasts for the current session.

See [the root setup guide](../README.md) for environment configuration, local
backend URLs, commands, checks, and package renaming. Run Flutter commands here.

`lib/features/counter/` is the canonical stateful feature. `test/starter_test.dart`
checks state updates, disposal after navigation, fresh state on return, and locale
changes. Generated localization and real env files are intentionally ignored.
