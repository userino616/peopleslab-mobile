# Repository Guidelines

## Project Structure & Module Organization
- `lib/app`: app root, shells, navigation.
- `lib/core`: config, DI, theme, routing, gRPC, utilities.
- `lib/features/<name>/presentation`: pages/widgets per feature.
- `lib/features/<name>/data`: repositories/clients.
- `lib/common`: shared UI widgets.
- `lib/l10n`: ARB and generated localization files.
- `test`: mirrors `lib/` with `*_test.dart` files.
- `android`, `ios`: platform setup; `packages/peopleslab_api`: local stubs (optional).

## Build, Test, and Development Commands
- `flutter pub get` — install dependencies.
- `flutter run` — run on a connected device/emulator.
- `flutter test` — run unit/widget tests.
- `flutter analyze` — static analysis per `analysis_options.yaml`.
- `dart format .` — format Dart code (2‑space indent).
- `make l10n-generate` or `flutter gen-l10n` — generate localization from ARB.
- `make dump-lib` — write `dump.txt` with concatenated `lib/` sources (debugging/support).
- Production builds: `flutter build apk` (Android), `flutter build ios` (iOS archive).

## Coding Style & Naming Conventions
- Follow `flutter_lints`; keep imports clean and avoid dead code.
- Files: `snake_case.dart`; classes/types: `PascalCase`; vars/methods: `camelCase`.
- Widgets in `presentation/widgets`; repositories end with `Repository`; providers end with `Provider`.
- Keep widgets small and composable; prefer const where possible.

## Testing Guidelines
- Framework: `flutter_test`.
- Place tests under `test/` mirroring `lib/` (e.g., `test/core/utils/validators_test.dart`).
- Name tests `*_test.dart`; prefer focused unit tests, add widget tests for pages.
- Coverage: aim for meaningful coverage; run `flutter test --coverage` when changing core logic.

## Commit & Pull Request Guidelines
- Commits: imperative mood, concise subject. Examples: `refactor auth provider`, `fix token refresh`.
- PRs must include: clear description, linked issues, screenshots for UI changes, test plan, and notes about localization or config updates.
- CI hygiene: ensure `flutter analyze` and `flutter test` pass; run l10n generation if ARB changed and commit generated files.

## Security & Configuration Tips
- gRPC endpoint in `lib/core/config/app_config.dart`; use dev values locally and review before release.
- Secrets and tokens are stored via `flutter_secure_storage`; never commit real credentials.
