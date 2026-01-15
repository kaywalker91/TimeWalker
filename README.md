# TimeWalker: Echoes of the Past

**TimeWalker: Echoes of the Past**는 전 세계의 역사를 지도 탐험과 시대 여행을 통해 배우는 인터랙티브 교육 어드벤처 게임입니다.

## 🎮 프로젝트 개요
플레이어는 '타임 워커'가 되어 다양한 시대와 장소를 여행하며 역사적 사건을 체험하고, 인물들과 대화하며 숨겨진 이야기를 발견합니다.

## 🚀 주요 기능
- **인터랙티브 지도 탐험**: Flame 엔진을 활용한 몰입감 있는 지도 이동 및 탐험.
- **시대 여행 (Time Travel)**: 고대, 중세, 근대 등 다양한 역사적 시대로의 이동.
- **대화 시스템**: 역사적 인물들과의 상호작용 및 스토리 진행 (JSON 기반 스크립트).
- **교육적 콘텐츠**: 역사적 사실에 기반한 퀘스트, 백과사전, 퀴즈 제공.
- **상점 및 인벤토리**: 게임 내 재화로 아이템 구매 및 관리.
- **다국어 지원**: 한국어 및 영어 지원 (l10n).

## 🛠 기술 스택
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod
- **Game Engine**: Flame (지도 및 인터랙션 구현)
- **Local Storage**: Hive, Shared Preferences
- **Routing**: GoRouter
- **Localization**: flutter_localizations, intl

## 📂 폴더 구조
```
lib/
├── content/       # 게임 데이터 (캐릭터, 대화, 시대 정보)
├── core/          # 공통 유틸리티, 상수, 테마, 라우팅
├── data/          # 데이터 레이어 (저장소, 모델, JSON 데이터 소스)
├── domain/        # 비즈니스 로직 (엔티티, 유스케이스, 리포지토리 인터페이스)
├── game/          # Flame 게임 엔진 관련 코드
├── interactive/   # 상호작용 요소 (대화, 탐험, 지도)
├── l10n/          # 다국어 지원 (ARB 파일)
├── presentation/  # UI (화면, 위젯, 프로바이더)
└── main.dart      # 앱 진입점
tools/             # 데이터 파이프라인 및 유틸리티 스크립트
```

## 📦 설치 및 실행
1. 저장소 클론:
   ```bash
   git clone https://github.com/kaywalker91/TimeWalker.git
   ```
2. 의존성 설치:
   ```bash
   flutter pub get
   ```
3. 앱 실행:
   ```bash
   flutter run
   ```

## 🔄 최근 업데이트 (2025-12-23)

### 1. 오디오 시스템 구축
- **AudioService & AudioProvider**: BGM 및 SFX 재생을 위한 중앙 집중식 오디오 관리 시스템 구현.
- **라이프사이클 관리**: 앱 상태(백그라운드/포그라운드)에 따른 오디오 자동 일시정지 및 재개 기능 (`AppLifecycleManager`).
- **에셋 추가**: 배경음악(BGM) 및 효과음(SFX) 파일 추가 및 연동.

### 2. 콘텐츠 확장 (가야 연맹)
- **새로운 시나리오**: 가야 연맹(금관가야, 대가야) 관련 스토리 및 대화 스크립트 추가.
- **캐릭터 추가**: 김수로왕, 허황옥, 우륵 등 주요 역사적 인물 데이터 및 일러스트 추가.
- **장소 데이터**: 구지봉, 김해 왕궁 등 가야 관련 탐험 장소 업데이트.

### 3. 게임플레이 & 지도 시스템
- **Flame 기반 월드맵**: `WorldMapGame` 구조 개선, 플레이어 이동 및 위치 마커 상호작용 강화.
- **좌표 투영 (Map Projection)**: 실제 지도 좌표와 게임 내 좌표 간의 변환 로직 구현 (`MapProjection`).
- **UI 개선**: 메인 메뉴, 대화 화면, 시대 탐험, 백과사전, 퀴즈 화면 UI/UX 업데이트.

### 4. 기타

- **문서화**: 개발 계획(주차별), 캐릭터 이미지 프롬프트 등 기획 문서 추가.

- **데이터 파이프라인**: 데이터 생성 및 병합을 위한 Python 스크립트 도구 개선.



