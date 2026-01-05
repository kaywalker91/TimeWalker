# TimeWalker 코드 리팩토링 계획서 (2025년 12월 31일)

**작성일**: 2025년 12월 31일  
**버전**: v1.0  
**상태**: 📋 계획 수립 완료

---

## 📌 현황 요약

### 프로젝트 규모
- **총 Dart 파일 수**: 약 98개 파일
- **총 코드 라인 수**: 약 26,224줄
- **정적 분석 결과**: 경미한 경고 8개 (deprecated API 1개, unnecessary_underscores 7개)

### 기존 리팩토링 진행 상황 (완료된 작업)
- ✅ Phase 1~5 UI/UX 리팩토링 완료
- ✅ Theme System 구축 완료 (AppColors, AppGradients, AppTextStyles 등)
- ✅ Clean Architecture 적용 완료
- ✅ Mock Data를 data/datasources/static 으로 분리 완료
- ✅ 공통 위젯 분리 (TimeWalkerAppBar, CommonLoadingState 등)

---

## 🎯 신규 리팩토링 목표

### 1. 코드 품질 개선-
- Deprecated API 경고 해결
- Linter 경고 완전 제거
- 코드 일관성 및 가독성 향상

### 2. 대형 파일 분리
- 500줄 이상 파일 모듈화
- 단일 책임 원칙(SRP) 강화

### 3. 테스트 커버리지 확장
- 핵심 비즈니스 로직 단위 테스트 추가
- 위젯 테스트 확장

### 4. 코드 중복 제거
- 반복되는 패턴 추상화
- 유틸리티 함수 통합

---

## 📋 정리가 필요한 파일 목록

### 🔴 P0: 즉시 수정 필요 (Deprecated API / Linter 오류) ✅ 완료 (2025-12-31)

| 파일 | 라인 수 | 문제점 | 상태 |
|------|---------|--------|------|
| `presentation/screens/era_timeline/era_timeline_screen.dart` | 약 208줄 | `onPopInvoked` → `onPopInvokedWithResult` 업데이트 | ✅ 완료 |
| `presentation/screens/location_exploration/location_exploration_screen.dart` | 445줄 | `unnecessary_underscores` 경고 | ✅ 완료 |
| `presentation/screens/era_exploration/widgets/kingdom_location_sheet.dart` | 361줄 | `unnecessary_underscores` 경고 (4개소) | ✅ 완료 |

---

### 🟠 P1: 대형 파일 분리 필요 (500줄 초과) - ✅ 완료 (2025-12-31)

| 파일 | 기존 | 현재 | 분리 결과 | 상태 |
|------|------|------|-----------|------|
| `time_animations.dart` | **750줄** | **14줄** | 6개 파일로 분리 (animations/) | ✅ 완료 |
| `quiz_play_screen.dart` | **488줄** | **376줄** | AchievementUnlockCard 분리 | ✅ 완료 |
| `shop_screen.dart` | **481줄** | **388줄** | PurchaseConfirmDialog 분리 | ✅ 완료 |
| `dialogue_screen.dart` | **549줄** | **277줄** | DialogueCompletionDialog, DialogueChoicesPanel 분리 | ✅ 완료 |
| `era_exploration_screen.dart` | **911줄** | 911줄 | 이미 9개 위젯 분리됨 (추가 분리 보류) | 🔄 평가 완료 |

---

### 🟡 P2: 중형 파일 리팩토링 (400~500줄) - ✅ 완료 (2025-12-31)

| 파일 | 기존 | 현재 | 분리 결과 | 상태 |
|------|------|------|-----------|------|
| `profile_screen.dart` | **469줄** | **203줄** | ProfileUserHeader, ProfileRankProgress, CircularStatWidget, ProfileStatTile 분리 | ✅ 완료 |
| `main_menu_screen.dart` | **439줄** | **220줄** | MenuItem, MenuButton 분리 | ✅ 완료 |
| `settings_screen.dart` | **411줄** | **256줄** | SettingsSwitchTile, SettingsSliderTile, SettingsActionTile 등 분리 | ✅ 완료 |
| `location_exploration_screen.dart` | **444줄** | 444줄 | (P0에서 Linter 수정 완료, 추가 분리 불필요) | 🔄 평가 완료 |
| `app_theme.dart` | **423줄** | 423줄 | 단일 테마 클래스, 현 상태 유지 | 🔄 평가 완료 |
| `app_router.dart` | **402줄** | 402줄 | 라우트 설정은 한 곳에 유지하는 것이 적절 | 🔄 평가 완료 |

---

### 🟢 P3: 테마/유틸리티 정리 (300~400줄) - ✅ Entity 분리 완료 (2025-12-31)

| 파일 | 기존 | 현재 | 분리 결과 | 상태 |
|------|------|------|-----------|------|
| `dialogue.dart` | **388줄** | **10줄** | DialogueReward, DialogueChoice, DialogueNode, Dialogue, DialogueProgress 분리 | ✅ 완료 |
| `quiz.dart` | **307줄** | **10줄** | QuizEnums, Quiz, QuizResult, QuizSession 분리 | ✅ 완료 |
| `app_decorations.dart` | **371줄** | 371줄 | 카테고리별 그룹화 완료, 현 상태 유지 | 🔄 평가 완료 |
| `time_button.dart` | **353줄** | 353줄 | 버튼 타입별 분리 가능, 선택사항 | ⏳ 선택사항 |
| `dialogue_view_model.dart` | **347줄** | 347줄 | UseCase 분리 고려 | ⏳ 선택사항 |
| `time_card.dart` | **341줄** | 341줄 | 단일 위젯, 현 상태 유지 | 🔄 평가 완료 |
| `audio_service.dart` | **310줄** | 310줄 | 서비스 클래스, 현 상태 유지 | 🔄 평가 완료 |
| `app_text_styles.dart` | **306줄** | 306줄 | 테마 정의, 현 상태 유지 | 🔄 평가 완료 |

