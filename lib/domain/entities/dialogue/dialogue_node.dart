import 'dart:ui';
import 'package:time_walker/domain/entities/localized_string.dart';
import 'package:equatable/equatable.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_reward.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_choice.dart';

/// 대화 노드 (대화의 각 단계)
class DialogueNode extends Equatable {
  final String id;
  final String speakerId; // 화자 ID (Legacy)
  final String? speaker; // 화자 ID or Name (New)
  final String emotion; // 표정 상태
  final String text; // 대사 내용 (Legacy)
  final LocalizedString? localizedText; // 대사 내용 (New)
  final List<DialogueChoice> choices; // 선택지 (없으면 자동 진행)
  final String? nextNodeId; // 다음 노드 ID (선택지 없을 때)
  final DialogueReward? reward; // 노드 보상
  final bool isEnd; // 종료 노드 여부

  const DialogueNode({
    required this.id,
    required this.speakerId,
    this.speaker,
    required this.text,
    this.localizedText,
    this.emotion = 'neutral',
    this.choices = const [],
    this.nextNodeId,
    this.reward,
    this.isEnd = false,
  });

  factory DialogueNode.fromJson(Map<String, dynamic> json) {
    // Parse text
    final textJson = json['text'];
    String text = '';
    LocalizedString? localizedText;

    if (textJson is Map<String, dynamic>) {
      localizedText = LocalizedString.fromJson(textJson);
      text = localizedText.ko;
    } else if (textJson is String) {
      text = textJson;
      localizedText = LocalizedString.same(text);
    }

    // Parse speaker
    final speakerId = json['speakerId'] as String? ?? '';
    final speaker = json['speaker'] as String? ?? speakerId;

    return DialogueNode(
      id: json['id'] as String,
      speakerId: speakerId,
      speaker: speaker,
      text: text,
      localizedText: localizedText,
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
    String? speaker,
    String? emotion,
    String? text,
    LocalizedString? localizedText,
    List<DialogueChoice>? choices,
    String? nextNodeId,
    DialogueReward? reward,
    bool? isEnd,
  }) {
    return DialogueNode(
      id: id ?? this.id,
      speakerId: speakerId ?? this.speakerId,
      speaker: speaker ?? this.speaker,
      emotion: emotion ?? this.emotion,
      text: text ?? this.text,
      localizedText: localizedText ?? this.localizedText,
      choices: choices ?? this.choices,
      nextNodeId: nextNodeId ?? this.nextNodeId,
      reward: reward ?? this.reward,
      isEnd: isEnd ?? this.isEnd,
    );
  }

  /// Get localized text for the given locale.
  String getText(Locale locale) {
    if (localizedText != null) {
      return localizedText!.get(locale);
    }
    return text;
  }

  /// Get speaker ID (prefer new field).
  String getSpeakerId() {
    return (speaker != null && speaker!.isNotEmpty) ? speaker! : speakerId;
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
