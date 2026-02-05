# 퀴즈 시스템 강화 및 업적 시스템 구현 계획

## 개요
대화 후 관련 역사 지식 퀴즈 출제, 맞춘 퀴즈 목록 확인, 퀴즈 업적 시스템 구현 프로젝트

## 진행 상황

### ✅ Phase 1: 핵심 데이터 구조 확장 (완료)

#### 1.1 UserProgress 엔티티 수정
- [x] `completedQuizIds` 필드 추가
- [x] `isQuizCompleted()` 헬퍼 메서드 추가
- [x] `completedQuizCount` getter 추가
- [x] 생성자, copyWith, props 업데이트

#### 1.2 Quiz 엔티티 수정
- [x] `relatedDialogueId` 필드 추가
- [x] 생성자, copyWith, fromJson, props 업데이트

#### 1.3 QuizRepository 확장
- [x] `getQuizzesByDialogueId()` 메서드 추가
- [x] MockQuizRepository 구현

#### 1.4 Provider 추가
- [x] `quizListByDialogueProvider` 추가

---

### ✅ Phase 2: 퀴즈 기록 저장 (완료)

#### 2.1 QuizPlayScreen 수정
- [x] 정답 시 `completedQuizIds`에 퀴즈 ID 추가
- [x] 중복 저장 방지 (이미 맞춘 퀴즈는 포인트 비획득)
- [x] 결과 화면에 복습 모드 표시 ("다시 풀기")
- [x] `_wasAlreadyCompleted` 상태 변수 추가

---

### ✅ Phase 3: 퀴즈 화면 UI 재설계 (완료)

#### 3.1 QuizScreen 수정
- [x] "전체" / "맞춘 퀴즈" 필터 탭 추가 (`QuizFilterType` enum)
- [x] `_FilterToggleButton` 위젯 구현 (카운트 배지 포함)
- [x] _QuizCard에 완료 상태 표시 (체크 아이콘, 녹색 배지)
- [x] 버튼 텍스트 변경: "Start Challenge" → "다시 풀기" / "해설 보기"
- [x] AppBar에 완료 통계 표시 (N개 완료)

#### 3.2 QuizDetailSheet 생성
- [x] 맞춘 퀴즈 상세 보기 바텀시트 (`_QuizDetailSheet`)
- [x] 문제, 선택지(정답 강조), 해설 표시
- [x] "닫기" / "다시 풀기" 버튼

---

### ✅ Phase 4: 퀴즈 업적 데이터 추가 (완료)

#### 4.1 Achievement 엔티티 확장
- [x] quiz_novice (첫 퀴즈 정답) - Common
- [x] quiz_enthusiast (5개 정답) - Uncommon, 보너스 20
- [x] quiz_expert (10개 정답) - Rare, 보너스 50
- [x] quiz_master (30개 정답) - Epic, 보너스 100
- [x] asia_historian (아시아 퀴즈 10개) - Rare, 보너스 50
- [x] europe_historian (유럽 퀴즈 5개) - Uncommon, 보너스 30
- [x] `quizAchievements` getter 추가
- [x] `color` getter 추가 (AchievementRarityExtension)

---

### ✅ Phase 5: AchievementService 구현 (완료)

- [x] `AchievementService` 클래스 생성
- [x] `checkQuizAchievements()` - 퀴즈 관련 업적 조건 체크
- [x] `checkDialogueAchievements()` - 대화 관련 업적 조건 체크
- [x] `checkKnowledgeAchievements()` - 지식 포인트 업적 조건 체크
- [x] `checkAllAfterQuiz()` - 퀴즈 정답 후 종합 체크
- [x] `calculateBonusPoints()` - 보너스 포인트 계산
- [x] `AchievementNotifier` StateNotifier - 알림 관리
- [x] `achievementServiceProvider` Provider 등록
- [x] `achievementNotifierProvider` Provider 등록

#### 5.2 QuizPlayScreen 통합
- [x] 업적 서비스 연동 및 조건 체크
- [x] 업적 달성 시 achievementIds에 추가
- [x] 보너스 포인트 지급
- [x] `_AchievementUnlockCard` 위젯으로 업적 달성 표시


