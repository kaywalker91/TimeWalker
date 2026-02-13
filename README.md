<div align="center">

# TimeWalker: Echoes of the Past

**Interactive history education game with time travel and map exploration**

[![Flutter](https://img.shields.io/badge/Flutter-3.10.1-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.1-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3FCF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-Private-red)]()

[Features](#features) | [Quick Start](#quick-start) | [Screenshots](#screenshots) | [Documentation](#documentation)

</div>

---

## Features

| Feature | Description |
|---------|-------------|
| **World Map** | Flame-based interactive map with real coordinate projection |
| **Time Travel** | Explore eras from Three Kingdoms to Modern Korea, Renaissance to Industrial Revolution |
| **Dialogue System** | JSON-based scripts with historical figures and branching choices |
| **Encyclopedia** | Historical events, figures, and cultural information |
| **Quiz System** | Knowledge checks with rewards |
| **Progression** | Achievements, unlocks, inventory, and shop |
| **i18n** | Korean / English |

---

## Quick Start

```bash
# 1. Clone & install
git clone https://github.com/kaywalker91/TimeWalker.git
cd TimeWalker && flutter pub get

# 2. Run
flutter run

# 3. (Optional) With Supabase backend
flutter run --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<key>
```

> Without Supabase config, the app automatically uses bundled JSON data.

---

## Screenshots

<div align="center">
<table>
  <tr>
    <td align="center"><b>Main Menu</b></td>
    <td align="center"><b>Location Exploration</b></td>
    <td align="center"><b>Character Card</b></td>
  </tr>
  <tr>
    <td><img src="docs/assets/screenshots/main_menu.jpg" width="200"/></td>
    <td><img src="docs/assets/screenshots/location_exploration.jpg" width="200"/></td>
    <td><img src="docs/assets/screenshots/character_card.jpg" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><b>Dialogue Scene</b></td>
    <td align="center"><b>Dialogue Choices</b></td>
    <td></td>
  </tr>
  <tr>
    <td><img src="docs/assets/screenshots/dialogue_scene.jpg" width="200"/></td>
    <td><img src="docs/assets/screenshots/dialogue_choices.jpg" width="200"/></td>
    <td></td>
  </tr>
</table>
</div>

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.10.1 |
| State | Riverpod 2.6.1 |
| Game Engine | Flame 1.27.0 |
| Backend | Supabase |
| Local Storage | Hive |
| Routing | go_router |

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

---

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | Clean Architecture, layers, data flow |
| [Contributing](CONTRIBUTING.md) | Development setup, coding standards, PR process |
| [Changelog](CHANGELOG.md) | Version history |
| [PRD](docs/TimeWalker_PRD.md) | Product requirements |
| [Security](SECURITY.md) | Vulnerability reporting |
| [Development Plans](docs/plans/) | Feature and scenario plans |

---

## Roadmap

### Current (v0.11)
- I18n content system
- Player avatar customization
- Profile and dialogue UI redesign

### Next (v1.0)
- Firebase Crashlytics integration
- Tutorial system
- Additional era content

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

```bash
# Development workflow
flutter analyze    # Check code
flutter test       # Run tests
flutter format .   # Format code
```

---

## Pre-Production Checklist

| Item | Status | Action |
|------|--------|--------|
| Contemporary/Future character images | Placeholder | Replace with actual images |
| BGM/SFX (19 files) | Dummy audio | Replace with licensed audio |
| Privacy policy / Terms | Not implemented | Implement before release |

---

## License

This project is developed for educational purposes.

---

<div align="center">

**Made with love for History Education**

</div>
