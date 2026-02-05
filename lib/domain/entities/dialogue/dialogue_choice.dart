import 'package:equatable/equatable.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_reward.dart';

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
      id: json['id'] as String? ??
          'choice_${json['nextNodeId'] ?? DateTime.now().microsecondsSinceEpoch}',
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
