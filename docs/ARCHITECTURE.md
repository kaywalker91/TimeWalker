# TimeWalker Architecture

> Last updated: 2026-02-05

This document describes the architecture, patterns, and key decisions of the TimeWalker project.

## Table of Contents

- [Overview](#overview)
- [Clean Architecture](#clean-architecture)
- [Directory Structure](#directory-structure)
- [Tech Stack](#tech-stack)
- [Data Flow](#data-flow)
- [State Management](#state-management)
- [Content Hierarchy](#content-hierarchy)
- [Key Decisions](#key-decisions)

---

## Overview

TimeWalker is a Flutter-based educational game that teaches history through interactive exploration. The app follows Clean Architecture principles to ensure maintainability, testability, and separation of concerns.

---

## Clean Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        🎨 PRESENTATION LAYER                            │
│                                                                         │
│   Screens        Widgets        Providers        Themes                 │
│   (UI Views)     (Components)   (Riverpod)       (Design System)        │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                          ▼ depends on ▼                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                        🏛️ DOMAIN LAYER                                  │
│                                                                         │
│   Entities       Services       Repository        UseCases              │
│   (Business      (Business      Interfaces        (Application          │
│    Objects)       Logic)        (Contracts)        Logic)               │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                          ▲ implements ▲                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                        💾 DATA LAYER                                    │
│                                                                         │
│   Repository     DataSources        Models         Seeds                │
│   Impls          (Remote/Local/     (DTOs)         (Default Data)       │
│                   Static)                                               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Layer Dependencies

| Layer | Can Depend On | Cannot Depend On |
|-------|---------------|------------------|
| Presentation | Domain, Core | Data |
| Domain | Nothing | Presentation, Data |
| Data | Domain | Presentation |
| Core | Nothing | Any layer |

---

## Directory Structure

```
time_walker/
├── lib/
│   ├── main.dart                    # App entry point
│   │
│   ├── core/                        # Shared utilities (no dependencies)
│   │   ├── config/                  # App configuration (Supabase, etc.)
│   │   ├── constants/               # App-wide constants
│   │   ├── errors/                  # Error handling (Result pattern)
│   │   ├── extensions/              # Dart/Flutter extensions
│   │   ├── routes/                  # GoRouter configuration
│   │   ├── services/                # Core services (Audio, etc.)
│   │   ├── themes/                  # Design system (colors, typography)
│   │   └── utils/                   # Utility functions
│   │
│   ├── domain/                      # Business logic (pure Dart)
│   │   ├── entities/                # Business entities
│   │   │   ├── achievement.dart
│   │   │   ├── character.dart
│   │   │   ├── country.dart
│   │   │   ├── era.dart
│   │   │   ├── location.dart
│   │   │   ├── quiz.dart
│   │   │   └── user_progress.dart
│   │   ├── repositories/            # Repository interfaces (contracts)
│   │   ├── services/                # Domain services
│   │   │   ├── achievement_service.dart
│   │   │   ├── country_unlock_rules.dart
│   │   │   └── progression_service.dart
│   │   └── usecases/                # Application use cases
│   │
│   ├── data/                        # Data access
│   │   ├── datasources/
│   │   │   ├── local/               # Hive (offline cache)
│   │   │   ├── remote/              # Supabase (backend)
│   │   │   └── static/              # Bundled JSON data
│   │   ├── models/                  # Data transfer objects
│   │   ├── repositories/            # Repository implementations
│   │   └── seeds/                   # Default/initial data factories
│   │
│   ├── presentation/                # UI layer
│   │   ├── providers/               # Riverpod state management
│   │   ├── screens/                 # Screen widgets
│   │   │   ├── main_menu/
│   │   │   ├── time_portal/
│   │   │   ├── era_exploration/
│   │   │   ├── dialogue/
│   │   │   ├── encyclopedia/
│   │   │   ├── quiz/
│   │   │   └── ...
│   │   └── widgets/                 # Reusable components
│   │       └── common/
│   │
│   ├── game/                        # Flame game engine
│   │   └── world_map/               # Interactive world map
│   │
│   └── l10n/                        # Internationalization
│       ├── app_ko.arb               # Korean
│       └── app_en.arb               # English
│
├── assets/
│   ├── audio/                       # BGM, SFX
│   ├── data/                        # JSON content files
│   │   ├── characters.json
│   │   ├── locations.json
│   │   ├── dialogues.json
│   │   ├── encyclopedia.json
│   │   └── quizzes.json
│   ├── icons/
│   └── images/
│       ├── characters/
│       ├── locations/
│       └── ui/
│
├── test/
│   ├── fixtures/                    # Test data
│   ├── helpers/                     # Test utilities
│   ├── mocks/                       # Mock objects
│   ├── unit/                        # Unit tests
│   ├── widget/                      # Widget tests
│   └── integration/                 # Integration tests
│
└── docs/                            # Documentation
```

---

## Tech Stack

### Core Framework

| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.10.1 | Cross-platform UI framework |
| Dart | 3.10.1 | Programming language |

### State Management & Architecture

| Technology | Version | Purpose |
|------------|---------|---------|
| flutter_riverpod | 2.6.1 | Reactive state management |
| go_router | 15.1.2 | Declarative routing |

### Game Engine

| Technology | Version | Purpose |
|------------|---------|---------|
| flame | 1.27.0 | 2D game engine (world map) |
| flame_audio | 2.10.5 | Audio playback |

### Backend & Storage

| Technology | Version | Purpose |
|------------|---------|---------|
| supabase_flutter | 2.6.0 | Backend (auth, database) |
| hive | 2.2.3 | Local storage (offline cache) |

### UI & Animation

| Technology | Version | Purpose |
|------------|---------|---------|
| flutter_svg | 2.0.9 | SVG rendering |
| shimmer | 3.0.0 | Loading effects |
| simple_animations | 5.2.0 | UI animations |

---

## Data Flow

### Fallback Chain

```
┌──────────────────┐
│  Remote Source   │  Supabase (if configured)
│  (Supabase)      │
└────────┬─────────┘
         │ fails or not configured
         ▼
┌──────────────────┐
│  Local Cache     │  Hive (previously fetched data)
│  (Hive)          │
└────────┬─────────┘
         │ cache miss
         ▼
┌──────────────────┐
│  Static Source   │  Bundled JSON (always available)
│  (JSON)          │
└──────────────────┘
```

### Repository Pattern

```dart
// Domain layer: Interface
abstract class CharacterRepository {
  Future<List<Character>> getCharacters();
  Future<Character?> getCharacterById(String id);
}

// Data layer: Implementation
class SupabaseCharacterRepository implements CharacterRepository {
  final SupabaseClient _client;
  final HiveService _cache;
  final StaticCharacterDataSource _static;

  @override
  Future<List<Character>> getCharacters() async {
    // 1. Try remote
    // 2. Fallback to cache
    // 3. Fallback to static
  }
}
```

### Error Handling

The app uses a `Result` pattern for type-safe error handling:

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException error;
  const Failure(this.error);
}
```

---

## State Management

### Riverpod Provider Hierarchy

```
Repository Providers (Data access)
         │
         ▼
UseCase Providers (Business logic)
         │
         ▼
State Notifier Providers (UI state)
         │
         ▼
UI Widgets (Presentation)
```

### Provider Examples

```dart
// Repository provider
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return SupabaseCharacterRepository(...);
});

// UseCase provider
final getCharactersProvider = FutureProvider<List<Character>>((ref) {
  final repo = ref.watch(characterRepositoryProvider);
  return repo.getCharacters();
});

// State notifier for complex state
final explorationStateProvider = StateNotifierProvider<ExplorationNotifier, ExplorationState>((ref) {
  return ExplorationNotifier(ref);
});
```

---

## Content Hierarchy

```
Region (e.g., East Asia, Europe)
  │
  └── Country (e.g., Korea, Japan, China)
        │
        └── Era (e.g., Three Kingdoms, Goryeo, Joseon)
              │
              ├── Characters (e.g., King Sejong, Admiral Yi)
              │
              └── Locations (e.g., Gyeongbokgung, Cheomseongdae)
                    │
                    └── Dialogues, Quizzes, Encyclopedia entries
```

### Content IDs

- Characters: `{era}_{name}` (e.g., `joseon_sejong`)
- Locations: `{era}_{location}` (e.g., `joseon_gyeongbokgung`)
- Dialogues: `{type}_{era}_{topic}` (e.g., `crossover_joseon_meeting`)

---

## Key Decisions

### Why Clean Architecture?

- **Testability**: Domain layer is pure Dart, easily unit tested
- **Maintainability**: Clear boundaries between concerns
- **Flexibility**: Can swap implementations (e.g., Supabase → Firebase)

### Why Riverpod over BLoC?

- Less boilerplate code
- Better compile-time safety
- Easier testing with provider overrides
- Natural fit for Clean Architecture

### Why Flame for World Map?

- Native Flutter integration
- Efficient 2D rendering
- Built-in game loop and input handling
- Good community and documentation

### Why Hybrid Backend (Supabase + Local)?

- **Offline-first**: App works without internet
- **Graceful degradation**: Falls back to cached/static data
- **Future-proof**: Backend can be added incrementally

### Why Hive over SharedPreferences?

- Type-safe with code generation
- Better performance for complex objects
- Support for encryption (future: secure storage)

---

## Related Documents

- [TimeWalker PRD](TimeWalker_PRD.md) - Product requirements
- [Development Plan](development_plan.md) - Roadmap
- [Contributing Guide](../CONTRIBUTING.md) - Development guidelines
