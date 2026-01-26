---
name: Dialogue System
description: TimeWalker 앱의 대화 시스템 개발 가이드. 대화 데이터 구조, 분기 로직, 보상 시스템, UI 구현 방법을 제공합니다.
---

# Dialogue System Skill

TimeWalker 앱의 역사 인물과의 인터랙티브 대화 시스템 구현 가이드입니다.

## 핵심 컨셉

- **분기형 대화**: 플레이어 선택에 따라 다른 대화 경로로 진행
- **보상 시스템**: 대화 선택에 따른 지식 포인트, 도감 해금
- **감정 표현**: 캐릭터의 감정 상태에 따른 표정 변화
- **조건부 선택지**: 특정 조건 충족 시에만 선택 가능한 선택지

---

## 1. 데이터 구조

### Import 방법

```dart
import 'package:time_walker/domain/entities/dialogue/dialogue_entities.dart';
```

### 핵심 엔티티

| 클래스 | 설명 | 파일 |
|--------|------|------|
| `Dialogue` | 대화 전체 컨테이너 | `dialogue_entity.dart` |
| `DialogueNode` | 대화의 각 단계 | `dialogue_node.dart` |
| `DialogueChoice` | 플레이어 선택지 | `dialogue_choice.dart` |
| `DialogueReward` | 선택 보상 | `dialogue_reward.dart` |
| `ChoiceCondition` | 선택지 조건 | `dialogue_reward.dart` |

---

## 2. Dialogue 엔티티

```dart
class Dialogue {
  final String id;             // "sejong_hangul_01"
  final String characterId;    // "sejong"
  final String title;          // "Creation of Hangul"
  final String titleKorean;    // "훈민정음 창제"
  final String description;    // 대화 설명
  final List<DialogueNode> nodes;
  final List<DialogueReward> rewards;  // 완료 보상
  final bool isCompleted;
  final int estimatedMinutes;  // 예상 소요 시간
}
```

### 주요 메서드

```dart
// 시작 노드 가져오기 (id='start' 또는 첫 번째 노드)
DialogueNode? get startNode;

// 노드 ID로 검색
DialogueNode? getNodeById(String nodeId);

// 총 보상 포인트
int get totalRewardPoints;
```

---

## 3. DialogueNode 구조

```dart
class DialogueNode {
  final String id;                    // "start", "end_node"
  final String speakerId;             // 화자 ID
  final String emotion;               // 감정 상태
  final String text;                  // 대사 내용
  final List<DialogueChoice> choices; // 선택지 (없으면 자동 진행)
  final String? nextNodeId;           // 다음 노드 (선택지 없을 때)
  final DialogueReward? reward;       // 노드 보상
  final bool isEnd;                   // 종료 노드 여부
}
```

### 감정 상태 목록

| Emotion | 설명 | 사용 시점 |
|---------|------|----------|
| `neutral` | 기본 표정 | 일반 대화 |
| `happy` | 기쁜 표정 | 긍정적 반응 |
| `sad` | 슬픈 표정 | 안타까운 이야기 |
| `angry` | 화난 표정 | 분노 표현 |
| `thoughtful` | 생각하는 표정 | 고민/회상 |
| `determined` | 결연한 표정 | 결심 표현 |
| `serious` | 진지한 표정 | 중요한 주제 |

### 노드 진행 로직

```dart
// 선택지가 있는지 확인
bool get hasChoices => choices.isNotEmpty;

// 자동 진행 여부 (선택지 없고 다음 노드 있고 종료 아닐 때)
bool get isAutoProgress => !hasChoices && nextNodeId != null && !isEnd;
```

---

## 4. DialogueChoice 구조

```dart
class DialogueChoice {
  final String id;           // "c1_praise"
  final String text;         // 선택지 텍스트
  final String? preview;     // 결과 미리보기
  final String nextNodeId;   // 연결 노드
  final DialogueReward? reward;
  final ChoiceCondition? condition;
}
```

### 조건부 선택지

```dart
class ChoiceCondition {
  final String? requiredFact;       // 필요한 역사 사실
  final String? requiredCharacter;  // 필요한 인물 해금
  final int? requiredKnowledge;     // 필요한 지식 포인트
}
```

---

## 5. DialogueReward 구조

```dart
class DialogueReward {
  final int knowledgePoints;       // 역사 이해도 포인트
  final String? unlockFactId;      // 해금되는 역사 사실
  final String? unlockCharacterId; // 해금되는 인물
  final String? achievementId;     // 획득 업적
}
```

---

## 6. JSON 데이터 포맷

### 파일 위치

`assets/data/dialogues.json`

### 기본 구조

