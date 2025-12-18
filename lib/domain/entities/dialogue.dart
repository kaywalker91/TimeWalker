import 'package:equatable/equatable.dart';

/// 대화 엔티티
class Dialogue extends Equatable {
  final String id;
  final String characterId;
  final String title;
  final String titleKorean;
  final String description;
  final List<DialogueNode> nodes;
  final List<DialogueReward> rewards;
  final bool isCompleted;
  final int estimatedMinutes;

  const Dialogue({
    required this.id,
    required this.characterId,
    required this.title,
    required this.titleKorean,
    required this.description,
    required this.nodes,
    this.rewards = const [],
    this.isCompleted = false,
    this.estimatedMinutes = 5,
  });

  Dialogue copyWith({
    String? id,
    String? characterId,
    String? title,
    String? titleKorean,
    String? description,
    List<DialogueNode>? nodes,
    List<DialogueReward>? rewards,
    bool? isCompleted,
    int? estimatedMinutes,
  }) {
    return Dialogue(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      title: title ?? this.title,
      titleKorean: titleKorean ?? this.titleKorean,
      description: description ?? this.description,
      nodes: nodes ?? this.nodes,
      rewards: rewards ?? this.rewards,
      isCompleted: isCompleted ?? this.isCompleted,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  /// 시작 노드 가져오기
  DialogueNode? get startNode {
    try {
      return nodes.firstWhere((n) => n.id == 'start');
    } catch (_) {
      return nodes.isNotEmpty ? nodes.first : null;
    }
  }

  /// 노드 ID로 노드 찾기
  DialogueNode? getNodeById(String nodeId) {
    try {
      return nodes.firstWhere((n) => n.id == nodeId);
    } catch (_) {
      return null;
    }
  }

  /// 총 보상 포인트
  int get totalRewardPoints {
    return rewards.fold(0, (sum, r) => sum + r.knowledgePoints);
  }

  @override
  List<Object?> get props => [
    id,
    characterId,
    title,
    titleKorean,
    description,
    nodes,
    rewards,
    isCompleted,
    estimatedMinutes,
  ];

  factory Dialogue.fromJson(Map<String, dynamic> json) {
    return Dialogue(
      id: json['id'] as String,
      characterId: json['characterId'] as String,
      title: json['title'] as String,
      titleKorean: json['titleKorean'] as String,
      description: json['description'] as String,
      nodes: (json['nodes'] as List).map((e) => DialogueNode.fromJson(e)).toList(),
      rewards: (json['rewards'] as List? ?? []).map((e) => DialogueReward.fromJson(e)).toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
    );
  }

  @override
  String toString() =>
      'Dialogue(id: $id, title: $titleKorean, completed: $isCompleted)';
}

/// 대화 노드 (대화의 각 단계)
class DialogueNode extends Equatable {
  final String id;
  final String speakerId; // 화자 ID
  final String emotion; // 표정 상태
  final String text; // 대사 내용
  final List<DialogueChoice> choices; // 선택지 (없으면 자동 진행)
  final String? nextNodeId; // 다음 노드 ID (선택지 없을 때)
  final DialogueReward? reward; // 노드 보상
  final bool isEnd; // 종료 노드 여부

  const DialogueNode({
    required this.id,
    required this.speakerId,
    required this.text,
    this.emotion = 'neutral',
    this.choices = const [],
    this.nextNodeId,
    this.reward,
    this.isEnd = false,
  });

  factory DialogueNode.fromJson(Map<String, dynamic> json) {
    return DialogueNode(
      id: json['id'] as String,
      speakerId: json['speakerId'] as String,
      text: json['text'] as String,
      emotion: json['emotion'] as String? ?? 'neutral',
      choices: (json['choices'] as List? ?? []).map((e) => DialogueChoice.fromJson(e)).toList(),
      nextNodeId: json['nextNodeId'] as String?,
      reward: json['reward'] != null ? DialogueReward.fromJson(json['reward']) : null,
      isEnd: json['isEnd'] as bool? ?? false,
    );
  }

  DialogueNode copyWith({
    String? id,
    String? speakerId,
    String? emotion,
    String? text,
    List<DialogueChoice>? choices,
    String? nextNodeId,
    DialogueReward? reward,
    bool? isEnd,
  }) {
    return DialogueNode(
      id: id ?? this.id,
      speakerId: speakerId ?? this.speakerId,
      emotion: emotion ?? this.emotion,
      text: text ?? this.text,
      choices: choices ?? this.choices,
      nextNodeId: nextNodeId ?? this.nextNodeId,
      reward: reward ?? this.reward,
      isEnd: isEnd ?? this.isEnd,
    );
  }

  /// 선택지가 있는지 여부
  bool get hasChoices => choices.isNotEmpty;

  /// 자동 진행 여부
  bool get isAutoProgress => !hasChoices && nextNodeId != null && !isEnd;

  @override
  List<Object?> get props => [
    id,
    speakerId,
    emotion,
    text,
    choices,
    nextNodeId,
    reward,
    isEnd,
  ];

  @override
  String toString() => 'DialogueNode(id: $id, hasChoices: $hasChoices)';
}

/// 대화 선택지
class DialogueChoice extends Equatable {
  final String id;
  final String text; // 선택지 텍스트
  final String? preview; // 선택 결과 미리보기
  final String nextNodeId; // 연결 노드
  final DialogueReward? reward; // 획득 보상
  final ChoiceCondition? condition; // 선택 조건

  const DialogueChoice({
    required this.id,
    required this.text,
    this.preview,
    required this.nextNodeId,
    this.reward,
    this.condition,
  });

  factory DialogueChoice.fromJson(Map<String, dynamic> json) {
    return DialogueChoice(
      id: json['id'] as String,
      text: json['text'] as String,
      preview: json['preview'] as String?,
      nextNodeId: json['nextNodeId'] as String,
      reward: json['reward'] != null ? DialogueReward.fromJson(json['reward']) : null,
      condition: json['condition'] != null ? ChoiceCondition.fromJson(json['condition']) : null,
    );
  }

  DialogueChoice copyWith({
    String? id,
    String? text,
    String? preview,
    String? nextNodeId,
    DialogueReward? reward,
    ChoiceCondition? condition,
  }) {
    return DialogueChoice(
      id: id ?? this.id,
      text: text ?? this.text,
      preview: preview ?? this.preview,
      nextNodeId: nextNodeId ?? this.nextNodeId,
      reward: reward ?? this.reward,
      condition: condition ?? this.condition,
    );
  }

  /// 조건이 있는지 여부
  bool get hasCondition => condition != null;

  @override
  List<Object?> get props => [id, text, preview, nextNodeId, reward, condition];

  @override
  String toString() => 'DialogueChoice(id: $id, text: $text)';
}

/// 선택 조건
class ChoiceCondition extends Equatable {
  final String? requiredFact; // 필요한 역사 사실
  final String? requiredCharacter; // 필요한 인물 해금
  final int? requiredKnowledge; // 필요한 지식 포인트

  const ChoiceCondition({
    this.requiredFact,
    this.requiredCharacter,
    this.requiredKnowledge,
  });

  factory ChoiceCondition.fromJson(Map<String, dynamic> json) {
    return ChoiceCondition(
      requiredFact: json['requiredFact'] as String?,
      requiredCharacter: json['requiredCharacter'] as String?,
      requiredKnowledge: json['requiredKnowledge'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    requiredFact,
    requiredCharacter,
    requiredKnowledge,
  ];
}

/// 대화 보상
class DialogueReward extends Equatable {
  final int knowledgePoints;
  final String? unlockFactId; // 해금되는 역사 사실
  final String? unlockCharacterId; // 해금되는 인물
  final String? achievementId; // 획득 업적

  const DialogueReward({
    this.knowledgePoints = 0,
    this.unlockFactId,
    this.unlockCharacterId,
    this.achievementId,
  });

  factory DialogueReward.fromJson(Map<String, dynamic> json) {
    return DialogueReward(
      knowledgePoints: json['knowledgePoints'] as int? ?? 0,
      unlockFactId: json['unlockFactId'] as String?,
      unlockCharacterId: json['unlockCharacterId'] as String?,
      achievementId: json['achievementId'] as String?,
    );
  }

  DialogueReward copyWith({
    int? knowledgePoints,
    String? unlockFactId,
    String? unlockCharacterId,
    String? achievementId,
  }) {
    return DialogueReward(
      knowledgePoints: knowledgePoints ?? this.knowledgePoints,
      unlockFactId: unlockFactId ?? this.unlockFactId,
      unlockCharacterId: unlockCharacterId ?? this.unlockCharacterId,
      achievementId: achievementId ?? this.achievementId,
    );
  }

  /// 보상이 있는지 여부
  bool get hasReward =>
      knowledgePoints > 0 ||
      unlockFactId != null ||
      unlockCharacterId != null ||
      achievementId != null;

  @override
  List<Object?> get props => [
    knowledgePoints,
    unlockFactId,
    unlockCharacterId,
    achievementId,
  ];

  @override
  String toString() =>
      'DialogueReward(points: $knowledgePoints, fact: $unlockFactId)';
}

/// 대화 진행 상태
class DialogueProgress extends Equatable {
  final String dialogueId;
  final String currentNodeId;
  final List<String> visitedNodeIds;
  final List<String> selectedChoiceIds;
  final int totalKnowledgeEarned;
  final List<String> unlockedFactIds;
  final List<String> unlockedCharacterIds;
  final bool isCompleted;
  final DateTime? completedAt;

  const DialogueProgress({
    required this.dialogueId,
    required this.currentNodeId,
    this.visitedNodeIds = const [],
    this.selectedChoiceIds = const [],
    this.totalKnowledgeEarned = 0,
    this.unlockedFactIds = const [],
    this.unlockedCharacterIds = const [],
    this.isCompleted = false,
    this.completedAt,
  });

  DialogueProgress copyWith({
    String? dialogueId,
    String? currentNodeId,
    List<String>? visitedNodeIds,
    List<String>? selectedChoiceIds,
    int? totalKnowledgeEarned,
    List<String>? unlockedFactIds,
    List<String>? unlockedCharacterIds,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return DialogueProgress(
      dialogueId: dialogueId ?? this.dialogueId,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      visitedNodeIds: visitedNodeIds ?? this.visitedNodeIds,
      selectedChoiceIds: selectedChoiceIds ?? this.selectedChoiceIds,
      totalKnowledgeEarned: totalKnowledgeEarned ?? this.totalKnowledgeEarned,
      unlockedFactIds: unlockedFactIds ?? this.unlockedFactIds,
      unlockedCharacterIds: unlockedCharacterIds ?? this.unlockedCharacterIds,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    dialogueId,
    currentNodeId,
    visitedNodeIds,
    selectedChoiceIds,
    totalKnowledgeEarned,
    unlockedFactIds,
    unlockedCharacterIds,
    isCompleted,
    completedAt,
  ];
}
