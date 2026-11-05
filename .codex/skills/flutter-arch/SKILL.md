---
name: flutter-arch
description: "Use when explicitly invoked as $flutter-arch to build or review Flutter features in this starter's app/ using its Counter screen/store architecture."
---

This skill is opt-in. Apply it when explicitly invoked as `$flutter-arch`.

# Flutter Feature Architecture

Use `app/` as the Flutter package root and `package:starter_app/...` for imports.
The runnable reference is `app/lib/features/counter/` and its Home navigation.

## Screen and store

Start a stateful feature with `<feature>_screen.dart` and `<feature>_store.dart`
inside `app/lib/features/<feature>/`. Add feature-local widgets, models, or services
only when needed. Stateless screens such as Home do not need a feature store.

Keep state, mutations, async work, and side effects in a `StoreBase` subclass.
Follow `CounterStore`: use Signals and register every owned signal, computed,
effect disposer, subscription, or notifier with `AutoDisposeManager.manageBy`.
Dispose child stores first, call `cancelAll()`, then `super.dispose()`.

Screens normally extend `ConsumerWidget`. Obtain the store with `ref.watch` and
read `.value` inside a `SignalBuilder` around the smallest reactive subtree.
Use `ConsumerStatefulWidget` only when lifecycle hooks are required.

## Provider lifetime

`StoreProvider.counter()` creates a fresh auto-dispose provider for each route.
In `RouteScreen.counterPageRoute`, create the provider once before the route
builder and pass that provider to `CounterScreen`. This keeps concurrent route
instances independent and disposes their stores after the last listener leaves.
Do not create providers in `build()` or replace a shared static provider field.

For a new feature, add an equivalent factory to `StoreProvider` using
`createAutoDisposeStore`, and pass the resulting `Provider<FeatureStore>` through
the screen constructor. Follow Counter's complete wiring.

App-wide state follows `StoreProvider.app`: a stable provider whose factory
registers `ref.onDispose(store.dispose)`. Riverpod provides dependencies; Signals
owns reactive feature state. Read injected dependencies through `Ref` when needed.

## Routing and dependencies

1. Add the route constant to `base/dependency/router/utils/route_name.dart`.
2. Add a typed constructor to `RouteInput`.
3. Add its route factory to `RouteScreen`, creating the feature provider there.
4. Add its case to `RoutePage.onGenerateRoute`.
5. Navigate using `ref.read(AppService.router).push(const RouteInput.counter())`
   adapted to the destination, rather than raw route strings in feature code.

Keep global services behind `AppService` and obtain them through Riverpod.
Reuse existing shared code before adding helpers or dependencies.

## Localization, theme, and configuration

Use `AppLocalizations.of(context)` so screens rebuild when the app locale changes.
Add strings to both `lib/l10n/arb/app_en.arb` and `app_vi.arb`, then run
`rtk proxy flutter gen-l10n` from `app/`. Do not edit generated localization files.
Use Material components and `Theme.of(context)` instead of hardcoded colors.
Keep accessible labels/tooltips on controls and support scrolling with large text.

Flavors are `local`, `dev`, and `prod`. Keep `AppConfig` validation and native
flavor alignment intact. Only publishable Supabase keys belong in client env files.
The three env assets are bundled in every build; never put secrets in them.

## Verification

Run from `app/`:

```sh
rtk proxy dart format lib test
rtk proxy flutter analyze
rtk proxy flutter test
```

For stateful routes, test that mutations update the screen, pop disposes owned
resources, and reopening starts fresh. Use `test/starter_test.dart` as the example.
Check both locales for any changed strings. Prefer tests and static inspection;
image-based verification requires the user's approval under `AGENTS.md`.
