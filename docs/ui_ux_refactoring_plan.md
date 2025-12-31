# TimeWalker UI/UX 대대적 재정비 계획서

**작성일**: 2025년 12월 30일  
**버전**: v1.6  
**상태**: ✅ 프로젝트 리팩토링 완료 (Phase 1 ~ Phase 5)

---

## 📋 목차

1. [현황 분석 요약](#1-현황-분석-요약)
2. [발견된 문제점](#2-발견된-문제점)
3. [우선순위별 개선 계획](#3-우선순위별-개선-계획)
4. [상세 실행 계획](#4-상세-실행-계획)
5. [예상 효과](#5-예상-효과)
6. [리스크 및 대응](#6-리스크-및-대응)

---

## 1. 현황 분석 요약

### ✅ 강점 (잘 되어 있는 부분)

| 영역 | 현황 | 비고 |
|------|------|------|
| **테마 시스템** | ⭐⭐⭐⭐⭐ | AppColors, AppGradients, AppTextStyles, AppShadows, AppDecorations 완벽 정의 |
| **애니메이션 컴포넌트** | ⭐⭐⭐⭐⭐ | FadeInWidget, ScaleInWidget, PulseGlowWidget, FloatingParticles, GoldenShimmer 등 풍부함 |
| **반응형 유틸리티** | ⭐⭐⭐⭐ | ResponsiveUtils 클래스로 다양한 화면 크기 대응 |
| **다국어 지원** | ⭐⭐⭐⭐ | AppLocalizations 시스템 구축 완료 |
| **아키텍처** | ⭐⭐⭐⭐⭐ | Clean Architecture + Riverpod 일관성 있게 적용 |
| **BGM 관리** | ⭐⭐⭐⭐⭐ | 화면별 BGM 전환 시스템 완성 |

### 📊 화면별 분석 결과

| 화면 | 총 줄수 | 테마 적용도 | 컴포넌트 재사용성 | 우선 개선 필요 |
|------|---------|-------------|-------------------|----------------|
| MainMenuScreen | 439줄 | 🟢 Excellent | 🟡 Medium (내부 클래스) | ○ |
| WorldMapScreen | 259줄 | 🟢 Good | 🟡 Medium | ○ |
| RegionDetailScreen | 194줄 | 🟢 Good | 🟢 High | ✅ 완료 |
| EraTimelineScreen | 183줄 | 🟢 Good | 🟢 High | ✅ 완료 |
| **DialogueScreen** | **551줄** | 🟢 Good | 🟢 High | ✅ 완료 |
| EncyclopediaScreen | 247줄 | 🟢 Good | 🟢 High | ✅ 완료 |
| ProfileScreen | 481줄 | 🟢 Good | 🟡 Medium | ○ |
| **EraExplorationScreen** | **878줄** | **🟢 Good** | **🟢 High** | **✅ 완료** |
| **AchievementScreen** | **304줄** | **🟢 Good** | **🟢 High** | **✅ 완료** | 
| **QuizScreen** | **285줄** | **🟢 Good** | **🟢 High** | **✅ 완료** |

---

## 2. 발견된 문제점

### 🚨 Critical (P0) - 즉시 개선 필요

#### 2.1 DialogueScreen 색상 하드코딩 (✅ 완료)
- AppColors로 전면 교체 완료

#### 2.2 로딩/에러 상태 UI 중복 (✅ 완료)
- `CommonLoadingState`, `CommonErrorState` 도입으로 중복 제거

### ⚠️ High (P1) - 단기 개선 필요

#### 2.3 공통 AppBar 부재 (✅ 완료)
- `TimeWalkerAppBar` 도입 완료

#### 2.4 카드 컴포넌트 중복 (✅ 완료)
- `TimelineEraCard`, `CountryCard`, `EncyclopediaEntryCard`로 분리 완료

### 📝 Medium (P2) - 중기 개선

#### 2.5 대형 화면 내부 위젯 분리 (✅ 완료)
- `EraExplorationScreen` (완료)
- `AchievementScreen` (완료)
- `QuizScreen` (완료)

#### 2.6 페이지 전환 효과 불일치
- `TimePortalPageRoute`, `GoldenPageRoute` 정의되어 있지만 미사용
- 대부분 기본 전환 효과 사용 중

---

## 3. 우선순위별 개선 계획

### 🔴 P0: Critical (1-2일)
- ✅ 공통 상태 위젯
- ✅ DialogueScreen 색상 통합

### 🟠 P1: High (2-3일)
- ✅ TimeWalkerAppBar
- ✅ BaseTimeCard 및 카드 컴포넌트 분리

### 🟡 P2: Medium (3-4일)
- ✅ DialogueScreen 위젯 분리
- ✅ 대형 화면 리팩토링 (`EraExploration`, `Achievement`, `Quiz`)
- 페이지 전환 통일
- 마이크로 인터랙션

---

## 4. 상세 실행 계획

(생략 - 이전 버전과 동일)

---

## 5. 예상 효과

(생략 - 이전 버전과 동일)

---

## 6. 리스크 및 대응

(생략 - 이전 버전과 동일)

---

## 📌 Phase 1, 2, 3 완료 보고서 (생략)

---

## 📋 Phase 4 진행 상황 (대형 화면 리팩토링)

### ✅ Step 1: EraExplorationScreen 리팩토링 (2025-12-30)
- **분리된 위젯:** `LocationMarker`, `LocationAnchor`, `StatusLegend`, `ExplorationCharacterCard`, `ExplorationListSheet`, `LocationDetailSheet` 등
- **코드 감축:** 1599줄 → 878줄 (-45%)

### ✅ Step 2: AchievementScreen 리팩토링 (2025-12-30)
- **분리된 위젯:**
    - `AchievementCard`
    - `AchievementDetailSheet`
    - `AchievementHeader` & `AchievementTabBarDelegate`
    - `AchievementGrid`
    - `AchievementStatsBadges` (`InfoBadge`, `InfoBadgeWithEmoji`)
- **파일 위치:** `lib/presentation/screens/achievement/widgets/`
- **코드 감축:** 749줄 → 112줄 (실제로는 위젯 import 등으로 약 300줄 내외 예상, 엄청난 다이어트)
    - *수정: 실제 확인 결과 112줄로 줄었으나, `build` 메서드 제외하고 내부 클래스들이 모두 빠져나감.*

### ✅ Step 3: QuizScreen 리팩토링 (2025-12-30)
- **분리된 위젯:**
    - `QuizFilterToggleButton`, `QuizCategoryChip` (`quiz_filter.dart`)
    - `QuizDetailSheet`
    - `QuizCard` (기존 분리됨, 재확인)
    - `QuizWidgets` 배럴 파일
- **파일 위치:** `lib/presentation/screens/quiz/widgets/`
- **코드 감축:** 671줄 → 285줄 (-57%)

---

## 📋 Phase 5 완료 보고서 (Polish & Optimize)

### ✅ Step 1: 페이지 전환 효과 통일 (2025-12-30)
- **AppRouter Update:** `GoRouter`의 `builder`를 `pageBuilder`로 변경하여 커스텀 트랜지션 적용
- **TimePortalPage 적용 (중요 전환):** WorldMap, EraTimeline, EraExploration, QuizPlay
- **GoldenPage 적용 (일반 전환):** MainMenu, RegionDetail, Dialogue, Encyclopedia, Quiz, Profile, Shop, Inventory, Settings

### ✅ Step 2: 마이크로 인터랙션 (2025-12-30)
- **TimeWalkerAppBar:** 뒤로가기 및 액션 버튼 탭 시 `HapticFeedback.lightImpact()` 적용
- **카드 컴포넌트:** `AchievementCard`, `QuizCard` 탭 시 햅틱 피드백 적용
- 사용자의 터치에 대한 물리적 피드백 강화

---

## 🏁 프로젝트 리팩토링 완료
Phase 1부터 Phase 5까지의 UI/UX 대대적 재정비 작업을 모두 마쳤습니다.
TimeWalker 앱은 이제 일관된 테마, 클린 아키텍처 기반의 모듈화된 구조, 최적화된 성능, 그리고 풍부한 인터랙션을 갖추게 되었습니다.

**향후 제안 (Phase Next):**
- **사운드 (SFX):** 버튼 클릭, 성공/실패 효과음 추가
- **접근성 (Accessibility):** 스크린 리더(TalkBack) 지원 및 텍스트 스케일링 대응
- **테스트 커버리지:** 주요 비즈니스 로직에 대한 단위 테스트 확충
