# TimeWalker: Echoes of the Past

> Korean History Educational Adventure Game - Interactive Time Travel Experience Built with Flutter

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.10.1-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.1-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📱 Project Overview

**TimeWalker** is an interactive mobile educational adventure game that brings Korean history to life. Players become time travelers, exploring historical periods from the Three Kingdoms era to modern times, meeting over 40 historical figures, and learning through story-driven gameplay.

### Core Value Propositions

- 🎮 **Gamified Learning**: History education through engaging game mechanics
- 🗺️ **Interactive Exploration**: Beautifully rendered historical locations
- 👥 **Historical Dialogues**: Conversations with 40+ historical figures
- 📖 **Branching Stories**: Player choices impact the narrative
- 🏆 **Progress Tracking**: Personalized learning journey with achievement system

---

## 🎨 Key Screens

### 1. Main Menu
<img src="assets/screenshots/main_menu.jpg" width="300" alt="Main Menu">

**Features:**
- Dark theme-based UI design
- Premium feel with gold accent colors
- Animated clock icon (time travel theme)
- Intuitive navigation structure

**Menu Options:**
- Hall of Time: Start main historical exploration
- History Archive: View collected characters/locations
- Quiz Challenge: Test historical knowledge
- Profile/Settings/Shop/Leaderboard

---

### 2. Location Exploration
<img src="assets/screenshots/location_exploration.jpg" width="300" alt="Location Exploration">

**Features:**
- High-quality background art (historical location recreation)
- Character avatars for interaction
- Location-specific stories and quests
- List of available characters to meet

**Technology:**
- 2D rendering powered by Flame engine
- Layered background system (depth effect)
- Touch-based character selection
- Dynamic loading and caching

---

### 3. Character Card
<img src="assets/screenshots/character_card.jpg" width="300" alt="Character Card">

**Features:**
- Circular framed character portraits
- Concise historical information display
- Premium gold border design
- Modal-based interaction

**Information Structure:**
- Character name (Korean)
- Historical title/period
- Brief description
- Action buttons (Talk/Close)

---

### 4. Dialogue System
<img src="assets/screenshots/dialogue_scene.jpg" width="300" alt="Dialogue Scene">
<img src="assets/screenshots/dialogue_choices.jpg" width="300" alt="Dialogue Choices">

**Features:**
- Full-screen character portraits
- Historically contextualized dialogue
- Story-branching choices (3 options)
- Cinematic presentation

**System:**
- YAML-based dialogue script management
- Story branching based on choices
- Character-specific dialogue trees
- Progress-based dialogue unlocking

---

## 🛠️ Tech Stack

### Core Framework
```yaml
Flutter: ^3.10.1
Dart: ^3.10.1
```

### Key Packages

| Category | Package | Version | Purpose |
|---------|---------|---------|---------|
| State Management | flutter_riverpod | ^2.6.1 | Clean Architecture-based state management |
| Game Engine | flame | ^1.27.0 | 2D rendering, animations |
| Backend | supabase_flutter | ^2.6.0 | Cloud database, authentication |
| Local Storage | hive | ^2.2.3 | Offline caching, progress saving |
| Routing | go_router | ^15.1.2 | Declarative routing, deep linking |
| Animation | simple_animations | latest | Custom animations |
| | flutter_staggered_animations | latest | List animations |
| Localization | flutter_localizations | SDK | i18n support (Korean/English) |

---

## 🏗️ Architecture

### Clean Architecture Layer Structure

```
lib/
├── core/               # Common utilities, config, themes
│   ├── config/         # App configuration
│   ├── constants/      # Constants definitions
│   ├── routes/         # go_router setup
│   ├── themes/         # Material 3 themes, color system
│   └── utils/          # Helper functions
│
├── domain/             # Business Logic Layer (Pure Dart)
│   ├── entities/       # Core business entities
│   ├── repositories/   # Repository interfaces
│   ├── services/       # Domain services
│   └── usecases/       # Use cases (business rules)
│
├── data/               # Data Layer
│   ├── datasources/    # Data sources (remote/local/static)
│   ├── models/         # DTOs, serialization models
│   ├── repositories/   # Repository implementations
│   └── seeds/          # Initial data, factories
│
├── presentation/       # UI Layer
│   ├── providers/      # Riverpod providers
│   ├── screens/        # Screen-level widgets
│   ├── widgets/        # Reusable widgets
│   └── themes/         # UI theme components
│
├── game/               # Flame game components
├── content/            # Content management system
├── interactive/        # Interactive features
└── shared/             # Shared utilities
```

### Dependency Rules

```
Presentation → Domain ← Data
     ↓             ↓
  Providers    Repositories
     ↓             ↓
  UseCases    Entities
```

- **Presentation**: Calls Domain UseCases
- **Data**: Implements Domain Repository interfaces
- **Domain**: No external dependencies (pure business logic)

---

## 📊 Data Models

### Content Hierarchy

