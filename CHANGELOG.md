# Changelog

All notable changes to TimeWalker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
| 0.9.0 | 2026-01-28 | Crossover dialogue system, developer mode |
| 0.8.0 | 2026-01-26 | Achievement system expansion, Renaissance content |
| 0.7.0 | 2026-01-15 | Supabase integration, major content expansion |
| 0.6.0 | 2026-01-12 | Entity tests, card widget refactoring |
| 0.5.0 | 2026-01-05 | Accessibility, unlock rules |
| 0.4.0 | 2025-12-31 | Achievement system, UI overhaul |
| 0.3.0 | 2025-12-23 | Audio system, Gaya content |

[Unreleased]: https://github.com/kaywalker91/TimeWalker/compare/v0.9.0...HEAD
[0.9.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/kaywalker91/TimeWalker/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/kaywalker91/TimeWalker/releases/tag/v0.3.0
