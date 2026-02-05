# Contributing to TimeWalker

Thank you for your interest in contributing to TimeWalker! This document provides guidelines for contributing.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

---

## Getting Started

### Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR_USERNAME/TimeWalker.git
cd TimeWalker
git remote add upstream https://github.com/kaywalker91/TimeWalker.git
```

### Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

**Branch naming convention:**
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation updates
- `test/` - Test additions/updates

---

## Development Setup

### Prerequisites

- Flutter SDK 3.10.1+
- Dart SDK 3.10.1+
- Android Studio or VS Code
- Git

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
# Default (uses local JSON data)
flutter run

# With Supabase backend (optional)
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

### Verify Setup

```bash
flutter doctor    # Check Flutter installation
flutter analyze   # Static analysis
flutter test      # Run tests
```

---

## Coding Standards

### Architecture

TimeWalker follows **Clean Architecture** with three layers:

```
Presentation (UI, Providers) → Domain (Entities, Services) → Data (Repositories, DataSources)
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | `snake_case` | `user_progress.dart` |
| Classes | `PascalCase` | `UserProgress` |
| Variables/Functions | `camelCase` | `getUserProgress()` |
| Constants | `camelCase` | `defaultTimeout` |
| Providers | `{feature}Provider` | `userProgressProvider` |
| Screens | `{Feature}Screen` | `DialogueScreen` |

### Dart/Flutter Guidelines

- Use `const` constructors where possible
- Avoid `dynamic` types
- Use `ListView.builder` instead of `ListView(children: [])`
- Reference colors from `AppColors` (no hardcoded colors)
- Add `Semantics` widgets for accessibility

### File Organization

```
lib/
├── core/           # Config, routes, themes, utilities
├── domain/         # Entities, repository interfaces, services
├── data/           # Repository implementations, data sources
├── presentation/   # Screens, widgets, providers
└── game/           # Flame game components
```

---

## Commit Guidelines

We follow **Conventional Commits** specification.

### Format

```
<type>: <description>

[optional body]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code refactoring |
| `test` | Adding/updating tests |
| `docs` | Documentation changes |
| `style` | Formatting (no code change) |
| `perf` | Performance improvement |
| `chore` | Maintenance tasks |

### Examples

```bash
feat: Add era timeline scroll animation
fix: Resolve null check error in dialogue screen
refactor: Extract character card into separate widget
test: Add unit tests for UserProgress entity
docs: Update README with Supabase setup instructions
```

### Guidelines

- Use imperative mood ("Add feature" not "Added feature")
- Keep the first line under 72 characters
- Reference issues when applicable: `fix: Resolve login error (#123)`

---

## Pull Request Process

### Before Submitting

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run checks**
   ```bash
   flutter analyze     # No errors or warnings
   flutter test        # All tests pass
   dart format lib/    # Code formatted
   ```

3. **Self-review your code**
   - Remove debug code and comments
   - Check for hardcoded values
   - Verify accessibility

### PR Template

When creating a PR, fill out the template with:
- Summary of changes
- Related issue (if any)
- Screenshots (for UI changes)
- Test plan

### Review Process

1. Create PR against `main` branch
2. Request review from maintainers
3. Address feedback
4. Squash and merge after approval

---

## Testing

### Test Structure

```
test/
├── fixtures/       # Mock JSON data
├── helpers/        # Test utilities
├── mocks/          # Mock classes
├── unit/           # Unit tests
│   ├── domain/     # Entity/service tests
│   └── presentation/  # Provider tests
├── widget/         # Widget tests
└── integration/    # Integration tests
```

### Running Tests

```bash
# All tests
flutter test

# Specific directory
flutter test test/unit/

# Specific file
flutter test test/unit/domain/entities/era_test.dart

# With coverage
flutter test --coverage
```

### Writing Tests

- Use `mocktail` for mocking
- Follow Arrange-Act-Assert pattern
- One assertion per test (prefer)
- Descriptive test names: `should [action] when [condition]`

```dart
test('should return unlocked eras when user has progress', () {
  // Arrange
  final repository = MockEraRepository();
  when(() => repository.getUnlockedEras()).thenReturn([testEra]);

  // Act
  final result = repository.getUnlockedEras();

  // Assert
  expect(result, contains(testEra));
});
```

### Coverage Targets

| Layer | Target |
|-------|--------|
| Domain (entities, services) | >= 80% |
| Presentation (providers) | >= 70% |
| Integration | Critical flows |

---

## Questions?

- Open an issue for questions or discussions
- Check existing issues before creating new ones

Thank you for contributing!
