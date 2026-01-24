---
paths:
  - "test/**"
---

# Testing Rules

## Directory Structure

```
test/
  unit/
    data/
      repositories/       # Repository implementation tests
    domain/
      entities/           # Entity tests
      services/           # Service tests
      usecases/           # UseCase tests
    presentation/
      providers/          # Provider tests
  integration/            # Integration tests
  fixtures/               # Shared test data
  helpers/                # Test utilities
  mocks/                  # Shared mock classes
```

## File Naming

- Test file: `{source_file}_test.dart`
- Mock file: `{source_file}_test.mocks.dart` (mockito generated)
- Mirror source path: `test/unit/domain/entities/era_test.dart` for `lib/domain/entities/era.dart`

## Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClassName', () {
    late ClassName sut; // System Under Test

    setUp(() {
      sut = ClassName();
    });

    group('methodName', () {
      test('should do X when Y', () {
        // Arrange
        // Act
        // Assert
      });
    });
  });
}
```

## Mock Strategy

### Mockito (for repository/service mocks)
```dart
@GenerateMocks([EraRepository])
void main() { ... }
```

Run after adding annotations:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Manual Mocks (for simple cases)
- Use mock repositories from `lib/data/repositories/mock_*`
- Or create test-specific fakes in `test/mocks/`

## Provider Testing

```dart
void main() {
  test('provider returns expected state', () {
    final container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(MockRepository()),
      ],
    );
    addTearDown(container.dispose);

    final result = container.read(targetProvider);
    expect(result, expectedValue);
  });
}
```

## Coverage Targets

| Layer | Target |
|-------|--------|
| Domain entities | >= 90% |
| Domain services | >= 85% |
| Domain usecases | >= 80% |
| Data repositories | >= 75% |
| Providers | >= 70% |

## Rules

- Test behavior, not implementation
- One assertion concept per test
- Use descriptive test names: `should {expected} when {condition}`
- Don't test framework code (Flutter internals)
- Mock external dependencies (Supabase, Hive)
- Keep tests deterministic (no random, no real timers)
- Use `fixtures/` for shared test data constants
