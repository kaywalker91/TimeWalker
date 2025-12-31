# TimeWalker 리팩토링 계획서

**작성일**: 2025년 12월 26일
**상태**: 초안 (Draft)

이 문서는 현재 TimeWalker 코드베이스의 품질 향상, 유지보수성 증대, 그리고 향후 기능 확장을 위한 리팩토링 계획을 기술합니다.

---

## 1. 리팩토링 목표

1.  **관심사 분리 (Separation of Concerns)**: UI 위젯에서 비즈니스 로직을 분리하여 MVVM 패턴(Riverpod 활용)을 확립합니다.
2.  **코드 재사용성 향상 (Reusability)**: 반복되는 UI 요소를 공통 위젯으로 추출하고, 하드코딩된 스타일을 테마 시스템으로 통합합니다.
3.  **데이터 레이어 구조화 (Data Layer Structuring)**: 엔티티 내에 하드코딩된 더미 데이터를 분리하고, 실제 데이터 소스(Local DB/Remote)로의 확장을 대비합니다.
4.  **유지보수성 강화 (Maintainability)**: 가독성을 높이고 디버깅을 용이하게 하기 위해 코드를 정리합니다.

---

## 2. 주요 개선 영역

### 2.1 UI 및 테마 (UI & Theming) 🎨

**현재 문제점**:
*   `ShopScreen` 등에서 색상 값(`Color(0xFF...)`)이 하드코딩되어 있습니다.
*   버튼, 카드 등의 스타일이 각 화면마다 개별적으로 정의되어 일관성이 부족할 수 있습니다.
*   `build` 메서드가 너무 길어 가독성이 떨어지는 경우가 있습니다 (예: `ShopScreen`의 `_buildGrid`).

**개선 방안**:
*   **Theme Extension 도입**: `AppTheme` 및 `AppColors`에 커스텀 컬러(예: 등급별 색상, 상점 배경색)를 정의하고 `Theme.of(context)`를 통해 접근합니다.
*   **위젯 추출**: `ShopItemCard`, `CommonSectionHeader` 등 재사용 가능한 컴포넌트로 분리합니다.
*   **상수화**: UI 관련 상수(Padding, Radius 등)를 `AppConstants` 또는 `AppDimensions`로 관리합니다.

### 2.2 아키텍처 및 상태 관리 (Architecture & State) 🏗️

**현재 문제점**:
*   `ShopScreen` 내부의 `_purchaseItem`과 같이 비즈니스 로직(코인 차감, 인벤토리 추가 등)이 UI 위젯 안에 포함되어 있습니다.
*   상태 변경에 따른 UI 갱신이 `setState`와 Riverpod이 혼재될 가능성이 있습니다.

**개선 방안**:
*   **Controller/Notifier 패턴 적용**: 각 화면(Screen)에 대응하는 `AsyncNotifier` 또는 `StateNotifier`를 생성하여 비즈니스 로직을 위임합니다.
    *   예: `ShopController` 클래스 생성 -> `purchaseItem()` 메서드 구현.
*   **UI는 상태 구독만**: UI 위젯은 상태(State)를 구독하여 화면을 그리고, 사용자 이벤트를 컨트롤러로 전달하는 역할만 수행합니다.

### 2.3 데이터 레이어 (Data Layer) 💾

**현재 문제점**:
*   `ShopData` 및 기타 더미 데이터가 `Entity` 파일(`shop_item.dart` 등) 내부에 정적으로 정의되어 있습니다. 이는 순수해야 할 Domain 계층을 오염시킵니다.
*   Repository의 Mock 구현이 단순히 `Future.delayed`와 정적 리스트 반환으로만 되어 있어, 데이터 조작 테스트가 제한적입니다.

**개선 방안**:
*   **Data Source 분리**: 더미 데이터를 `assets/data/*.json` 파일이나 `lib/data/datasources/memory/*.dart`와 같이 별도의 데이터 소스 영역으로 이동합니다.
*   **Repository 역할 명확화**: Repository는 Data Source를 호출하여 데이터를 가져오고 Domain Entity로 변환하는 역할에 집중합니다.
*   **Entity 순수성 보장**: Entity 클래스에는 데이터 필드와 순수 로직만 남기고, 데이터 인스턴스(목록)는 제거합니다.

---

## 3. 단계별 실행 계획 (Action Plan)

### Phase 1: 기반 다지기 (Foundation)
*   [x] **Theme System 확장**: `lib/core/themes/` 내에 프로젝트 전반에 쓰이는 컬러 및 텍스트 스타일을 완벽하게 정의합니다.
*   [x] **Folder Restructure Review**: Feature 기반 폴더 구조가 잘 지켜지고 있는지 확인하고 정돈합니다.

### Phase 2: 비즈니스 로직 분리 (Logic Extraction)
*   [x] **Shop 기능 리팩토링 (시범 케이스)**:
    *   `ShopController` 구현.
    *   `ShopScreen` 로직 제거 및 UI 컴포넌트 분리 (`ShopItemCard`).
*   [x] **타 화면 적용**: Quiz, Profile 등 주요 화면에 동일한 패턴 적용 (Theme 통합, Widget 추출).

### Phase 3: 데이터 구조 개선 (Data Refine)
*   [x] **Mock Data 이동**: `domain/entities` 내의 `static const` 데이터들을 `data/datasources`로 이동.
    *   `ShopData`, `EraData`, `CountryData`, `AchievementData`, `RegionData`를 `data/datasources/static/`으로 분리 완료.

*   [ ] **JSON Serialization**: 필요한 경우 `json_serializable`을 도입하여 JSON 데이터 파싱 구조 마련.

### Phase 4: 코드 품질 향상 (Polishing)
*   [ ] **Linter 적용**: `flutter_lints` 규칙 준수 확인 및 경고 제거.
*   [ ] **주석 및 문서화**: 복잡한 로직에 대한 주석 보강.

---

## 4. 우선순위 제안

가장 먼저 **ShopScreen 리팩토링**을 진행하는 것을 추천합니다. 이는 UI, 로직, 데이터가 혼재된 대표적인 케이스로, 이를 개선하면서 올바른 아키텍처 레퍼런스를 확립할 수 있습니다.
