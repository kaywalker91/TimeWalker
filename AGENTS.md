# Repository Guidelines

## Project Structure & Module Organization
- `lib/` holds app code (core utilities, data/domain layers, game, UI, and `main.dart` entry point).
- `assets/` contains images, audio, and content data referenced in `pubspec.yaml`.
- `test/` contains Flutter tests (currently `widget_test.dart`).
- `android/` and `ios/` are platform projects managed by Flutter tooling.
- `docs/` and `tools/` store project docs and utility scripts.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies from `pubspec.yaml`.
- `flutter run` launches the app on a connected device or simulator.
- `flutter test` runs the Flutter test suite in `test/`.
- `flutter analyze` runs static analysis using `analysis_options.yaml`.
- `flutter build apk` or `flutter build ios` produces release builds.
- `flutter gen-l10n` regenerates localization code from `lib/l10n/` (when ARB files change).

## Coding Style & Naming Conventions
- Use standard Dart/Flutter formatting (2-space indentation); run `dart format .` before pushing.
- Lint rules come from `analysis_options.yaml` via `flutter_lints`; address analyzer warnings.
- File names are `lower_snake_case.dart`; classes and enums are `UpperCamelCase`.
- Avoid editing generated files such as `lib/l10n/generated/`.

## Testing Guidelines
- Place tests in `test/` and name them `*_test.dart`.
- Prefer `testWidgets` for UI behavior and use `WidgetTester` to drive interactions.
- Keep tests deterministic; mock external services or data sources where needed.

## Localization & Assets
- ARB files live in `lib/l10n/` and generate code into `lib/l10n/generated/` per `l10n.yaml`.
- Add new assets under `assets/` and register paths in `pubspec.yaml`.

## Commit & Pull Request Guidelines
- Follow the existing commit style: `Type: short description` (for example, `Feature: add era timeline`).
- Pull requests should include a clear summary, linked issues if applicable, and test notes.
- Include screenshots or short clips for UI changes and note any manual test steps.
