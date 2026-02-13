import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:time_walker/domain/entities/localized_string.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_reward.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_node.dart';

/// 대화 엔티티
class Dialogue extends Equatable {
  final String id;
  final String characterId;
  
  // OLD: Keep for backward compatibility
  final String title;
  final String titleKorean;
  final String description;
  
  // NEW: i18n-aware fields
  final LocalizedString? localizedTitle;
  // description and nodes will be loaded from i18n files
  
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
    this.localizedTitle,
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
    LocalizedString? localizedTitle,
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
      localizedTitle: localizedTitle ?? this.localizedTitle,
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
  
  /// Get localized title for the given locale.
  String getTitle(Locale locale) {
    if (localizedTitle != null) {
      return localizedTitle!.get(locale);
    }
    return locale.languageCode == 'ko' ? titleKorean : title;
  }
  
  /// Get localized title for the given context.
  String getTitleForContext(BuildContext context) {
    return getTitle(Localizations.localeOf(context));
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
    localizedTitle,
  ];

  factory Dialogue.fromJson(Map<String, dynamic> json) {
    // Parse title - support both old and new formats
    final titleJson = json['title'];
    final LocalizedString? localizedTitle;
    final String title;
    final String titleKorean;
    
    if (titleJson is Map<String, dynamic>) {
      // New format: {"ko": "...", "en": "..."}
      localizedTitle = LocalizedString.fromJson(titleJson);
      title = localizedTitle.en ?? localizedTitle.ko;
      titleKorean = localizedTitle.ko;
    } else {
      // Old format: separate fields
      localizedTitle = null;
      title = titleJson as String;
      titleKorean = json['titleKorean'] as String;
    }
    
    return Dialogue(
      id: json['id'] as String,
      characterId: json['characterId'] as String,
      title: title,
      titleKorean: titleKorean,
      description: json['description'] as String? ?? '',
      nodes: (json['nodes'] as List).map((e) => DialogueNode.fromJson(e)).toList(),
      rewards: _parseRewards(json['rewards']),
      isCompleted: json['isCompleted'] as bool? ?? false,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
      localizedTitle: localizedTitle,
    );
  }

  static List<DialogueReward> _parseRewards(dynamic rewards) {
    if (rewards == null) return [];
    if (rewards is List) {
      return rewards
          .map((e) => DialogueReward.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (rewards is Map<String, dynamic>) {
      return [DialogueReward.fromJson(rewards)];
    }
    return [];
  }

  @override
  String toString() =>
      'Dialogue(id: $id, title: $titleKorean, completed: $isCompleted)';
}