```
Region (East Asia)
  └── Country (Korea, Japan, China)
      └── Era (Three Kingdoms, Goryeo, Joseon, Modern, Contemporary)
          ├── Character (Gwanggaeto, Sejong, ...)
          │   ├── id: String
          │   ├── nameKo: String
          │   ├── nameEn: String
          │   ├── title: String
          │   ├── era: String
          │   ├── portraitPath: String
          │   ├── dialogueIds: List<String>
          │   └── unlockedByDefault: bool
          │
          └── Location (Gyeongbokgung, Cheomseongdae, ...)
              ├── id: String
              ├── nameKo: String
              ├── nameEn: String
              ├── era: String
              ├── backgroundPath: String
              ├── thumbnailPath: String
              ├── characters: List<String>
              ├── storyNodes: List<StoryNode>
              └── unlockedByDefault: bool
```

### Dialogue System

```dart
DialogueEntity
  ├── id: String
  ├── characterId: String
  ├── title: String
  ├── nodes: List<DialogueNode>
  └── metadata: Map<String, dynamic>

DialogueNode
  ├── id: String
  ├── speaker: String
  ├── text: LocalizedString
  ├── choices: List<DialogueChoice>
  └── nextNodeId: String?

DialogueChoice
  ├── text: LocalizedString
  ├── nextNodeId: String
  ├── condition: String?
  └── effects: List<String>
```

---

## 🎮 Core Features

### 1. Historical Exploration System
- **Interactive Map**: Explore historical locations by era/region
- **Character Interaction**: Dialogue with 40+ historical figures
- **Story Quests**: Missions based on historical events
- **Progress System**: Location/character unlock mechanics

### 2. Dialogue System
- **Branching Stories**: Outcomes change based on player choices
- **Conditional Dialogues**: Dialogue changes based on progress
- **Multi-language Support**: Simultaneous Korean/English support
- **YAML-based Management**: Editable dialogue scripts for non-developers

### 3. Educational Content
- **Quiz System**: Test and review historical knowledge
- **Archive System**: Browse collected character/location info
- **Timeline**: Chronological view of major historical events
- **Historical Facts**: Interactive historical information

### 4. User Experience
- **Progress Saving**: Hive-based local storage
- **Cloud Sync**: Cross-device sync via Supabase
- **Offline Mode**: Playable without network
- **Achievement System**: Achievements, leaderboards, rewards

---

## 🎯 Development Process

### 1. Requirements Analysis
- Feature specification based on PRD
- User scenario mapping
- Content hierarchy design

### 2. Architecture Design
- Clean Architecture application
- Riverpod state management pattern
- Repository pattern (Remote/Local/Static fallback)

### 3. UI/UX Design
- Material 3 design system
- Dark theme-first design
- Responsive layout (various screen sizes)
- Animation and transition design

### 4. Backend Integration
- Supabase database schema design
- Authentication system (email, social login)
- Real-time synchronization
- Offline-first strategy

### 5. Testing Strategy
```
Test Pyramid:
  - Unit Tests: Domain/Data layers (80%+ coverage)
  - Widget Tests: Reusable widgets (70%+ coverage)
  - Integration Tests: Core user flows
```

---

## 📈 Performance Optimization

### Image Optimization
- Character portraits: WebP format, 512x512px
- Background images: WebP format, 1920x1080px
- Thumbnails: WebP format, 256x256px
- Lazy loading and caching applied

### Memory Management
- Use `ListView.builder` (infinite scroll)
- Optimized image memory cache
- Automatic resource disposal

### Network Optimization
- Fallback chain: Supabase → Hive → Static JSON
- Background synchronization
- Request debouncing and caching

---

## 🚀 Deployment Strategy

### Environment Separation
- **Development**: Local development and testing
- **Staging**: Supabase staging environment
- **Production**: App Store/Play Store deployment

### CI/CD Pipeline
```yaml
GitHub Actions:
  - Automated test execution
  - Code quality checks (flutter analyze)
  - Automated builds (Android/iOS)
  - Version management and tagging
```

---

## 📝 Future Roadmap

### Phase 1: Content Expansion (Q2 2025)
- [ ] Additional era content (Unified Silla, Balhae)
- [ ] More characters (60 → 100)
- [ ] New locations (20 → 50)

### Phase 2: Enhanced Game Mechanics (Q3 2025)
- [ ] Mini-games (historical puzzles, missions)
- [ ] Item system (collectibles)
- [ ] Social features (friends, competition, cooperation)

### Phase 3: Globalization (Q4 2025)
- [ ] Expanded language support (Chinese, Japanese)
- [ ] East Asian history expansion (China, Japan)
- [ ] Global server infrastructure

---

## 🤝 Contributions & Feedback

This project welcomes feedback from history experts, educators, and developers.

### Contact
- **Developer**: Kay Walker
- **GitHub**: [Project Repository]
- **Email**: [Email Address]

---

## 📄 License

MIT License - See `LICENSE` file for details

---

## 🙏 Acknowledgments

- Flutter community open-source contributors
- Historical consultants who provided expertise
- Artists who created the artwork
- Beta testers who provided feedback

---

**TimeWalker** - *Become a Time Walker and Explore History*

![Footer](https://img.shields.io/badge/Made%20with-Flutter-02569B?logo=flutter)
![Footer](https://img.shields.io/badge/Powered%20by-Supabase-3ECF8E?logo=supabase)