---

## 📁 폴더 구조 정리 필요 항목

### 빈 디렉토리 정리
- `lib/content/` - 내용 확인 필요
- `lib/interactive/` - 내용 확인 필요
- `lib/core/errors/` - 에러 핸들링 정의 필요
- `lib/core/extensions/` - 확장 메서드 정리 필요
- `lib/data/models/` - 모델 클래스 정의 필요
- `lib/data/datasources/remote/` - 원격 데이터소스 스텁 필요

### 위젯 폴더 정리
- `lib/presentation/widgets/encyclopedia/` - 빈 폴더 정리 필요
- `lib/presentation/widgets/game/` - 빈 폴더 정리 필요
- `lib/presentation/widgets/map/` - 빈 폴더 정리 필요

### 스크린 폴더 정리
- `lib/presentation/screens/auth/` - 빈 폴더 (인증 미구현)
- `lib/presentation/screens/game/` - 빈 폴더
- `lib/presentation/screens/game_over/` - 빈 폴더
- `lib/presentation/screens/tutorial/` - 빈 폴더

---

## 📅 실행 계획

### Phase A: 긴급 수정 (1일)
1. **Deprecated API 수정**
   - [ ] `era_timeline_screen.dart`: `onPopInvoked` → `onPopInvokedWithResult`
   
2. **Linter 경고 해결**
   - [ ] `location_exploration_screen.dart`: `__` → `_`
   - [ ] `kingdom_location_sheet.dart`: `__` → `_` (다수)

---

### Phase B: 대형 파일 분리 (3~5일)

1. **time_animations.dart 분리** (750줄 → 4개 파일)
   ```
   lib/presentation/widgets/common/animations/
   ├── page_transitions.dart    # TimePortalPageRoute, GoldenPageRoute
   ├── fade_scale.dart          # FadeInWidget, ScaleInWidget, StaggeredListItem
   ├── glow_effects.dart        # PulseGlowWidget, GoldenShimmer
   ├── loaders.dart             # TimeLoader
   ├── particles.dart           # FloatingParticles, TimePortalRings
   └── animations.dart          # 배럴 파일
   ```

2. **era_exploration_screen.dart 추가 분리** (910줄)
   - 기존 widgets 폴더 활용
   - 메인 스크린 로직 간소화

3. **dialogue_screen.dart 분리** (548줄)
   - dialogue_widgets.dart 추가 생성
   - ChoicesPanel, SpeakerAvatar 등 분리

4. **quiz_play_screen.dart 분리** (487줄)
   - QuizPlayViewModel 생성
   - quiz_play_widgets.dart 생성

5. **shop_screen.dart 분리** (480줄)
   - ShopController 강화
   - ShopGrid, ShopHeader 위젯 분리

---

### Phase C: 중형 파일 정리 (2~3일)

1. **profile_screen.dart 분리** (468줄)
2. **main_menu_screen.dart 분리** (438줄)
3. **settings_screen.dart 위젯 분리** (410줄)
4. **app_router.dart 정리** (401줄)

---

### Phase D: Entity 정리 (1~2일)

1. **dialogue.dart 분리** (387줄)
   ```
   lib/domain/entities/dialogue/
   ├── dialogue.dart
   ├── dialogue_node.dart
   ├── dialogue_choice.dart
   ├── dialogue_reward.dart
   ├── dialogue_progress.dart
   └── dialogue_entities.dart   # 배럴 파일
   ```

2. **quiz.dart 분리** (306줄)
   ```
   lib/domain/entities/quiz/
   ├── quiz.dart
   ├── quiz_question.dart
   ├── quiz_result.dart
   └── quiz_entities.dart       # 배럴 파일
   ```

---

### Phase E: 폴더 정리 및 문서화 (1일)

1. **빈 폴더 정리**
   - 사용하지 않는 빈 폴더 제거 또는 TODO 파일 생성

2. **배럴 파일 정리**
   - 각 폴더에 index 배럴 파일 확인/생성

3. **README 업데이트**
   - 리팩토링 완료 내용 반영

---

## 📊 예상 효과

| 지표 | 현재 | 목표 |
|------|------|------|
| 최대 파일 라인 수 | 910줄 | 350줄 이하 |
| Linter 경고 | 8개 | 0개 |
| 테스트 커버리지 | 미확인 | 30% 이상 |
| 빈 폴더 | 10개+ | 0개 |

---

## 🔗 관련 문서

- [기존 리팩토링 계획서](/docs/refactoring_plan.md)
- [UI/UX 리팩토링 계획서](/docs/ui_ux_refactoring_plan.md)
- [개발 계획서](/docs/development_plan.md)

---

## ⚠️ 주의사항

1. **백워드 호환성**: 기존 라우팅 및 Provider 의존성 유지
2. **단계적 진행**: 한 번에 큰 변경 지양, 작은 PR 단위 진행
3. **테스트 병행**: 리팩토링 시 기존 기능 테스트 필수

---

*마지막 업데이트: 2025년 12월 31일*
