import 'package:equatable/equatable.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_reward.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_node.dart';

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
      description: json['description'] as String? ?? '',
      nodes: (json['nodes'] as List).map((e) => DialogueNode.fromJson(e)).toList(),
      rewards: _parseRewards(json['rewards']),
      isCompleted: json['isCompleted'] as bool? ?? false,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
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