```json
[
  {
    "id": "sejong_hangul_01",
    "characterId": "sejong",
    "title": "Creation of Hangul",
    "titleKorean": "훈민정음 창제",
    "description": "세종대왕이 훈민정음을 창제하게 된 계기...",
    "estimatedMinutes": 5,
    "rewards": [
      { "knowledgePoints": 100, "unlockFactId": "fact_hangul_origin" }
    ],
    "nodes": [...]
  }
]
```

### 노드 예시

```json
{
  "id": "start",
  "speakerId": "sejong",
  "emotion": "thoughtful",
  "text": "백성이 글을 몰라 억울한 일을 당해도...",
  "choices": [
    {
      "id": "c1_praise",
      "text": "정말 위대한 생각이십니다, 전하!",
      "preview": "세종의 결정 지지하기",
      "nextNodeId": "praise_response",
      "reward": { "knowledgePoints": 10 }
    },
    {
      "id": "c1_ask_reason",
      "text": "새 글자가 왜 필요한지 여쭤봐도 될까요?",
      "nextNodeId": "explanation_branch",
      "reward": { "knowledgePoints": 15 }
    }
  ]
}
```

### 종료 노드 예시

```json
{
  "id": "end_node",
  "speakerId": "sejong",
  "emotion": "neutral",
  "text": "내 뜻은 확고하니, 백성을 위해 끝까지 완성할 것이네.",
  "isEnd": true,
  "reward": {
    "knowledgePoints": 50,
    "unlockFactId": "fact_hangul_creation"
  }
}
```

### 조건부 선택지 예시

```json
{
  "id": "c1_special",
  "text": "허리에 찬 그 검은 특이하게 생겼네요.",
  "nextNodeId": "chiljido_story",
  "reward": { "knowledgePoints": 30 },
  "condition": { "requiredKnowledge": 50 }
}
```

---

## 7. 대화 ID 네이밍 컨벤션

### 대화 ID

```
{character_id}_{topic}_{number}
```

예: `sejong_hangul_01`, `gwanggaeto_conquest_01`

### 노드 ID

| 패턴 | 용도 | 예시 |
|------|------|------|
| `start` | 시작 노드 | `start` |
| `end_*` | 종료 노드 | `end_happy`, `end_neutral` |
| `*_branch` | 분기 노드 | `opposition_branch` |
| `*_node` | 일반 진행 노드 | `resolve_node` |

### 선택지 ID

```
c{node_order}_{action}
```

예: `c1_praise`, `c2_ask_reason`

---

## 8. 관련 파일

| 경로 | 설명 |
|------|------|
| `lib/domain/entities/dialogue/` | 대화 엔티티 정의 |
| `lib/domain/repositories/dialogue_repository.dart` | Repository 인터페이스 |
| `lib/data/repositories/mock_dialogue_repository.dart` | Mock 구현 |
| `lib/presentation/screens/dialogue/` | 대화 화면 |
| `lib/presentation/widgets/dialogue/` | 대화 위젯 |
| `assets/data/dialogues.json` | 대화 데이터 |

---

## 9. 새 대화 콘텐츠 추가 체크리스트

새로운 대화를 추가할 때 확인할 사항:

- [ ] 대화 ID가 `{character_id}_{topic}_{number}` 형식인가?
- [ ] 시작 노드의 ID가 `start`인가?
- [ ] 모든 `nextNodeId`가 실제 존재하는 노드를 가리키는가?
- [ ] 종료 노드에 `isEnd: true`가 설정되어 있는가?
- [ ] 선택지가 없는 노드에 `nextNodeId`가 있거나 `isEnd`가 true인가?
- [ ] 감정 상태가 유효한 값인가?
- [ ] 보상 포인트가 적절한가? (선택지: 10-30, 종료: 30-50)
- [ ] `unlockFactId`, `unlockCharacterId`가 실제 존재하는 ID인가?

---

## 10. 베스트 프랙티스

### ✅ DO

```json
// 1. 명확한 선택지 미리보기 제공
{
  "text": "신하들의 반대는 없었나요?",
  "preview": "반대 세력에 대해 묻기"
}

// 2. 분기에 따른 차별화된 보상
{
  "choices": [
    { "reward": { "knowledgePoints": 15 } },
    { "reward": { "knowledgePoints": 25, "unlockFactId": "..." } }
  ]
}

// 3. 자연스러운 대화 흐름
{
  "text": "호오, 그대의 기개가 마음에 드는구나!\n고구려는 천손의 후예..."
}
```

### ❌ DON'T

```json
// 1. 끊어진 분기 (존재하지 않는 노드 참조)
{ "nextNodeId": "nonexistent_node" }  // ❌

// 2. 출구 없는 노드 (종료도 아니고 다음 노드도 없음)
{ "id": "dead_end", "text": "...", "isEnd": false }  // ❌

// 3. 너무 긴 대사 (가독성 저하)
{ "text": "매우 긴 텍스트가 여러 문단에 걸쳐..." }  // ❌
```
