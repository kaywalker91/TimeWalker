import 'package:equatable/equatable.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_reward.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_choice.dart';

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
