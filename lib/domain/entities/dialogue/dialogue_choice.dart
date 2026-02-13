import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/localized_string.dart';
import 'package:equatable/equatable.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_reward.dart';

/// 대화 선택지
class DialogueChoice extends Equatable {
  final String id;
  final String text; // 선택지 텍스트 (Legacy)
  final LocalizedString? localizedText; // 선택지 텍스트 (New)
  final String? preview; // 선택 결과 미리보기 (Legacy)
  final LocalizedString? localizedPreview; // 선택 결과 미리보기 (New)
  final String nextNodeId; // 연결 노드
  final DialogueReward? reward; // 획득 보상
  final ChoiceCondition? condition; // 선택 조건

  const DialogueChoice({
    required this.id,
    required this.text,
    this.localizedText,
    this.preview,
    this.localizedPreview,
    required this.nextNodeId,
    this.reward,
    this.condition,
  });

  factory DialogueChoice.fromJson(Map<String, dynamic> json) {
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

    // Parse preview
    final previewJson = json['preview'];
    String? preview;
    LocalizedString? localizedPreview;

    if (previewJson is Map<String, dynamic>) {
      localizedPreview = LocalizedString.fromJson(previewJson);
      preview = localizedPreview.ko;
    } else if (previewJson is String) {
      preview = previewJson;
      localizedPreview = LocalizedString.same(preview);
    }

    return DialogueChoice(
      id: json['id'] as String? ??
          'choice_${json['nextNodeId'] ?? DateTime.now().microsecondsSinceEpoch}',
      text: text,
      localizedText: localizedText,
      preview: preview,
      localizedPreview: localizedPreview,
      nextNodeId: json['nextNodeId'] as String,
      reward: json['reward'] != null ? DialogueReward.fromJson(json['reward']) : null,
      condition: json['condition'] != null ? ChoiceCondition.fromJson(json['condition']) : null,
    );
  }

  DialogueChoice copyWith({
    String? id,
    String? text,
    LocalizedString? localizedText,
    String? preview,
    LocalizedString? localizedPreview,
    String? nextNodeId,
    DialogueReward? reward,
    ChoiceCondition? condition,
  }) {
    return DialogueChoice(
      id: id ?? this.id,
      text: text ?? this.text,
      localizedText: localizedText ?? this.localizedText,
      preview: preview ?? this.preview,
      localizedPreview: localizedPreview ?? this.localizedPreview,
      nextNodeId: nextNodeId ?? this.nextNodeId,
      reward: reward ?? this.reward,
      condition: condition ?? this.condition,
    );
  }

  /// Get localized text for the given locale.
  String getText(Locale locale) {
    if (localizedText != null) {
      return localizedText!.get(locale);
    }
    return text;
  }

  /// Get localized preview for the given locale.
  String? getPreview(Locale locale) {
    if (localizedPreview != null) {
      return localizedPreview!.get(locale);
    }
    return preview;
  }

  /// 조건이 있는지 여부
  bool get hasCondition => condition != null;

  @override
  List<Object?> get props => [id, text, localizedText, preview, localizedPreview, nextNodeId, reward, condition];

  @override
  String toString() => 'DialogueChoice(id: $id, text: $text)';
}