## 🔄 최근 업데이트 (2025-12-31)



### 1. UI/UX 전면 리팩토링

- **Presentation Layer 개선**: 메인 메뉴, 대화, 백과사전, 퀴즈, 상점 등 주요 화면의 UI/UX를 현대적인 디자인으로 개선.

- **공통 위젯 강화**: 재사용 가능한 공통 위젯 라이브러리 확장 (`lib/presentation/widgets/common/`).

- **테마 시스템**: 앱 전반의 일관된 디자인 언어 적용을 위한 테마 및 스타일 업데이트.



### 2. 콘텐츠 및 에셋 대규모 확장

- **캐릭터 일러스트**: 안중근, 허준, 장영실, 정조 등 다수의 역사적 인물 고해상도 일러스트 및 표정 바리에이션 추가.

- **배경 이미지**: 고구려 왕궁, 살수 대첩, 조선 시대 등 시대별/장소별 몰입감 있는 배경 이미지 추가.

- **데이터 업데이트**: 캐릭터, 대화, 백과사전, 퀴즈 관련 JSON 데이터 최신화 및 정합성 개선.



### 3. 신규 기능 및 시스템 강화

- **업적 시스템 (Achievement)**: 플레이어의 활동(퀴즈, 탐험 등)에 따른 업적 달성 및 보상 시스템 구현 (`AchievementService`).

- **상점 및 인벤토리**: 아이템 구매 로직 및 UI 개선, 상점 데이터 구조 고도화.

- **오디오 고도화**: 화면 전환 시 BGM의 자연스러운 연결 및 관리를 위한 `BgmMixin`, `BgmNavigatorObserver` 적용.

- **데이터 소스 최적화**: 성능 향상을 위한 정적 데이터 소스(`static datasources`) 구조 도입.



### 4. 기획 및 문서화

- **상세 기획안 추가**: 신라/백je/조선 시나리오, 퀴즈 확장, 업적 시스템, 캐릭터 이미지 생성 계획 등 상세 기획 문서 추가 (`docs/plans/`).

- **리팩토링 계획**: UI/UX 및 코드 구조 개선을 위한 리팩토링 로드맵 수립.



## 🔄 최근 업데이트 (2026-01-05)

### 1. 진행도/해금 기반 구조 정리
- **UserProgress 시드 정비**: 초기 해금 범위를 `UserProgressSeed.initial`로 통일하고 신규 유저 생성 경로에 적용.
- **Era/Region 기본 상태 잠금**: 시대/지역 기본 상태를 `locked`로 고정하고 해금은 진행도 기준으로만 판단.

### 2. 국가 해금 규칙/표기 개선
- **국가 잠금 로직 통일**: 국가 카드 해금 판정을 `UserProgress.unlockedCountryIds` 기준으로 일원화.
- **해금 조건 안내 문구 추가**: 국가 카드에 잠금 사유 문구 노출 (예: “삼국시대 30% 완료 시 해금”).
- **국가별 규칙 매핑**: 중국/일본/인도/몽골 등 세부 조건과 지역별 규칙 테이블 추가.

### 3. 해금 이벤트/지역 정합성 보완
- **ProgressionService 해금 이벤트 확장**: 국가 해금 이벤트 처리 및 UI 알림 반영.
- **아메리카 지역 ID 정리**: `americas`로 통일하고 기존 ID와의 호환 처리 추가.

### 4. 접근성(Accessibility) 강화
- **Semantics 적용**: `TimeButton`, `TimeCard`, `MenuButton` 등 주요 인터랙티브 위젯에 스크린 리더 지원 추가.
- **접근성 라벨링**: 버튼 동작 및 상태(잠금, 로딩 등)에 대한 명확한 라벨 및 힌트 제공.


## 🔄 최근 업데이트 (2026-01-15)

### 1. 역사 콘텐츠 대규모 확장
총 4개 Phase에 걸쳐 대규모 역사 콘텐츠를 추가하였습니다:

#### Phase 1 - 남북국시대 (698-936)
- **시대 명칭 변경**: '통일신라' → '남북국시대'로 역사적 정확성 개선
- **신라 콘텐츠**: 석굴암, 불국사, 안압지, 청해진, 장보고, 최치원 등
- **발해 콘텐츠**: 상경성, 대조영, 대무예 등 발해 관련 장소/인물 추가
- **백과사전/퀴즈**: 해상왕 장보고, 발해 해동성국 등 교육 콘텐츠 추가

