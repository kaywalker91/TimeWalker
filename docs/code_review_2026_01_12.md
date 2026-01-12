# 🔍 Time Walker 프로젝트 코드리뷰

**작성일**: 2026-01-12  
**작성자**: 100년차 Flutter 코드리뷰 전문가 AI  
**프로젝트**: Time Walker - Echoes of the Past  
**종합 평가**: **B+ (8.0/10)**

---

## 📋 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [아키텍처 분석](#2-아키텍처-분석)
3. [왜 이렇게 생성했나: 설계 이유](#3-왜-이렇게-생성했나-설계-이유)
4. [3단계 자가 점검 알고리즘](#4-3단계-자가-점검-알고리즘)
5. [발견된 이슈 및 개선점](#5-발견된-이슈-및-개선점)
6. [단계별 실행 방법](#6-단계별-실행-방법)
7. [사용한 도구 및 MCP 활용 브리핑](#7-사용한-도구-및-mcp-활용-브리핑)

---

## 1. 프로젝트 개요

### 1.1 프로젝트 설명
전 세계의 역사를 지도 탐험과 시대 여행을 통해 배우는 **인터랙티브 교육 어드벤처 게임**

### 1.2 기술 스택
| 영역 | 기술 |
|------|------|
| 프레임워크 | Flutter 3.10.1+ |
| 상태 관리 | Riverpod 2.6.1 |
| 게임 엔진 | Flame 1.27.0 |
| 로컬 저장소 | Hive 2.2.3 |
| 라우팅 | Go Router 15.1.2 |
| 다국어 | flutter_localizations |

### 1.3 프로젝트 구조
```
lib/
├── main.dart                 # 앱 진입점
├── core/                     # 핵심 유틸리티
│   ├── constants/            # 상수 및 설정
│   ├── errors/               # 에러 정의
│   ├── routes/               # 라우팅
│   ├── services/             # 서비스 레이어
│   ├── themes/               # 테마 시스템
│   └── utils/                # 유틸리티
├── data/                     # 데이터 레이어
│   ├── datasources/          # 데이터 소스
│   ├── models/               # Hive 모델
│   ├── repositories/         # Repository 구현체
│   └── seeds/                # 초기 데이터
├── domain/                   # 도메인 레이어
│   ├── entities/             # 엔티티 (25개)
│   ├── repositories/         # Repository 인터페이스
│   ├── services/             # 도메인 서비스
│   └── usecases/             # 유스케이스
├── presentation/             # 프레젠테이션 레이어
│   ├── providers/            # Riverpod Providers
│   ├── screens/              # 화면 (20+ 스크린)
│   └── widgets/              # 공통 위젯
└── game/                     # Flame 게임 모듈
```

---

## 2. 아키텍처 분석

### 2.1 Clean Architecture 적용 ✅

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────────┐  ┌─────────────────┐                   │
│  │    Screens      │  │    Widgets      │                   │
│  └────────┬────────┘  └────────┬────────┘                   │
│           │                    │                             │
│  ┌────────▼────────────────────▼────────┐                   │
│  │           Riverpod Providers          │                   │
│  └────────────────────┬─────────────────┘                   │
└───────────────────────┼─────────────────────────────────────┘
                        │
┌───────────────────────┼─────────────────────────────────────┐
│                       │     Domain Layer                     │
│  ┌────────────────────▼────────────────────┐                │
│  │              Entities                    │                │
│  │  (UserProgress, Era, Character, ...)    │                │
│  └────────────────────┬────────────────────┘                │
│                       │                                      │
│  ┌────────────────────▼────────────────────┐                │
│  │         Repository Interfaces            │                │
│  └────────────────────┬────────────────────┘                │
│                       │                                      │
│  ┌────────────────────▼────────────────────┐                │
│  │           Domain Services                │                │
│  │     (ProgressionService, ...)           │                │
│  └─────────────────────────────────────────┘                │
└───────────────────────┬─────────────────────────────────────┘
                        │
┌───────────────────────┼─────────────────────────────────────┐
│                       │     Data Layer                       │
│  ┌────────────────────▼────────────────────┐                │
│  │       Repository Implementations         │                │
│  │  (HiveUserProgressRepository, ...)      │                │
│  └────────────────────┬────────────────────┘                │
│                       │                                      │
│  ┌────────────────────▼────────────────────┐                │
│  │            Data Sources                  │                │
│  │   (Hive, Static Data, Mock Data)        │                │
│  └─────────────────────────────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 점수표

| 평가 항목 | 점수 | 비고 |
|-----------|------|------|
| Clean Architecture 적용 | 9/10 | 레이어 분리 우수 |
| State 관리 | 8/10 | Riverpod 잘 활용 |
| 코드 품질 | 7/10 | 일부 경고 존재 |
| 테스트 커버리지 | 3/10 | 테스트 스킵됨 |
| 문서화 | 9/10 | DocString 우수 |
| 접근성 | 8/10 | Semantics 적용 |

---

## 3. 왜 이렇게 생성했나: 설계 이유

### 3.1 Clean Architecture 채택 이유

```dart
// ✅ 좋은 예: Repository 인터페이스 분리
abstract class UserProgressRepository {
  Future<UserProgress?> getUserProgress(String userId);
  Future<void> saveUserProgress(UserProgress progress);
}
```

**채택 이유**:
1. **테스트 용이성**: Mock Repository로 쉽게 교체 가능
2. **확장성**: Firebase, Supabase 등 다른 백엔드로 쉽게 전환
3. **관심사 분리**: UI는 데이터 저장 방식을 모름

### 3.2 Equatable 사용 이유

```dart
// lib/domain/entities/user_progress.dart
class UserProgress extends Equatable {
  // ... fields ...
  
  @override
  List<Object?> get props => [userId, totalKnowledge, rank, ...];
}
```

**채택 이유**:
1. **불변성 보장**: Entity 수정 시 새 객체 생성
2. **비교 효율성**: Riverpod 상태 비교에 필수
3. **버그 방지**: 의도치 않은 상태 변이 방지

### 3.3 StateNotifier + AsyncValue 패턴 사용 이유

```dart
// lib/presentation/providers/user_progress_provider.dart
class UserProgressNotifier extends StateNotifier<AsyncValue<UserProgress>> {
  UserProgressNotifier(...) : super(const AsyncLoading()) {
    _loadProgress();
  }
}
```

**채택 이유**:
1. **로딩/에러/데이터 상태 표현**: UI에서 깔끔하게 처리
2. **비동기 안전성**: 초기화 중 상태 관리
3. **Riverpod 통합**: ref.watch로 자동 리빌드

### 3.4 TimeCard 위젯의 Variant 패턴

```dart
// lib/presentation/widgets/common/time_card.dart
enum TimeCardVariant {
  standard,   // 기본 카드
  highlight,  // 강조 카드 (골드 테두리)
  selected,   // 선택된 카드
  locked,     // 잠긴 카드
  success,    // 성공/완료 카드
}
```

**채택 이유**:
1. **일관성**: 앱 전체에서 동일한 카드 스타일
2. **재사용성**: 다양한 상황에서 같은 위젯 사용
3. **유지보수**: 스타일 변경 시 한 곳만 수정

---

## 4. 3단계 자가 점검 알고리즘

### 4.1 점검 알고리즘 정의

```
┌────────────────────────────────────────────────────────┐
│               자가 점검 알고리즘 v1.0                   │
├────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  1차 점검: SOLID 원칙 준수도                     │   │
│  │  ├─ S: Single Responsibility                    │   │
│  │  ├─ O: Open/Closed                              │   │
│  │  ├─ L: Liskov Substitution                      │   │
│  │  ├─ I: Interface Segregation                    │   │
│  │  └─ D: Dependency Inversion                     │   │
│  └─────────────────────────────────────────────────┘   │
│                         ▼                               │
│  ┌─────────────────────────────────────────────────┐   │
│  │  2차 점검: Flutter Best Practices                │   │
│  │  ├─ Widget 분리 적절성                          │   │
│  │  ├─ State 관리 효율성                           │   │
│  │  ├─ 메모리 누수 방지                            │   │
│  │  ├─ 비동기 처리 안전성                          │   │
│  │  └─ 접근성(Semantics) 적용                      │   │
│  └─────────────────────────────────────────────────┘   │
│                         ▼                               │
│  ┌─────────────────────────────────────────────────┐   │
│  │  3차 점검: 유지보수성 및 확장성                  │   │
│  │  ├─ 코드 중복 여부                               │   │
│  │  ├─ 테스트 가능성                                │   │
│  │  ├─ 문서화 수준                                  │   │
│  │  └─ 에러 핸들링                                  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
└────────────────────────────────────────────────────────┘
```

### 4.2 1차 점검 결과 (SOLID)

| 원칙 | 상태 | 분석 |
|------|------|------|
| **S** | ⚠️ | `UserProgress` 엔티티가 23개 필드로 과도한 책임 |
| **O** | ✅ | Repository 인터페이스로 확장에 열림 |
| **L** | ✅ | `HiveUserProgressRepository`가 인터페이스 완벽 구현 |
| **I** | ✅ | Repository별로 적절히 분리됨 |
| **D** | ✅ | Riverpod Provider로 DI 잘 적용됨 |

**S 위반 사례**:
```dart
// lib/domain/entities/user_progress.dart
class UserProgress extends Equatable {
  final String userId;
  final int totalKnowledge;
  final ExplorerRank rank;
  final Map<String, double> regionProgress;     // 탐험 관련
  final Map<String, double> countryProgress;    // 탐험 관련
  final Map<String, double> eraProgress;        // 탐험 관련
  final List<String> completedDialogueIds;      // 완료 상태
  final List<String> unlockedRegionIds;         // 해금 상태
  final List<String> unlockedCountryIds;        // 해금 상태
  // ... 15개 더 ...
}
```

**개선 방안**:
```dart
// 분리된 설계 제안
class UserProfile { userId, rank, coins, loginStreak }
class ExplorationProgress { regionProgress, countryProgress, eraProgress }
class UnlockState { unlockedRegionIds, unlockedCountryIds, unlockedEraIds }
class CompletionState { completedDialogueIds, completedQuizIds }
```

### 4.3 2차 점검 결과 (Flutter Best Practices)

| 항목 | 상태 | 분석 |
|------|------|------|
| Widget 분리 | ✅ | TimeCard, EraCard 등 잘 분리됨 |
| State 관리 | ✅ | StateNotifier + AsyncValue 패턴 우수 |
| 메모리 관리 | ✅ | Hive Box lazy initialization 적용 |
| 비동기 처리 | ❌ | `BuildContext` async gap 문제 발견 |
| 접근성 | ✅ | Semantics 위젯 적용됨 |

**비동기 처리 문제**:
```dart
// lib/presentation/screens/quiz/quiz_play_screen.dart:93
// ❌ 문제: async gap 후 BuildContext 사용
await someAsyncOperation();
context.showSnackBar(...);  // mounted 체크 필요!
```

### 4.4 3차 점검 결과 (유지보수성)

| 항목 | 상태 | 분석 |
|------|------|------|
| 코드 중복 | ⚠️ | TimeCard/EraCard hover 로직 중복 |
| 테스트 | ❌ | widget_test.dart 스킵됨 |
| 문서화 | ✅ | DocString, 예제 코드 포함 |
| 에러 핸들링 | ✅ | try-catch, rethrow 적절히 사용 |

---

## 5. 발견된 이슈 및 개선점

### 5.1 🔴 Critical (즉시 수정 필요)

#### Issue #1: BuildContext async gap

**파일**: `lib/presentation/screens/quiz/quiz_play_screen.dart`  
**라인**: 93, 122

```dart
// ❌ Before (문제 코드)
Future<void> _handleAnswer() async {
  await _processAnswer();
  context.showSnackBar(...);  // 위험!
}

// ✅ After (수정 코드)
Future<void> _handleAnswer() async {
  await _processAnswer();
  if (!mounted) return;  // mounted 체크 추가
  context.showSnackBar(...);
}
```

#### Issue #2: 불필요한 언더스코어

**파일**: `lib/presentation/screens/settings/settings_screen.dart:65`  
**파일**: `lib/presentation/screens/quiz/quiz_play_screen.dart:451`

```dart
// ❌ Before
} catch (e, __) {
  
// ✅ After
} catch (e, _) {
```

### 5.2 🟡 High Priority (주요 개선)

#### Issue #3: UserProgress 엔티티 비대화

**현재 상태**: 23개 필드, 323줄
**권장**: 4개 하위 엔티티로 분리

#### Issue #4: deprecated 필드 유지

```dart
// lib/domain/entities/user_progress.dart:20
final List<String> discoveredEncyclopediaIds; // deprecated, 하위 호환성
```

**권장**: 마이그레이션 후 제거

#### Issue #5: 테스트 스킵

```dart
// test/widget_test.dart:16
}, skip: true); // 앱 초기화 시 BGM 타이머로 인해 일시 스킵
```

**권장**: AudioProvider 모킹으로 테스트 활성화

### 5.3 🟢 Nice-to-have (향후 개선)

#### Issue #6: Hardcoded 테스트 값

```dart
// lib/domain/entities/user_progress.dart:51
this.coins = 99999, // 기본 코인 제공 (테스트용)
```

**권장**: 환경 변수 또는 설정 파일로 분리

#### Issue #7: Widget 중복 코드

```dart
// TimeCard와 EraCard의 hover/press 로직이 유사함
// 권장: Mixin 또는 추상 클래스로 통합
mixin InteractiveCardMixin<T extends StatefulWidget> on State<T> {
  bool isHovered = false;
  bool isPressed = false;
  
  void handleHoverEnter() => setState(() => isHovered = true);
  void handleHoverExit() => setState(() => isHovered = false);
  void handlePressDown() => setState(() => isPressed = true);
  void handlePressUp() => setState(() => isPressed = false);
}
```

---

## 6. 단계별 실행 방법

### Phase 1: 긴급 수정 (1일차)

```bash
# 1. Dart 분석 경고 확인
flutter analyze

# 2. 경고 0개로 만들기
```

**수정할 파일**:
1. `lib/presentation/screens/quiz/quiz_play_screen.dart`
   - Line 93: mounted 체크 추가
   - Line 122: mounted 체크 추가
   - Line 451: `__` → `_`

2. `lib/presentation/screens/settings/settings_screen.dart`
   - Line 65: `__` → `_`

### Phase 2: 테스트 기반 다지기 (2-3일차)

```dart
// 1. test/widget_test.dart 수정
void main() {
  // AudioProvider 모킹 추가
  late MockAudioProvider mockAudio;
  
  setUp(() {
    mockAudio = MockAudioProvider();
  });

  testWidgets('App launches without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioProvider.overrideWithValue(mockAudio),
        ],
        child: const TimeRunnerApp(),
      ),
    );
    
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
```

### Phase 3: 리팩토링 (4-7일차)

#### 3.1 UserProgress 분리

```dart
// lib/domain/entities/user_profile.dart
class UserProfile extends Equatable {
  final String userId;
  final ExplorerRank rank;
  final int coins;
  final int loginStreak;
  final DateTime? lastPlayedAt;
  final int totalPlayTimeMinutes;
  final bool hasCompletedTutorial;
  
  // ...
}

// lib/domain/entities/exploration_state.dart
class ExplorationState extends Equatable {
  final Map<String, double> regionProgress;
  final Map<String, double> countryProgress;
  final Map<String, double> eraProgress;
  final int totalKnowledge;
  
  // ...
}

// lib/domain/entities/unlock_state.dart
class UnlockState extends Equatable {
  final List<String> unlockedRegionIds;
  final List<String> unlockedCountryIds;
  final List<String> unlockedEraIds;
  final List<String> unlockedCharacterIds;
  
  // ...
}
```

#### 3.2 InteractiveCardMixin 도입

```dart
// lib/presentation/widgets/mixins/interactive_card_mixin.dart
mixin InteractiveCardMixin<T extends StatefulWidget> on State<T> {
  bool _isHovered = false;
  bool _isPressed = false;
  
  bool get isHovered => _isHovered;
  bool get isPressed => _isPressed;
  
  void onHoverEnter() => setState(() => _isHovered = true);
  void onHoverExit() => setState(() => _isHovered = false);
  void onPressDown() => setState(() => _isPressed = true);
  void onPressUp() => setState(() => _isPressed = false);
  void onPressCancel() => setState(() => _isPressed = false);
  
  Widget buildInteractiveWrapper({
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    if (onTap == null && onLongPress == null) return child;
    
    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: GestureDetector(
        onTapDown: (_) => onPressDown(),
        onTapUp: (_) => onPressUp(),
        onTapCancel: onPressCancel,
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
```

### Phase 4: 품질 향상 (8-14일차)

1. **Repository 단위 테스트 작성**
2. **Firebase 연동 준비** (주석 처리된 부분 활성화)
3. **통합 테스트** 작성

---

## 7. 사용한 도구 및 MCP 활용 브리핑

### 7.1 활용한 MCP 서버

| MCP 서버 | 용도 | 활용 시점 |
|----------|------|----------|
| **dart-mcp-server** | Dart 정적 분석 | 프로젝트 분석 시 `analyze_files` 호출 |
| **sequential-thinking** | 체계적 사고 프로세스 | 코드리뷰 로직 구조화 (6단계) |

### 7.2 dart-mcp-server 활용

```
도구: mcp_dart-mcp-server_analyze_files
시점: 프로젝트 전체 분석 시
결과: 4개 Dart 경고 발견
  - use_build_context_synchronously (2건)
  - unnecessary_underscores (2건)
```

### 7.3 sequential-thinking 활용

```
도구: mcp_sequential-thinking_sequentialthinking
시점: 코드리뷰 로직 구조화 시
단계:
  1. 프로젝트 아키텍처 분석
  2. 점검 알고리즘 생성
  3. Flutter Best Practices 점검
  4. 개선 방안 도출
  5. 우선순위 결정
  6. 실행 계획 수립
```

### 7.4 SubAgent 활용 (가능한 경우)

필요시 Browser SubAgent를 활용하여:
- Flutter 공식 문서 참조
- 최신 Riverpod 패턴 확인
- Material 3 가이드라인 검토

---

## 📊 최종 요약

### 강점 ✅
1. **Clean Architecture** 패턴 잘 적용
2. **Riverpod** 상태 관리 효율적
3. **DocString** 문서화 우수
4. **Semantics** 접근성 적용
5. **Repository** 인터페이스 분리 우수

### 개선 필요 ⚠️
1. **테스트 커버리지** 매우 낮음
2. **UserProgress** 엔티티 분리 필요
3. **BuildContext async** 문제 수정 필요
4. **deprecated 필드** 정리 필요
5. **위젯 중복 코드** 리팩토링 필요

### 권장 조치
1. 🔴 **즉시**: BuildContext 문제 수정
2. 🟡 **1주 내**: 테스트 활성화
3. 🟢 **2주 내**: UserProgress 리팩토링

---

*이 코드리뷰는 dart-mcp-server와 sequential-thinking MCP를 활용하여 체계적으로 작성되었습니다.*
