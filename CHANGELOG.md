# Changelog

All notable changes to TimeWalker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.11.0] - 2026-02-13

### Added
- **New Character Images** (15 historical figures)
  - Joseon era: Hwang Jini, Kim Siseup, Shin Saimdang, Taejo Yi Seong-gye, Toegye Yi Hwang, Yeongjo, Yulgok Yi I
  - Modern era: Empress Myeongseong, Heungseon Daewongun, Yun Bong-gil
  - Three Kingdoms: Hyeokgeose, Jumong, Munju, Muryeong, Onjo
- **New Location Images** (9 locations with backgrounds/thumbnails)
  - Deoksugung Palace, Gongsanseong Fortress, Gwanggaeto Stele, Hwangnyongsa Temple
  - Jolbon Castle, Seonggyungwan Academy, Shanghai Provisional Government
- **I18n Content System**
  - `LocalizedString` entity for multilingual content
  - `I18nContentLoader` data source for structured i18n loading
  - `i18nProvider`, `characterI18nProvider`, `locationI18nProvider` for runtime localization
  - Structured `assets/data/i18n/` directory with JSON content
- **Settings System Enhancement**
  - `SettingsRepository` interface in domain layer
  - `SharedPrefsSettingsRepository` implementation with locale management
  - Enhanced `Settings` entity with locale support
- **Player Avatar System**
  - `PlayerAvatars` constants with avatar presets
  - Profile customization support
- **Layout Specifications**
  - `EraExplorationLayoutSpec` for responsive era exploration UI
  - `ProfileLayoutSpec` for profile screen layout guidelines
- **Documentation**
  - Quiz i18n README in domain layer
- **Data Transformation Scripts**
  - `scripts/transform_characters.py`, `transform_dialogues.py`, `transform_locations.py`, `transform_quizzes.py`
  - Migration utilities for content data format updates
- **Utility Scripts**
  - `check_metadata_gaps.py` - content validation
  - `find_empty_assets.py` - asset integrity check
  - `fix_character_connections.py`, `fix_metadata.py` - data correction tools
  - `list_locations_by_era.py` - content organization
- **Agent Skills**
  - `flutter-text-overlap-guard` skill for UI text overflow prevention
- **Test Coverage**
  - I18n content loader tests (`test/unit/data/datasources/`)
  - LocalizedString entity tests
  - Era exploration widget tests (`test/presentation/screens/era_exploration/`)
  - Profile screen widget tests (`test/presentation/screens/profile/`)
  - Common widget tests (`test/presentation/widgets/`)

### Changed
- **App Icons**: Updated launcher icons for iOS and Android (all densities, 30-50% file size reduction)
- **Content Data**: Major updates with localization support
  - `characters.json` (2,343 lines changed)
  - `dialogues.json` (20,428 lines added - expanded dialogue content)
  - `locations.json` (873 lines changed)
  - `quizzes.json` (828 lines changed)
- **Entities**: Enhanced with localization
  - `Character` (97 lines changed) - i18n name/bio/specialty
  - `Location` (63 lines changed) - i18n name/description
  - `DialogueEntity` (49 lines changed), `DialogueNode` (50 lines changed), `DialogueChoice` (64 lines changed)
  - `Settings` (+12 lines) - locale field
  - `UserProgress` (19 lines changed)
- **Data Layer**
  - `DialogueYamlParser` (49 lines changed) - improved parsing logic
  - `StaticEraData` (17 lines changed) - era metadata updates
  - `HiveUserProgressRepository` (102 lines changed) - enhanced caching
  - `MockDialogueRepository` (29 lines changed), `MockLocationRepository` (12 lines changed)
- **Providers**
  - `SettingsProvider` (39 lines changed) - locale management integration
  - `UserProgressProvider` (97 lines changed) - improved state management
  - `RepositoryProviders` (+10 lines) - settings repository provider
- **UI/UX Overhaul**
  - **Profile Screen** (372 lines changed) - complete redesign with avatar selection, stats display
  - **Profile Header Widgets** (398 lines changed) - modular header components
  - **Dialogue Screen** (62 lines changed) - enhanced visual presentation
  - **Dialogue View Model** (99 lines changed) - improved dialogue flow logic
  - **Dialogue Widgets**
    - Character Portrait (87 lines added) - emotion-based portraits
    - Dialogue Box (226 lines changed) - speech bubble redesign
    - Dialogue Choices Panel (66 lines changed) - choice UI improvements
  - **Era Exploration Screen** (189 lines changed) - navigation and UX improvements
  - **Era Exploration Widgets**
    - Enhanced Kingdom Tabs (127 lines changed)
    - Era HUD Panel (204 lines changed) - status display redesign
    - Era Status Bar (93 lines changed)
    - Kingdom Location Sheet (53 lines changed)
    - Location Detail Sheet (46 lines changed)
    - Location Story Card (650 lines changed) - major refactor
  - **Location Exploration Screen** (56 lines changed)
  - **Character Interaction Popup** (72 lines changed)
