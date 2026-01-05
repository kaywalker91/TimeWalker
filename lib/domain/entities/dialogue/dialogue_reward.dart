import 'package:equatable/equatable.dart';

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
