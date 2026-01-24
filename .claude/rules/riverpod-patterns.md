---
paths:
  - "lib/presentation/providers/**"
---

# Riverpod Provider Patterns

## Provider Hierarchy

```
Repository Providers (repository_providers.dart)
  -> UseCase Providers (usecase_providers.dart)
    -> State/UI Providers (feature-specific)
```

## Provider Types & When to Use

| Type | Use Case | Example |
|------|----------|---------|
| `Provider` | Static/computed values | Repository instances |
| `StateProvider` | Simple mutable state | Selected era index |
| `FutureProvider` | Async one-shot data | Load content list |
| `StateNotifierProvider` | Complex mutable state | User progress |
| `NotifierProvider` | Riverpod 2.0 complex state | Achievement tracking |

## Naming Conventions

```dart
// Repository provider
final eraRepositoryProvider = Provider<EraRepository>((ref) => ...);

// UseCase provider
final getErasUseCaseProvider = Provider<GetErasUseCase>((ref) => ...);

// State provider
final selectedEraProvider = StateProvider<Era?>((ref) => null);

// Notifier provider
final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgressState>(...);
```

## Required Patterns

### 1. Repository Provider Registration
```dart
// In repository_providers.dart
final xxxRepositoryProvider = Provider<XxxRepository>((ref) {
  return MockXxxRepository(); // or SupabaseXxxRepository
});
```

### 2. UseCase Provider
```dart
// In usecase_providers.dart
final xxxUseCaseProvider = Provider<XxxUseCase>((ref) {
  final repo = ref.watch(xxxRepositoryProvider);
  return XxxUseCase(repository: repo);
});
```

### 3. StateNotifier Pattern
```dart
class XxxNotifier extends StateNotifier<XxxState> {
  XxxNotifier({required this.useCase}) : super(XxxState.initial());

  final XxxUseCase useCase;

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await useCase.execute();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

## Rules

- Providers are top-level (not inside classes)
- Use `ref.watch()` for reactive dependencies
- Use `ref.read()` for one-shot actions (button callbacks)
- Keep providers in dedicated files by feature group
- Repository switching (Mock/Supabase) happens only in `repository_providers.dart`