---

### ✅ Phase 6: 업적 확인 화면 (완료)

- [x] `AchievementScreen` 생성 (`lib/presentation/screens/achievement/achievement_screen.dart`)
- [x] 진행률 헤더 (`_AchievementHeader`) - 달성률 표시 및 프로그레스 바
- [x] 카테고리별 탭 뷰 (전체 + 5개 카테고리)
- [x] 업적 그리드 뷰 (`_AchievementGrid`) - 2열 그리드
- [x] 업적 카드 (`_AchievementCard`) - 해금/잠금 상태, 비밀 업적 처리
- [x] 업적 상세 바텀시트 (`_AchievementDetailSheet`)
- [x] 정보 배지 (`_InfoBadge`, `_InfoBadgeWithEmoji`)
- [x] 라우터 등록 및 `goToAchievements()` 헬퍼 메서드 추가

---

### ✅ Phase 7: 대화 후 퀴즈 연결 (완료)

- [x] 대화 완료 다이얼로그에 퀴즈 버튼 추가
- [x] 관련 퀴즈 안내 UI (파란색 박스, 퀴즈 아이콘)
- [x] 선택적 퀴즈 진입 (강제 아님) - "나중에" / "퀴즈 도전!" 버튼
- [x] quizzes.json에 추가 relatedDialogueId 매핑 (4개 퀴즈)

#### 연결된 퀴즈-대화 매핑:
| 퀴즈 ID | 대화 ID |
|---------|---------|
| `sejong_hangul_01` | `sejong_hangul_01` |
| `yi_sun_sin_01` | `yi_battle_01` |
| `gwanggaeto_01` | `gwanggaeto_conquest_01` |
| `gaya_iron_01` | `suro_iron_trade_01` |

---

## 수정된 파일 목록

### Domain Layer
- `lib/domain/entities/user_progress.dart` - completedQuizIds 필드 추가
- `lib/domain/entities/quiz.dart` - relatedDialogueId 필드 추가
- `lib/domain/entities/achievement.dart` - 퀴즈 업적 6개 추가, color getter, iconCodePoint 추가
- `lib/domain/repositories/quiz_repository.dart` - getQuizzesByDialogueId 메서드 추가
- `lib/domain/services/achievement_service.dart` - 업적 서비스 및 Provider 신규 생성

### Data Layer
- `lib/data/repositories/mock_quiz_repository.dart` - getQuizzesByDialogueId 구현
- `assets/data/quizzes.json` - 4개 퀴즈에 relatedDialogueId 추가

### Presentation Layer  
- `lib/presentation/screens/quiz/quiz_screen.dart` - 전체 재설계 (필터, 완료 표시, 상세 보기)
- `lib/presentation/screens/quiz/quiz_play_screen.dart` - 정답 기록 저장, 업적 체크, 업적 달성 표시
- `lib/presentation/screens/achievement/achievement_screen.dart` - **신규 생성** (업적 확인 화면)
- `lib/presentation/screens/dialogue/dialogue_screen.dart` - 대화 완료 후 퀴즈 버튼 추가
- `lib/presentation/providers/content_providers.dart` - quizListByDialogueProvider 추가
- `lib/core/routes/app_router.dart` - AchievementScreen 라우터 등록

---

## 🎉 프로젝트 완료

모든 Phase가 성공적으로 완료되었습니다!

### 구현된 주요 기능:
1. ✅ 퀴즈 정답 기록 및 복습 시스템
2. ✅ "맞춘 퀴즈" 필터 및 상세 보기
3. ✅ 퀴즈 업적 시스템 (6개 업적)
4. ✅ 업적 확인 화면 (카테고리별 그리드)
5. ✅ 대화-퀴즈 자연스러운 연결 흐름

### 사용자 흐름:
```
대화 완료 → 관련 퀴즈 있으면 버튼 표시 → 퀴즈 도전
     ↓
퀴즈 정답 → 포인트 획득 → 업적 조건 체크
     ↓
업적 달성 → 알림 표시 → 보너스 포인트
     ↓
업적 화면에서 전체 진행률 확인
```
