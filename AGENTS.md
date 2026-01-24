# Repository Guidelines

## Build & Test Commands

```bash
flutter pub get              # Install dependencies
flutter run                  # Launch app
flutter test                 # Run test suite
flutter analyze              # Static analysis
flutter build apk            # Android release
flutter build ios            # iOS release
dart format .                # Format code
dart run build_runner build --delete-conflicting-outputs  # Generate mocks
```

## Quick Reference

- Architecture, conventions, and patterns: `.claude/CLAUDE.md`
- Path-specific rules: `.claude/rules/`
- Agent skills: `.agent/skills/`

## Commit Style

```
Type: short description
Types: feat, fix, refactor, test, docs, chore, style, perf
```
