---
name: State Management
description: TimeWalker 앱의 Riverpod 기반 상태 관리 가이드. Provider 패턴, 의존성 주입, 비동기 상태 처리 방법을 제공합니다.
---

# State Management Skill

TimeWalker 앱의 Riverpod 기반 상태 관리 패턴 가이드입니다.

## 핵심 컨셉

- **Riverpod**: 전역 상태 관리 및 의존성 주입
- **StateNotifier**: 복잡한 상태 변경 로직
- **AsyncValue**: 비동기 상태 (로딩/에러/데이터)
- **Repository 패턴**: 데이터 소스 추상화

---

## 1. Provider 구조

### 파일 구성

| 파일 | 역할 |
|------|------|
| `repository_providers.dart` | Repository 인터페이스 연결 |
| `user_progress_provider.dart` | 사용자 진행 상태 |
| `exploration_providers.dart` | Region, Era, Country, Location |
| `character_providers.dart` | Character, Dialogue |
| `content_providers.dart` | Encyclopedia, Quiz, Shop |
| `settings_provider.dart` | 앱 설정 |
| `audio_provider.dart` | BGM/효과음 |
| `theme_provider.dart` | 테마 |

### Import 방법

```dart
// 모든 Repository Provider (re-export 포함)
import 'package:time_walker/presentation/providers/repository_providers.dart';

// 개별 Provider
import 'package:time_walker/presentation/providers/user_progress_provider.dart';
```

---

## 2. Provider 유형별 사용법

### Provider (읽기 전용)

Repository 인스턴스, 서비스 등 변경되지 않는 의존성에 사용

```dart
final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  return MockRegionRepository();
});

// 사용
final repository = ref.watch(regionRepositoryProvider);
```

### StateNotifierProvider

복잡한 상태 로직이 필요한 경우 사용

```dart
final userProgressProvider = StateNotifierProvider<
    UserProgressNotifier, 
    AsyncValue<UserProgress>
>((ref) {
  final repository = ref.watch(userProgressRepositoryProvider);
  return UserProgressNotifier(repository);
});
```

### FutureProvider

단순한 비동기 데이터 로딩에 사용

```dart
final allErasProvider = FutureProvider<List<Era>>((ref) async {
  final repository = ref.watch(eraRepositoryProvider);
  return repository.getAllEras();
});
```

### FutureProvider.family

파라미터가 필요한 비동기 데이터에 사용

```dart
final characterByIdProvider = FutureProvider.family<Character?, String>(
  (ref, characterId) async {
    final repository = ref.watch(characterRepositoryProvider);
    return repository.getCharacterById(characterId);
  },
);

// 사용
final character = ref.watch(characterByIdProvider('sejong'));
```

---

## 3. AsyncValue 처리 패턴

### 위젯에서 사용

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final progressAsync = ref.watch(userProgressProvider);
  
  return progressAsync.when(
    loading: () => const LoadingWidget(),
    error: (error, stack) => ErrorWidget(error: error),
    data: (progress) => ProgressDisplay(progress: progress),
  );
}
```

### 조건부 렌더링

```dart
if (progressAsync.hasValue) {
  final progress = progressAsync.value!;
  // 데이터 사용
}

if (progressAsync.isLoading) {
  return const CircularProgressIndicator();
}
```

---

## 4. StateNotifier 패턴

### 기본 구조

```dart
class UserProgressNotifier extends StateNotifier<AsyncValue<UserProgress>> {
  final UserProgressRepository _repository;
  
  UserProgressNotifier(this._repository) : super(const AsyncLoading()) {
    _loadProgress();
  }
  
  Future<void> _loadProgress() async {
    try {
      final progress = await _repository.getUserProgress('user_001');
      if (!mounted) return;  // ⚠️ 중요: mounted 체크
      state = AsyncData(progress);
    } catch (e, stack) {
      if (mounted) state = AsyncError(e, stack);
    }
  }
  