#### Phase 2 - 근현대사 (1897-1950)
- **대한제국 시기**: 덕수궁, 탑골공원, 하얼빈역 등 장소 추가
- **독립운동 인물**: 안창호, 김구, 여운형 등 역사적 인물 추가
- **현대사**: 38선, 서대문형무소, 상해임시정부 등 근현대사 콘텐츠

#### Phase 3 - 고려시대 (918-1392)
- **주요 장소**: 만월대, 개경시장, 강화도, 해인사 등
- **문화유산**: 팔만대장경, 고려청자 관련 콘텐츠
- **삼별초 항쟁**: 진도 삼별초 관련 역사 콘텐츠

#### Phase 4 - 르네상스 (14th-17th Century)
- **이탈리아**: 피렌체, 로마 바티칸, 베네치아 등 장소 추가
- **유럽 확장**: 마인츠(구텐베르크), 런던 글로브극장 등
- **주요 인물**: 레오나르도 다빈치, 미켈란젤로, 갈릴레오, 셰익스피어, 구텐베르크 등
- **백과사전**: 르네상스 문화혁명, 인쇄 혁명 등 교육 콘텐츠

### 2. 이미지 에셋 대량 추가
- **40+ 신규 이미지 에셋**: 캐릭터 초상화, 장소 배경, 백과사전 삽화 등
- **왕국 아이콘**: 고구려(삼족오), 백제(연꽃), 신라(금관), 가야(검) 아이콘 추가
- **시대별 폴더 구조화**: `contemporary/`, `modern/`, `renaissance/` 등으로 정리

### 3. Supabase 통합 기반 구축
- **원격 데이터 소스**: `SupabaseContentLoader` 및 각 엔티티별 Repository 구현
- **매핑 유틸리티**: Supabase 데이터와 앱 엔티티 간 변환 로직 추가
- **설정 구성**: `SupabaseConfig`를 통한 환경 설정 관리

### 4. 테스트 및 품질 강화
- **Entity 테스트 확장**: Achievement, Character, Country, Dialogue, Encyclopedia, Era, Location, Region, Settings 등 도메인 엔티티 테스트 추가
- **Service 테스트**: `CountryUnlockRulesTest`, `ProgressionServiceTest` 추가로 비즈니스 로직 검증
- **Integration 테스트**: Provider-Repository 통합 테스트 개선

### 5. UI/UX 개선
- **삼국시대 UI 리디자인**: 왕국별 탭, 타임라인 거터, 위치 스토리 카드 등 시각적 개선
- **Era HUD Panel**: 탐험 화면 HUD 패널 UX 개선
- **설정 화면**: 개발자 옵션 및 Admin Mode 접근 추가

### 6. 기획 문서 추가
- **역사 콘텐츠 전략**: `plan_goguryeo_content_update.md`
- **삼국시대 UI 리디자인**: `three_kingdoms_ui_redesign_plan.md`
- **테스트 계획**: `test_plan_2026_01_14.md`
- **Admin Mode 구현**: `admin_mode_implementation.md`

---

## 🔄 최근 업데이트 (2026-01-12)

### 1. 엔티티 유닛 테스트 구현
- **주요 엔티티 테스트 추가**: `UserProfile`, `ExplorationState`, `UserProgress` 등 핵심 데이터 모델에 대한 유닛 테스트 작성.
- **상태 클래스 검증**: `UnlockState`, `CompletionState` 등 상태 관리 클래스의 불변성 및 copyWith 동작 검증.

### 2. UI/Widget 리팩토링 및 믹스인 적용
- **Card 위젯 구조 개선**: `CountryCard`, `EncyclopediaEntryCard`에 `TimeCardMixin`과 `ThemedCardMixin` 적용으로 코드 중복 제거 및 일관된 Hover/Press 효과 적용.
- **UI 일관성 강화**: 카드 위젯들의 동작 방식을 통일하여 유지보수성 향상.