- **Localization**: +32 English strings, +1 Korean string in ARB files
- **Dependencies**: Updated packages in `pubspec.yaml` and `pubspec.lock`
- **Progression Service** (30 lines changed) - unlock logic improvements
- **README**: Updated screenshot paths (`docs/screenshots` → `docs/assets/screenshots`), added portfolio documentation links

### Fixed
- Test mock implementations (`test/mocks/`)
- Repository unit tests with updated data structures

### Removed
- Deleted placeholder: `assets/images/characters/contemporary/kim_gu.png`

## [0.10.0] - 2026-02-05

### Added
- **Quiz System Refactor**
  - `QuizPlayProvider` with proper state management (extracted from screen)
  - New widget components: `QuizOptionCard`, `QuizTimerWidget`, `QuizResultSheet`, `QuizItemButton`
  - Quiz summary card for result display
- **AppColors Opacity Variants**
  - Complete white opacity series (white, white70, white60, white54, white38, white30, white24, white12, white10)
  - Complete black opacity series (black, black87, black54, black45, black38, black26)
  - Eliminates need for `Colors.white.withValues()` throughout codebase
- **Era Exploration Improvements**
  - `EraStatusBar` widget for progress display
  - `StoryNodeTile` for narrative content display
  - `ExplorationSearchBar` for content filtering
  - `ExplorationStatCircle` for statistics visualization
  - `CompactLocationTile` for condensed location display
- **New Character Images**
  - Future era emotion variants: byeolhaneul, han_jinue, hanaro, pureunsol, youngwon (happy/sad/thoughtful)
  - Goryeo: jeong_mongju, yi_seong_gye
  - Unified Silla: cheoyong, uisang
  - Contemporary: imf_survivor, refugee_merchant, sewing_worker
- **New Location Images** (40+ images)
  - Egypt: pyramids, luxor, alexandria, abushimbel
  - China Three Kingdoms: changan, chengdu, chibi, jianye, luoyang_wei, wuzhang_plains
  - Japan: azuchi_castle, edo_castle, honnoji, osaka_castle, sekigahara
  - Contemporary Korea: ddp_dongdaemun, gangnam_teheran, gwanghwamun_1987, incheon_airport, seoul_expressway, seoul_olympic_stadium
  - Industrial/Modern: crystal_palace, steam_factory, ulsan_shipyard
  - Korean War era: busan_provisional_capital, cheonggyecheon_1950, gukje_market, pyeonghwa_market
- **New Era Background**: unified_silla.png
- **New BGM**: unified_silla.mp3
- **App Icon Update**: New launcher icons for iOS and Android (all densities)
- **Core Infrastructure**
  - `AppDurations` constants for animation timing consistency
  - `HiveAdapters` for local storage type adapters
  - `CivilizationRepository` interface
  - `MockCivilizationRepository` implementation
  - `UnlockEvent` entity for unlock tracking
- **Test Infrastructure**
  - Centralized `mock_repositories.dart` for test mocks
  - Supabase repository unit tests (character, dialogue, encyclopedia, location, quiz)
  - Quiz play provider unit tests
  - Quiz presentation tests

### Changed
- **Quiz Play Screen**: Complete refactor to use provider-based state management (859 -> 355 lines)
- **Quiz Screen**: Simplified with better component separation
- **Quiz Card/Filter**: Improved UI components with cleaner code
- **Era Exploration Screen**: Major refactoring (823 lines changed), extracted kingdom metadata and timeline ordering
- **Exploration List Sheet**: Enhanced with new UI patterns
- **Theme System**: Standardized color usage across all widgets (removed direct Colors.white/black usage)
- **Dialogue System**
  - Enhanced `DialogueEntity` with additional fields
  - `DialogueChoice` improvements
  - `DialogueRepository` interface expansion
- **Repository Implementations**: Improved error handling and caching in all Supabase repositories
- **Progression Service**: Enhanced progression logic (97 lines changed)
- **User Progress Usecases**: Extended functionality
- **Character Portrait Widget**: Major enhancement (120 lines changed)
- **Settings Screen**: UI improvements and reorganization
- **Localization**: Added 50+ new Korean and English strings

### Fixed
- Removed deprecated mock files (mockito-generated `.mocks.dart` files replaced with mocktail)
- Fixed test utilities and integration tests
- Improved Hive service initialization