  Future<void> updateProgress(UserProgress Function(UserProgress) updateFn) async {
    if (!state.hasValue) return;
    
    final current = state.value!;
    try {
      final updated = updateFn(current);
      await _repository.saveUserProgress(updated);
      
      if (!mounted) return;
      state = AsyncData(updated);
    } catch (e, stack) {
      if (mounted) state = AsyncError(e, stack);
    }
  }
}
```

### mounted 체크 중요성

```dart
// ✅ 올바른 패턴
Future<void> someAsyncMethod() async {
  final result = await _repository.fetch();
  if (!mounted) return;  // StateNotifier가 dispose됐으면 중단
  state = AsyncData(result);
}

// ❌ 잘못된 패턴
Future<void> someAsyncMethod() async {
  final result = await _repository.fetch();
  state = AsyncData(result);  // StateNotifier가 dispose됐으면 에러 발생
}
```

---

## 5. 의존성 주입 패턴

### Repository → Provider 연결

```dart
// 1. Repository 인터페이스 (domain 레이어)
abstract class CharacterRepository {
  Future<List<Character>> getCharactersByEra(String eraId);
}

// 2. Mock 구현 (data 레이어)
class MockCharacterRepository implements CharacterRepository {
  @override
  Future<List<Character>> getCharactersByEra(String eraId) async {
    // 구현
  }
}

// 3. Provider 연결 (presentation 레이어)
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return MockCharacterRepository();
});
```

### 환경별 구현 전환

```dart
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseLocationRepository(Supabase.instance.client);
  }
  return MockLocationRepository();  // 폴백
});
```

---

## 6. 네이밍 컨벤션

### Provider 이름

| 패턴 | 용도 | 예시 |
|------|------|------|
| `{entity}RepositoryProvider` | Repository | `characterRepositoryProvider` |
| `{entity}Provider` | 단일 데이터 | `userProgressProvider` |
| `all{Entity}sProvider` | 모든 데이터 | `allErasProvider` |
| `{entity}ByIdProvider` | ID로 조회 | `characterByIdProvider` |
| `{entity}By{Param}Provider` | 파라미터 조회 | `charactersByEraProvider` |

### StateNotifier 이름

```dart
class {Entity}Notifier extends StateNotifier<...>
```

예: `UserProgressNotifier`, `SettingsNotifier`

---

## 7. 관련 파일

| 경로 | 설명 |
|------|------|
| `lib/presentation/providers/` | 모든 Provider 정의 |
| `lib/domain/repositories/` | Repository 인터페이스 |
| `lib/data/repositories/` | Repository 구현 |
| `lib/domain/services/` | 비즈니스 로직 서비스 |

---

## 8. 새 Provider 추가 체크리스트

- [ ] 적절한 Provider 유형 선택 (Provider / FutureProvider / StateNotifierProvider)
- [ ] 파라미터가 필요하면 `.family` 사용
- [ ] AsyncValue를 사용하면 `when()` 또는 `hasValue` 처리
- [ ] StateNotifier에서 `mounted` 체크 추가
- [ ] Repository 의존성은 `ref.watch`로 주입
- [ ] 네이밍 컨벤션 준수
- [ ] 적절한 파일에 배치

---

## 9. 베스트 프랙티스

### ✅ DO

```dart
// 1. ref.watch 사용 (자동 rebuild)
final repository = ref.watch(characterRepositoryProvider);

// 2. 적절한 Provider 유형 사용
final allErasProvider = FutureProvider<List<Era>>(...);  // 간단한 fetch
final userProgressProvider = StateNotifierProvider<...>(...);  // 복잡한 로직

// 3. mounted 체크
if (!mounted) return;
state = AsyncData(result);
```

### ❌ DON'T

```dart
// 1. ref.read 남용 (rebuild 안됨)
final repository = ref.read(characterRepositoryProvider);  // ❌

// 2. 위젯에서 직접 Repository 호출
final chars = await MockCharacterRepository().getAll();  // ❌

// 3. mounted 체크 누락
state = AsyncData(result);  // dispose 후 에러 발생 ❌
```
