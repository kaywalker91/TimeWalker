import 'package:equatable/equatable.dart';

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
