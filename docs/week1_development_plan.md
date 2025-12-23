# Week 1: 대화 시스템 완성 - 상세 개발 계획

**기간**: 5일 (월~금)  
**목표**: 플레이어가 인물과 대화하고 보상을 받을 수 있는 완전한 시스템 구축

---

## 📋 목차

1. [현재 상태 분석](#1-현재-상태-분석)
2. [작업 항목 및 일정](#2-작업-항목-및-일정)
3. [기술적 구현 상세](#3-기술적-구현-상세)
4. [테스트 계획](#4-테스트-계획)
5. [완료 기준](#5-완료-기준)

---

## 1. 현재 상태 분석

### 1.1 완료된 항목 ✅

| 항목 | 상태 | 비고 |
|------|------|------|
| Dialogue 엔티티 | ✅ 완료 | DialogueNode, DialogueChoice 구조 완성 |
| JSON 파서 | ✅ 완료 | `Dialogue.fromJson()` 구현됨 |
| 대화 UI | ✅ 완료 | DialogueScreen, DialogueViewModel 기본 구조 |
| 타이핑 애니메이션 | ✅ 완료 | 텍스트 타이핑 효과 구현 |
| 선택지 UI | ✅ 완료 | 선택지 버튼 표시 |
| 기본 보상 처리 | ✅ 부분 | 노드 보상만 처리, 선택지 보상 누락 |

### 1.2 미완성 항목 ❌

| 항목 | 우선순위 | 예상 시간 |
|------|----------|----------|
| YAML 파서 | 🔴 높음 | 4시간 |
| 선택지 보상 처리 | 🔴 높음 | 3시간 |
| 조건부 선택지 검증 | 🔴 높음 | 4시간 |
| 진행률 계산 로직 개선 | 🔴 높음 | 6시간 |
| 탐험가 등급 시스템 완성 | 🟡 중간 | 3시간 |
| 보상 애니메이션 | 🟡 중간 | 4시간 |

---

## 2. 작업 항목 및 일정

### Day 1 (월요일): YAML 파서 구현

**목표**: YAML 형식의 대화 스크립트를 파싱할 수 있도록 구현

#### 작업 1.1: YAML 파서 클래스 생성
- **파일**: `lib/data/datasources/local/dialogue_yaml_parser.dart`
- **기능**:
  - YAML 파일을 읽어서 Dialogue 객체로 변환
  - PRD 부록 B의 YAML 형식 지원
  - 에러 처리 및 검증

**예상 시간**: 4시간

**구현 예시**:
```dart
class DialogueYamlParser {
  /// YAML 문자열을 Dialogue 객체로 변환
  Dialogue parseYaml(String yamlContent);
  
  /// YAML 파일 경로에서 Dialogue 로드
  Future<Dialogue> loadFromAsset(String assetPath);
  
  /// YAML 노드를 DialogueNode로 변환
  DialogueNode _parseNode(Map<String, dynamic> nodeData);
  
  /// YAML 선택지를 DialogueChoice로 변환
  DialogueChoice _parseChoice(Map<String, dynamic> choiceData);
}
```

#### 작업 1.2: Repository 통합
- **파일**: `lib/data/repositories/mock_dialogue_repository.dart`
- **기능**:
  - JSON과 YAML 모두 지원하도록 수정
  - 파일 확장자에 따라 자동 선택
  - 우선순위: YAML > JSON

**예상 시간**: 2시간

**산출물**:
- ✅ YAML 파서 클래스
- ✅ Repository 통합
- ✅ 단위 테스트

---

### Day 2 (화요일): 선택지 보상 시스템

**목표**: 선택지를 선택했을 때 보상을 즉시 지급하도록 구현

#### 작업 2.1: 선택지 보상 처리 로직
- **파일**: `lib/presentation/screens/dialogue/dialogue_view_model.dart`
- **기능**:
  - `selectChoice()` 메서드에서 보상 처리
  - 선택지별 보상 즉시 지급
  - 중복 보상 방지

**예상 시간**: 3시간

**구현 예시**:
```dart
void selectChoice(DialogueChoice choice) async {
  if (state.isTyping) return;
  
  // 1. 조건 검증
  if (!_canSelectChoice(choice)) {
    _showConditionNotMetDialog(choice);
    return;
  }
  
  // 2. 보상 처리 (선택지 보상)
  if (choice.reward != null) {
    await _applyReward(choice.reward!);
  }
  
  // 3. 노드 이동
  _moveToNode(choice.nextNodeId);
}

Future<void> _applyReward(DialogueReward reward) async {
  // UserProgress 업데이트
  await ref.read(userProgressProvider.notifier).updateProgress((progress) {
    var updated = progress.copyWith(
      totalKnowledge: progress.totalKnowledge + reward.knowledgePoints,
    );
    
    // 해금 처리
    if (reward.unlockFactId != null) {
      updated = updated.copyWith(
        unlockedFactIds: [...updated.unlockedFactIds, reward.unlockFactId!],
      );
    }
    
    if (reward.unlockCharacterId != null) {
      updated = updated.copyWith(
        unlockedCharacterIds: [...updated.unlockedCharacterIds, reward.unlockCharacterId!],
      );
    }
    
    return updated;
  });
}
```

#### 작업 2.2: 보상 피드백 UI
- **파일**: `lib/presentation/widgets/dialogue/reward_notification.dart`
- **기능**:
  - 보상 획득 시 토스트/스낵바 표시
  - 포인트 획득 애니메이션
  - 해금 항목 표시

**예상 시간**: 2시간

**산출물**:
- ✅ 선택지 보상 처리 완료
- ✅ 보상 피드백 UI
- ✅ 통합 테스트

---

### Day 3 (수요일): 조건부 선택지 검증

**목표**: 특정 조건을 만족해야만 선택할 수 있는 선택지 구현

#### 작업 3.1: 조건 검증 로직
- **파일**: `lib/presentation/screens/dialogue/dialogue_view_model.dart`
- **기능**:
  - `ChoiceCondition` 검증
  - 필요한 지식 포인트 확인
  - 필요한 역사 사실 확인
  - 필요한 인물 해금 확인

**예상 시간**: 4시간

**구현 예시**:
```dart
bool _canSelectChoice(DialogueChoice choice) {
  if (choice.condition == null) return true;
  
  final condition = choice.condition!;
  final progress = ref.read(userProgressProvider).value;
  if (progress == null) return false;
  
  // 지식 포인트 확인
  if (condition.requiredKnowledge != null) {
    if (progress.totalKnowledge < condition.requiredKnowledge!) {
      return false;
    }
  }
  
  // 역사 사실 확인
  if (condition.requiredFact != null) {
    if (!progress.unlockedFactIds.contains(condition.requiredFact)) {
      return false;
    }
  }
  
  // 인물 해금 확인
  if (condition.requiredCharacter != null) {
    if (!progress.unlockedCharacterIds.contains(condition.requiredCharacter)) {
      return false;
    }
  }
  
  return true;
}

void _showConditionNotMetDialog(DialogueChoice choice) {
  // 조건 미충족 시 안내 다이얼로그
  // 예: "이 선택지를 하려면 더 많은 지식을 쌓아야 합니다"
}
```

#### 작업 3.2: 조건부 선택지 UI
- **파일**: `lib/presentation/screens/dialogue/dialogue_screen.dart`
- **기능**:
  - 조건 미충족 선택지 비활성화
  - 조건 안내 툴팁
  - 시각적 피드백 (회색 처리)

**예상 시간**: 2시간

**산출물**:
- ✅ 조건 검증 로직
- ✅ 조건부 선택지 UI
- ✅ 사용자 안내 메시지

---

### Day 4 (목요일): 진행률 계산 로직 개선

**목표**: 대화 완료 시 정확한 진행률 계산 및 업데이트

#### 작업 4.1: 진행률 계산 서비스
- **파일**: `lib/domain/services/progression_service.dart`
- **기능**:
  - 시대별 진행률 계산 로직 개선
  - 대화 완료 수 기반 계산
  - 인물 완료 수 기반 계산
  - 장소 탐험 수 기반 계산

**예상 시간**: 4시간

**구현 예시**:
```dart
class ProgressionService {
  /// 시대 진행률 계산
  double calculateEraProgress(
    String eraId,
    UserProgress progress,
    List<Dialogue> eraDialogues,
  ) {
    // 완료한 대화 수
    final completedCount = eraDialogues
        .where((d) => progress.isDialogueCompleted(d.id))
        .length;
    
    // 총 대화 수
    final totalCount = eraDialogues.length;
    
    if (totalCount == 0) return 0.0;
    
    // 기본 진행률 (대화 완료율)
    final dialogueProgress = completedCount / totalCount;
    
    // 가중치 적용 (향후 확장 가능)
    // - 대화 완료: 60%
    // - 인물 완료: 30%
    // - 장소 탐험: 10%
    
    return dialogueProgress.clamp(0.0, 1.0);
  }
  
  /// 지역 진행률 계산
  double calculateRegionProgress(
    String regionId,
    UserProgress progress,
    List<Era> regionEras,
  ) {
    if (regionEras.isEmpty) return 0.0;
    
    final eraProgresses = regionEras.map((era) {
      return progress.getEraProgress(era.id);
    }).toList();
    
    final average = eraProgresses.fold(0.0, (sum, p) => sum + p) / eraProgresses.length;
    return average.clamp(0.0, 1.0);
  }
}
```

#### 작업 4.2: DialogueViewModel 통합
- **파일**: `lib/presentation/screens/dialogue/dialogue_view_model.dart`
- **기능**:
  - `_finishDialogue()`에서 진행률 재계산
  - 시대/지역 진행률 자동 업데이트
  - 해금 조건 확인

**예상 시간**: 2시간

**구현 예시**:
```dart
Future<void> _finishDialogue() async {
  final dialogue = state.dialogue;
  if (dialogue == null) return;
  
  // 1. 대화 완료 처리
  final character = await ref.read(characterRepositoryProvider).getCharacterById(dialogue.characterId);
  final eraId = character?.eraId;
  
  // 2. 진행률 업데이트
  final unlocks = await ref.read(userProgressProvider.notifier).updateProgress((progress) {
    // 대화 완료 체크
    if (progress.isDialogueCompleted(dialogue.id)) {
      return progress; // 중복 방지
    }
    
    // 보상 적용
    var updated = progress.copyWith(
      completedDialogueIds: [...progress.completedDialogueIds, dialogue.id],
      totalKnowledge: progress.totalKnowledge + dialogue.totalRewardPoints,
    );
    
    // 시대 진행률 재계산
    if (eraId != null) {
      final eraDialogues = await ref.read(dialogueRepositoryProvider).getDialoguesByEra(eraId);
      final eraProgress = _progressionService.calculateEraProgress(
        eraId,
        updated,
        eraDialogues,
      );
      
      updated = updated.copyWith(
        eraProgress: {
          ...updated.eraProgress,
          eraId: eraProgress,
        },
      );
    }
    
    return updated;
  });
  
  // 3. 상태 업데이트
  state = state.copyWith(
    isCompleted: true,
    unlockEvents: unlocks,
  );
}
```

**산출물**:
- ✅ 진행률 계산 서비스
- ✅ DialogueViewModel 통합
- ✅ 자동 해금 시스템

---

### Day 5 (금요일): 탐험가 등급 시스템 & 통합 테스트

**목표**: 등급 시스템 완성 및 전체 시스템 통합 테스트

#### 작업 5.1: 탐험가 등급 시스템 완성
- **파일**: `lib/domain/services/progression_service.dart`
- **기능**:
  - 등급별 해금 항목 정의
  - 등급 승급 시 해금 이벤트
  - 등급별 특전 (향후 확장)

**예상 시간**: 3시간

**구현 예시**:
```dart
class ProgressionService {
  /// 등급별 해금 항목
  static const Map<ExplorerRank, List<String>> rankUnlocks = {
    ExplorerRank.apprentice: ['region_europe', 'feature_hint'],
    ExplorerRank.intermediate: ['region_africa', 'feature_quiz'],
    ExplorerRank.advanced: ['region_america', 'feature_timeline'],
    ExplorerRank.expert: ['region_middle_east', 'feature_whatif'],
    ExplorerRank.master: ['era_hidden', 'title_master'],
  };
  
  /// 등급 승급 확인
  List<UnlockEvent> checkRankPromotion(
    UserProgress currentProgress,
    UserProgress updatedProgress,
  ) {
    final events = <UnlockEvent>[];
    
    final currentRank = currentProgress.rank;
    final newRank = _calculateRank(updatedProgress.totalKnowledge);
    
    if (newRank.index > currentRank.index) {
      // 등급 상승
      events.add(UnlockEvent(
        type: UnlockType.rank,
        id: newRank.name,
        name: newRank.displayName,
        message: '축하합니다! ${newRank.displayName} 등급으로 승급했습니다!',
      ));
      
      // 등급별 해금 항목 확인
      final unlocks = rankUnlocks[newRank] ?? [];
      for (final unlockId in unlocks) {
        // 해금 로직 (지역, 기능 등)
      }
    }
    
    return events;
  }
}
```

#### 작업 5.2: 통합 테스트
- **파일**: `test/dialogue/dialogue_system_test.dart`
- **테스트 항목**:
  - YAML 파싱 테스트
  - 선택지 보상 처리 테스트
  - 조건부 선택지 검증 테스트
  - 진행률 계산 테스트
  - 등급 승급 테스트

**예상 시간**: 3시간

**테스트 시나리오**:
```dart
void main() {
  group('Dialogue System Integration Tests', () {
    test('YAML 파싱 테스트', () async {
      // YAML 파일 로드 및 파싱
      // Dialogue 객체 생성 확인
    });
    
    test('선택지 보상 처리', () async {
      // 선택지 선택 시 보상 지급 확인
      // 중복 보상 방지 확인
    });
    
    test('조건부 선택지', () async {
      // 조건 충족 시 선택 가능
      // 조건 미충족 시 선택 불가
    });
    
    test('진행률 계산', () async {
      // 대화 완료 시 진행률 업데이트
      // 시대/지역 진행률 정확성
    });
    
    test('등급 승급', () async {
      // 지식 포인트 증가 시 등급 상승
      // 해금 이벤트 발생
    });
  });
}
```

#### 작업 5.3: 문서화
- **파일**: `docs/dialogue_system_guide.md`
- **내용**:
  - 대화 스크립트 작성 가이드
  - YAML 형식 설명
  - 보상 시스템 설명
  - 조건부 선택지 작성법

**예상 시간**: 1시간

**산출물**:
- ✅ 탐험가 등급 시스템
- ✅ 통합 테스트 완료
- ✅ 문서화

---

## 3. 기술적 구현 상세

### 3.1 YAML 파서 구조

**YAML 형식 예시** (PRD 부록 B 기반):
```yaml
dialogue:
  id: sejong_hangul_01
  character: sejong
  title: "백성을 위한 글자"
  
  nodes:
    - id: start
      speaker: sejong
      emotion: thoughtful
      text: "백성이 글을 몰라..."
      choices:
        - text: "정말 위대한 생각이십니다!"
          next: praise_response
          reward:
            knowledge: 10
        - text: "새 글자가 왜 필요한지..."
          next: explanation_branch
          reward:
            knowledge: 15
            unlock_fact: "훈민정음_창제동기"
```

**파서 구현**:
```dart
import 'package:yaml/yaml.dart';

class DialogueYamlParser {
  Dialogue parseYaml(String yamlContent) {
    final doc = loadYaml(yamlContent);
    final dialogueData = doc['dialogue'] as Map;
    
    return Dialogue(
      id: dialogueData['id'] as String,
      characterId: dialogueData['character'] as String,
      title: dialogueData['title'] as String,
      titleKorean: dialogueData['title'] as String, // 임시
      description: dialogueData['description'] as String? ?? '',
      nodes: _parseNodes(dialogueData['nodes'] as List),
      rewards: _parseRewards(dialogueData['rewards'] as List?),
    );
  }
  
  List<DialogueNode> _parseNodes(List nodes) {
    return nodes.map((node) {
      return DialogueNode(
        id: node['id'] as String,
        speakerId: node['speaker'] as String,
        emotion: node['emotion'] as String? ?? 'neutral',
        text: node['text'] as String,
        choices: _parseChoices(node['choices'] as List?),
        nextNodeId: node['next'] as String?,
        reward: node['reward'] != null 
            ? _parseReward(node['reward'] as Map) 
            : null,
        isEnd: node['end'] as bool? ?? false,
      );
    }).toList();
  }
  
  List<DialogueChoice> _parseChoices(List? choices) {
    if (choices == null) return [];
    
    return choices.asMap().entries.map((entry) {
      final choice = entry.value as Map;
      return DialogueChoice(
        id: choice['id'] as String? ?? 'c${entry.key}',
        text: choice['text'] as String,
        preview: choice['preview'] as String?,
        nextNodeId: choice['next'] as String,
        reward: choice['reward'] != null
            ? _parseReward(choice['reward'] as Map)
            : null,
        condition: choice['condition'] != null
            ? _parseCondition(choice['condition'] as Map)
            : null,
      );
    }).toList();
  }
  
  DialogueReward _parseReward(Map reward) {
    return DialogueReward(
      knowledgePoints: reward['knowledge'] as int? ?? 0,
      unlockFactId: reward['unlock_fact'] as String?,
      unlockCharacterId: reward['unlock_character'] as String?,
      achievementId: reward['achievement'] as String?,
    );
  }
  
  ChoiceCondition _parseCondition(Map condition) {
    return ChoiceCondition(
      requiredFact: condition['required_fact'] as String?,
      requiredCharacter: condition['required_character'] as String?,
      requiredKnowledge: condition['required_knowledge'] as int?,
    );
  }
}
```

### 3.2 보상 처리 플로우

```
[선택지 선택]
    │
    ▼
[조건 검증] ──❌──> [조건 미충족 안내]
    │ ✅
    ▼
[선택지 보상 지급]
    │
    ├──> [지식 포인트 추가]
    ├──> [역사 사실 해금]
    ├──> [인물 해금]
    └──> [업적 획득]
    │
    ▼
[다음 노드로 이동]
    │
    ▼
[노드 보상 지급] (있는 경우)
    │
    ▼
[진행률 업데이트]
    │
    ├──> [시대 진행률 재계산]
    ├──> [지역 진행률 재계산]
    └──> [등급 승급 확인]
```

### 3.3 진행률 계산 공식

**시대 진행률**:
```
진행률 = (완료한 대화 수 / 총 대화 수) × 100%
```

**향후 확장 가능한 가중치**:
```
진행률 = (
  (대화 완료율 × 0.6) +
  (인물 완료율 × 0.3) +
  (장소 탐험율 × 0.1)
) × 100%
```

**지역 진행률**:
```
지역 진행률 = (시대별 진행률의 평균)
```

---

## 4. 테스트 계획

### 4.1 단위 테스트

| 테스트 항목 | 파일 | 커버리지 목표 |
|------------|------|--------------|
| YAML 파서 | `test/data/dialogue_yaml_parser_test.dart` | 90% |
| 보상 처리 | `test/presentation/dialogue_reward_test.dart` | 85% |
| 조건 검증 | `test/presentation/choice_condition_test.dart` | 90% |
| 진행률 계산 | `test/domain/progression_calculation_test.dart` | 85% |

### 4.2 통합 테스트

| 테스트 시나리오 | 설명 |
|----------------|------|
| 완전한 대화 플레이 | 시작부터 종료까지 전체 플레이 |
| 선택지 분기 | 모든 선택지 경로 테스트 |
| 보상 누적 | 여러 대화 완료 시 보상 누적 확인 |
| 등급 승급 | 지식 포인트 증가 시 등급 상승 확인 |
| 해금 시스템 | 조건 충족 시 해금 확인 |

### 4.3 수동 테스트 체크리스트

- [ ] YAML 파일 로드 및 파싱
- [ ] JSON 파일 로드 및 파싱
- [ ] 선택지 선택 시 보상 지급
- [ ] 조건 미충족 선택지 비활성화
- [ ] 대화 완료 시 진행률 업데이트
- [ ] 등급 승급 시 해금 이벤트
- [ ] 보상 피드백 UI 표시
- [ ] 중복 보상 방지

---

## 5. 완료 기준

### 5.1 기능 완성도

| 항목 | 완료 기준 |
|------|----------|
| YAML 파서 | ✅ YAML 파일 로드 및 Dialogue 객체 생성 |
| 선택지 보상 | ✅ 선택지 선택 시 즉시 보상 지급 |
| 조건 검증 | ✅ 조건 미충족 시 선택 불가 |
| 진행률 계산 | ✅ 대화 완료 시 정확한 진행률 업데이트 |
| 등급 시스템 | ✅ 지식 포인트 증가 시 등급 상승 |

### 5.2 품질 기준

| 지표 | 목표 |
|------|------|
| 코드 커버리지 | >80% |
| 단위 테스트 통과율 | 100% |
| 통합 테스트 통과율 | 100% |
| 버그 수 | 0개 (Critical) |

### 5.3 문서화

- [ ] YAML 파서 사용법 문서
- [ ] 대화 스크립트 작성 가이드
- [ ] 보상 시스템 설명
- [ ] 진행률 계산 로직 문서

---

## 6. 일일 체크포인트

### Day 1 체크포인트
- [ ] YAML 파서 클래스 생성
- [ ] Repository 통합 완료
- [ ] 단위 테스트 작성

### Day 2 체크포인트
- [ ] 선택지 보상 처리 로직 구현
- [ ] 보상 피드백 UI 완성
- [ ] 통합 테스트 통과

### Day 3 체크포인트
- [ ] 조건 검증 로직 구현
- [ ] 조건부 선택지 UI 완성
- [ ] 사용자 안내 메시지 추가

### Day 4 체크포인트
- [ ] 진행률 계산 서비스 구현
- [ ] DialogueViewModel 통합
- [ ] 자동 해금 시스템 동작 확인

### Day 5 체크포인트
- [ ] 탐험가 등급 시스템 완성
- [ ] 통합 테스트 완료
- [ ] 문서화 완료
- [ ] 전체 시스템 검증

---

## 7. 리스크 및 대응

| 리스크 | 확률 | 영향 | 대응 방안 |
|--------|------|------|----------|
| YAML 파서 복잡도 | 중간 | 중간 | 단순한 구조로 시작, 점진적 확장 |
| 보상 중복 지급 | 낮음 | 높음 | 완료 체크 로직 강화 |
| 진행률 계산 오류 | 낮음 | 중간 | 단위 테스트로 사전 검증 |
| 성능 이슈 | 낮음 | 낮음 | 비동기 처리, 최적화 |

---

## 8. 다음 주 연계

Week 1 완료 후 Week 2로 전달할 항목:
- ✅ 완성된 대화 시스템
- ✅ YAML/JSON 파서
- ✅ 보상 및 진행률 시스템
- ✅ 테스트 코드 및 문서

Week 2에서 사용:
- Flame 지도 통합 시 대화 시스템 연동
- 시대 탐험 화면에서 대화 시작
- 진행률 기반 해금 시스템

---

**문서 버전**: 1.0  
**작성일**: 2025년  
**다음 리뷰**: Day 3 종료 시점