### Removed
- Legacy mock generation files (user_progress_usecases_test.mocks.dart, content_providers_test.mocks.dart, etc.)

## [0.9.0] - 2026-01-28

### Added
- Crossover dialogue system with unified `crossover_` prefix
- New crossover dialogue: "AI and Social Change" (Sejong x Da Vinci x COEX)
- Dialogue screen background image support
- `GameSettings.developerMode` field
- Developer Mode toggle switch in settings screen

### Changed
- Renamed crossover dialogue IDs from `connect_` to `crossover_` prefix
- Renamed "Meeting of Geniuses" dialogue to "Timeslip: Seoul 2024"
- Improved character dialogue list filtering (dialogueIds-based for crossover inclusion)
- Simplified dialogue selection sheet (removed lock logic)

### Fixed
- Location detail sheet ListView structure
- Removed unnecessary comments and duplicate logic in dialogue screen

## [0.8.0] - 2026-01-26

### Added
- Achievement repository, service, and usecase with new achievement data
- Default progress factory for initial unlock/reward flow
- Dialogue data expansion and dialogue choice UI
- Renaissance character images
- Era theme registry and color/coordinate utilities
- Image cache service for loading optimization
- `.claude/` rules and `.agent/skills` guide

### Changed
- Character/location/encyclopedia data updates
- Era portal/exploration panel/background effects improvements

### Fixed
- Unlock rules and related test improvements

## [0.7.0] - 2026-01-15

### Added
- **Supabase Backend Integration (Phase 1-3 Complete)**
  - 449 items migrated: Characters (62), Dialogues (64), Locations (59), Encyclopedia (194), Quizzes (70)
  - Migration tools in `tools/supabase/`: `migrate_data.py`, `validate_data.py`, `schema.sql`, `load.sql`
  - Hybrid architecture: Supabase + local JSON fallback
  - Offline caching with Hive

- **Historical Content Expansion**
  - North-South States Period (698-936): Silla sites, Balhae content
  - Modern Era (1897-1950): Korean Empire, Independence Movement
  - Goryeo Dynasty (918-1392): Manwoldae, Gaegyeong Market, Ganghwa Island
  - Renaissance (14-17th century): Florence, Rome Vatican, Venice, Mainz, London Globe

- 40+ new images (characters, locations, encyclopedia)
- Kingdom icons: Goguryeo (three-legged crow), Baekje (lotus), Silla (gold crown), Gaya (sword)

### Changed
- Period name from "Unified Silla" to "North-South States Period" for historical accuracy
- Three Kingdoms UI redesign

## [0.6.0] - 2026-01-12

### Added
- Entity unit tests: `UserProfile`, `ExplorationState`, `UserProgress`
- Repository mock test enhancements

### Changed
- Card widget refactoring with `TimeCardMixin`, `ThemedCardMixin`

## [0.5.0] - 2026-01-05

### Added
- Country unlock rule improvement with unlock condition descriptions
- Accessibility enhancement with Semantics on major widgets

### Changed
- UserProgress seed standardization to `UserProgressSeed.initial`

## [0.4.0] - 2025-12-31

### Added
- Achievement system with `AchievementService`
- New characters: An Jung-geun, Heo Jun, Jang Yeong-sil, Jeongjo

### Changed
- UI/UX overhaul: main menu, encyclopedia, quiz, shop design improvements

## [0.3.0] - 2025-12-23

### Added
- Audio system with `AudioService` for BGM/SFX management
- Gaya Federation content: King Suro, Queen Heo, Ureuk
- Flame world map coordinate projection system

---

## Version History Summary

| Version | Date | Highlights |
|---------|------|------------|
| 0.11.0 | 2026-02-13 | I18n system, 24 new images, profile/dialogue redesign |
| 0.10.0 | 2026-02-05 | Quiz refactor, color system, 40+ new images |
| 0.9.0 | 2026-01-28 | Crossover dialogue system, developer mode |
| 0.8.0 | 2026-01-26 | Achievement system expansion, Renaissance content |
| 0.7.0 | 2026-01-15 | Supabase integration, major content expansion |
| 0.6.0 | 2026-01-12 | Entity tests, card widget refactoring |
| 0.5.0 | 2026-01-05 | Accessibility, unlock rules |
| 0.4.0 | 2025-12-31 | Achievement system, UI overhaul |
| 0.3.0 | 2025-12-23 | Audio system, Gaya content |

[Unreleased]: https://github.com/kaywalker91/TimeWalker/compare/v0.11.0...HEAD
[0.11.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/kaywalker91/TimeWalker/releases/tag/v0.3.0