### 3. Repository 테스트 및 코드 리뷰 반영
- **Repository Mock 테스트 강화**: `MockShopRepository` 외 상점/아이템 관련 데이터 계층 테스트 보강.
- **안정성 개선**: `BuildContext` 비동기 사용 이슈 해결 및 예외 처리 로직(`runCatching`) 다듬기.

---

## 👨‍💻 개발자 가이드

### 아키텍처 개요

TimeWalker는 **Clean Architecture** 패턴을 따릅니다:

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  (Screens, Widgets, Providers - UI 및 상태 관리)             │
├─────────────────────────────────────────────────────────────┤
│                       Domain Layer                           │
│  (Entities, Services, Repository Interfaces - 비즈니스 로직) │
├─────────────────────────────────────────────────────────────┤
│                        Data Layer                            │
│  (Repository Impls, DataSources, Models - 데이터 접근)       │
└─────────────────────────────────────────────────────────────┘
```

### 핵심 컴포넌트

| 컴포넌트 | 경로 | 역할 |
|---------|------|------|
| **Entities** | `lib/domain/entities/` | 비즈니스 객체 (UserProgress, Era, Quiz 등) |
| **Services** | `lib/domain/services/` | 도메인 로직 (AchievementService, ProgressionService) |
| **Repositories** | `lib/domain/repositories/` | 데이터 접근 인터페이스 |
| **Providers** | `lib/presentation/providers/` | Riverpod 상태 관리 |
| **Screens** | `lib/presentation/screens/` | UI 화면 |

### 에러 핸들링

앱 전체에서 일관된 에러 처리를 위해 `Result` 패턴을 사용합니다:

```dart
import 'package:time_walker/core/errors/errors.dart';

// Repository에서 Result 반환
Future<Result<UserProgress>> getUserProgress() async {
  return runCatching(() async {
    final data = await dataSource.fetch();
    return UserProgress.fromJson(data);
  });
}

// UI에서 Result 처리
final result = await getUserProgress();
result.when(
  success: (progress) => showProgress(progress),
  failure: (error) => showError(error.message),
);
```

**예외 클래스 체계:**
- `NetworkException` - 네트워크/API 오류
- `DataException` - 데이터 파싱/저장 오류
- `GameLogicException` - 게임 규칙 위반
- `AuthException` - 인증/권한 오류
- `ValidationException` - 입력값 검증 오류

### 테스트 실행

```bash
# 전체 테스트 실행
flutter test

# 유닛 테스트만 실행
flutter test test/unit/

# 특정 파일 테스트
flutter test test/unit/core/errors/result_test.dart

# 커버리지 리포트 생성
flutter test --coverage
```

**테스트 구조:**
```
test/
├── fixtures/        # Mock 데이터
├── helpers/         # 테스트 유틸리티
├── unit/            # 유닛 테스트
│   ├── core/        # 핵심 유틸리티 테스트
│   └── domain/      # 도메인 로직 테스트
├── widget/          # 위젯 테스트
└── integration/     # 통합 테스트
```

### 코드 컨벤션

1. **파일 명명**: `snake_case.dart` (예: `user_progress.dart`)
2. **클래스 명명**: `PascalCase` (예: `UserProgress`)
3. **변수/함수 명명**: `camelCase` (예: `getUserProgress`)
4. **상수 명명**: `camelCase` 또는 `SCREAMING_SNAKE_CASE`

**문서화 규칙:**
```dart
/// 클래스/함수에 대한 한 줄 설명
/// 
/// 더 자세한 설명이 필요한 경우 빈 줄 후 작성합니다.
/// 
/// [parameter] 파라미터 설명
/// 
/// Returns: 반환값 설명
/// 
/// Throws:
/// - [ExceptionType] 발생 조건
/// 
/// See also:
/// - [RelatedClass] - 관련 클래스
```

### 정적 분석

```bash
# 분석 실행
flutter analyze

# 자동 수정 가능한 이슈 수정
dart fix --apply
```

**분석 설정**: `analysis_options.yaml`에서 린트 규칙을 관리합니다.

### 브랜치 전략

- `main` - 프로덕션 코드
- `develop` - 개발 브랜치
- `feature/*` - 기능 개발
- `bugfix/*` - 버그 수정
- `release/*` - 릴리스 준비

---

## 📄 라이선스

이 프로젝트는 개인 교육 목적으로 개발되었습니다.
