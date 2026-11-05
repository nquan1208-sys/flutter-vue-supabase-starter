# Project instructions

- Run Flutter commands in `app/`, Yarn commands in `web/`, and Supabase CLI commands at the repository root.
- Prefix shell commands with `rtk`; use `rtk proxy <command>` for raw output.
- Use code inspection, static analysis, and automated tests for routine verification. Do not capture screenshots or perform image-based verification unless necessary and approved by the user.
- Flutter architecture: invoke `$flutter-arch` in Codex or `@flutter-arch` in OpenCode when requested. Follow the Counter example for screen/store/provider/router wiring.
- Use publishable keys only in mobile/browser configuration. Never commit real environment files or secret/service-role keys.
- Supabase CLI baseline is 2.117.0. Do not change hosted projects without a task that calls for it.
