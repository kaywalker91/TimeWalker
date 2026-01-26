# TimeWalker: Echoes of the Past

Korean history education adventure game with interactive map exploration and time travel.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart ^3.10.1) |
| State | flutter_riverpod ^2.6.1 |
| Game Engine | Flame ^1.27.0 |
| Backend | Supabase (supabase_flutter ^2.6.0) |
| Local Storage | Hive ^2.2.3 |
| Routing | go_router ^15.1.2 |
| Animations | simple_animations, flutter_staggered_animations |

## Architecture (Clean Architecture)

```
lib/
  core/        # config, constants, errors, extensions, routes, services, themes, utils
  domain/      # entities, repositories(interfaces), services, usecases, value_objects, constants
  data/        # datasources(local/remote/static), models, repositories(impl), seeds
  presentation/ # providers, screens, widgets, themes, constants
  game/        # Flame game components
  content/     # Content management
  interactive/ # Interactive features
  shared/      # Shared utilities
```

### Layer Dependencies
- `presentation` -> `domain` (via providers/usecases)
- `data` -> `domain` (implements repository interfaces)
- `domain` -> nothing (pure business logic)
- `core` -> nothing (shared utilities)

## Content Hierarchy

```
Region (동아시아)
  -> Country (한국, 일본, 중국)
    -> Era (삼국시대, 고려시대, 조선시대)
      -> Character (이순신, 세종대왕)
      -> Location (경복궁, 첨성대)
```

## Key Conventions

### Naming
- **Bilingual**: Entity fields use English names, display values in Korean
- **File naming**: `lower_snake_case.dart`
- **Classes**: `UpperCamelCase`
- **Providers**: `{feature}Provider`, `{feature}NotifierProvider`
- **Screens**: `{Feature}Screen` in `lib/presentation/screens/{feature}/`

### Colors & Theme
- Use `AppColors` from `lib/core/themes/app_colors.dart` - never hardcode colors
- Dark theme focused design system

### Provider Pattern
- Riverpod providers in `lib/presentation/providers/`
- Repository providers -> UseCase providers -> UI state providers

### Data Sources
- **Static**: `lib/data/datasources/static/` (bundled JSON data)
- **Remote**: `lib/data/datasources/remote/` (Supabase)
- **Local**: `lib/data/datasources/local/` (Hive cache)
- Fallback chain: Remote -> Local cache -> Static

## Build & Test Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run on connected device
flutter test             # Run all tests
flutter analyze          # Static analysis
flutter build apk        # Android release build
flutter build ios        # iOS release build
dart format .            # Format code
flutter gen-l10n         # Regenerate localizations
```

### Test Commands
```bash
flutter test test/unit/                    # Unit tests only
flutter test test/integration/             # Integration tests
flutter test --coverage                    # With coverage
flutter test test/unit/domain/             # Domain layer tests
flutter test test/unit/presentation/       # Presentation tests
```

## Commit Style

```
Type: short description

Types: feat, fix, refactor, test, docs, chore, style, perf
Example: feat: Add era timeline scroll animation
```

## Key Paths

| Path | Purpose |
|------|---------|
| `lib/core/routes/app_router.dart` | go_router configuration |
| `lib/core/themes/app_colors.dart` | Color system |
| `lib/presentation/providers/` | All Riverpod providers |
| `lib/domain/entities/` | Business entities |
| `lib/domain/repositories/` | Repository interfaces |
| `lib/data/repositories/` | Repository implementations |
| `lib/data/datasources/static/` | Static data sources |
| `lib/data/datasources/remote/` | Supabase data sources |
| `lib/data/seeds/` | Default data factories |
| `assets/data/` | JSON content files |
| `test/unit/` | Unit tests |
| `test/integration/` | Integration tests |

## Current Status

- **Branch**: `feature/supabase-migration` - Supabase backend integration in progress
- Phase 1-3 of Supabase migration completed
- Static data -> Supabase migration with offline fallback

## References

- PRD: `docs/PRD.md`
- Supabase Migration: `docs/supabase_migration_plan.md`
- Agent Skills: `.agent/skills/`
