# Flutter · Vue · Supabase Starter

Standalone starter for Android/iOS, web, and a local Supabase backend. No business
logic, sign-in flow, data tables, or linked cloud project is included.

## Structure

```text
app/        Flutter, Signals, Riverpod, English/Vietnamese, local/dev/prod
web/        Vue 3, TypeScript, Vite, Nuxt UI, Tailwind
supabase/   Supabase CLI config, empty migrations and seed
.codex/     Flutter skill for Codex
.opencode/  Flutter skill for OpenCode
.vscode/    Launch configurations for three Flutter flavors
```

Flutter uses Signals for state and Riverpod for dependency injection. The Counter
feature demonstrates screens, stores, disposal, and navigation with RouteInput.
English is the default language; language selection lasts for the current session.

## Requirements

- Flutter **3.41.5** and Dart **3.11.3** were used to create this starter.
- Node.js **22.12+**, Yarn **1.22.22**.
- Supabase CLI **2.117.0**, with Docker or a compatible container runtime running.
- Android SDK/JDK and accepted Android licenses for Android builds.
- macOS, Xcode, and CocoaPods for iOS; configure signing for releases.
- `rtk` to run the commands below, as required by this repository.

Use the Supabase CLI baseline **2.117.0**. CLI v3 changes the default target and
some commands: [changelog](https://supabase.com/changelog/supabase-cli-v3).
The starter does not automatically upgrade the CLI or link to the cloud.

## 1. Local backend

From the repository root, with Docker running:

```sh
rtk proxy supabase start
rtk proxy supabase status
```

Project ID: `flutter-vue-supabase-starter`. Ports are separate from the source project:

| Service | Address |
| --- | --- |
| API | http://127.0.0.1:55321 |
| PostgreSQL | 127.0.0.1:55322 |
| Studio | http://127.0.0.1:55323 |
| Local email | http://127.0.0.1:55324 |

Use the publishable key from the CLI output to configure the app/web. Do not copy
the entire output into client env files, as it may also contain secret keys. Run
`rtk proxy supabase stop` at the root to stop this stack while preserving its data.

There is no business schema yet. When needed, create a migration with
`rtk proxy supabase migration new <name>`, enable RLS on exposed tables, and write
policies for the required access. Review migrations and seeds from other projects
before copying them.

## 2. Flutter app

Run these commands in `app/`:

```sh
rtk proxy cp env/.env.local.example env/.env.local
rtk proxy cp env/.env.dev.example env/.env.dev
rtk proxy cp env/.env.prod.example env/.env.prod
rtk proxy flutter pub get
rtk proxy flutter gen-l10n
```

All three files must exist because they are declared as Flutter assets. Set the
URL and publishable key for the environment you want to run:

```dotenv
SUPABASE_URL=http://127.0.0.1:55321
SUPABASE_PUBLISHABLE_KEY=sb_publishable_your_local_key
```

| Local device | SUPABASE_URL |
| --- | --- |
| iOS Simulator | http://127.0.0.1:55321 |
| Android Emulator | http://10.0.2.2:55321 |
| Physical device | LAN IP of the machine running Supabase, port 55321 |

```sh
rtk proxy flutter run --flavor local
```

| Flavor | Display name | Application/bundle ID |
| --- | --- | --- |
| local | Starter Local | com.example.starterapp.local |
| dev | Starter Dev | com.example.starterapp.dev |
| prod | Starter | com.example.starterapp |

Use `--flavor dev` or `--flavor prod` with the corresponding environment file
configured; both environments require HTTPS. If you pass `APP_ENV`, its value must
match the flavor. All three launch configurations are available in VS Code when
you open the repository root.

**All env assets are bundled in every build.** Include only URLs and publishable
keys; never include secret/service-role keys, passwords, or private tokens. Real
env files are ignored by Git. Values containing `replace_me` are placeholders and
do not establish a working backend connection. Restart the app after changing
configuration.

## 3. Web

Run in `web/`:

```sh
rtk proxy yarn install --frozen-lockfile
rtk proxy cp .env.localdev.example .env.localdev.local
rtk proxy cp .env.development.example .env.development.local
rtk proxy cp .env.production.example .env.production.local
```

Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` for the mode you need.
Separate filenames prevent local values from overriding development/production.

```sh
rtk proxy yarn dev:local
```

The local web app runs at http://127.0.0.1:5173. `yarn dev:development` uses the
cloud dev configuration. All `VITE_*` variables are readable in the browser; use
only publishable keys. The client is initialized at startup; the Home page does
not query data or require sign-in yet. Missing or invalid configuration stops
startup with an error message.

## Checks

In `app/`:

```sh
rtk proxy flutter analyze
rtk proxy flutter test
rtk proxy flutter build apk --debug --flavor local
rtk proxy flutter build ios --simulator --debug --no-codesign --flavor local
```

In `web/`:

```sh
rtk proxy yarn typecheck
rtk proxy yarn test
rtk proxy yarn build:local
rtk proxy yarn build:development
rtk proxy yarn build:production
```

Builds require the corresponding env assets/environment files. A successful build
does not prove that the URL/key is correct or that the backend is reachable.

## Flutter skills and adding features

- Codex: invoke `$flutter-arch`; the skill is in `.codex/skills/flutter-arch/`.
- OpenCode: invoke `@flutter-arch`; the skill is in `.opencode/skills/flutter-arch/`.
- Both are opt-in and describe the starter's actual architecture.
- Start from `app/lib/features/counter/`; add a screen/store, provider factory,
  RouteName, RouteInput, RouteScreen, and RoutePage. Create the provider once per
  route and pass it to the screen to keep state separate between visits.
- Add strings to both ARB files and run `rtk proxy flutter gen-l10n`; do not edit
  generated files.
- Keep both skills and the corresponding tests in sync when changing architecture
  conventions.

## Renaming for a new product

- Rename the Dart package in `app/pubspec.yaml` and every `package:starter_app/` import.
- Android: update namespace/applicationId in `app/android/app/build.gradle.kts`,
  MainActivity's Kotlin package and directory, and the display names in each flavor.
- iOS: update bundle IDs for Runner/RunnerTests and every build configuration, plus
  `APP_DISPLAY_NAME` in Xcode. Keep distinct suffixes for local/dev flavors.
- Rename the web app in `web/package.json`, `web/index.html`, and `web/src/App.vue`.
- Change the Supabase project ID/ports before the first run if creating another
  starter alongside this one; update the env examples accordingly. Different
  project IDs still conflict if they use the same ports.
- Update both skills when renaming the package. Set up icons/branding and signing
  before release; Android release currently uses Flutter's default debug signing.

CI/CD, auth flows, persistence, business logic, monitoring, and cloud deployment
are not included yet.

## Initial verification results (2026-11-05)

- Flutter analyzer passed; 20 regular tests passed, plus a separate flavor
  configuration test.
- Local debug builds succeeded for Android APK and iOS Simulator.
- Web: 3 configuration tests and local/development/production builds passed.
- Both skills passed validation; schemes and bundle IDs were checked statically.
- Supabase started locally; `select 1` returned `ok = 1`.
- Local env files contain this stack's publishable key and are ignored by Git.
- The headless Chrome DOM check timed out; the browser UI has not been verified.
- Physical devices, release builds/signing, and cloud dev/prod backends have not
  been tested.
