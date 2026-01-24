---
paths:
  - "lib/core/routes/**"
---

# Routing Rules (go_router)

## Router Location

Single router definition in `lib/core/routes/app_router.dart`

## Route Naming

```dart
// Path pattern
'/feature'                    // Top-level screen
'/feature/:id'                // Detail screen
'/feature/:id/sub-feature'    // Nested screen
```

## Screen Name Mapping

| Route | Screen | File |
|-------|--------|------|
| `/` | SplashScreen | `splash/splash_screen.dart` |
| `/main-menu` | MainMenuScreen | `main_menu/` |
| `/time-portal` | TimePortalScreen | `time_portal/` |
| `/era-timeline` | EraTimelineScreen | `era_timeline/` |
| `/era-exploration/:eraId` | EraExplorationScreen | `era_exploration/` |
| `/encyclopedia` | EncyclopediaScreen | `encyclopedia/` |
| `/quiz` | QuizPlayScreen | `quiz/` |
| `/settings` | SettingsScreen | `settings/` |
| `/achievements` | AchievementScreen | `achievement/` |
| `/inventory` | InventoryScreen | `inventory/` |

## Navigation Pattern

```dart
// Navigate forward
context.go('/era-exploration/$eraId');
context.push('/encyclopedia/detail/$entryId');

// Navigate back
context.pop();

// With parameters
GoRoute(
  path: '/era-exploration/:eraId',
  builder: (context, state) {
    final eraId = state.pathParameters['eraId']!;
    return EraExplorationScreen(eraId: eraId);
  },
)
```

## Rules

- Use `context.go()` for top-level navigation (replaces stack)
- Use `context.push()` for detail screens (adds to stack)
- Pass minimal data via path/query parameters
- Complex data: pass entity IDs, load from provider in target screen
- Define all routes in single `app_router.dart`
- Use `redirect` for auth guards when auth is implemented
