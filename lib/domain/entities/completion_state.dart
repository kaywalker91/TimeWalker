import 'package:equatable/equatable.dart';

/// 완료 상태 엔티티
///
/// UserProgress에서 분리된 완료/발견 관련 정보를 담는 엔티티입니다.
/// 대화, 퀴즈, 도감, 업적 등의 완료 상태를 관리합니다.
///
/// ## 포함 정보
/// - 완료된 대화 목록 (completedDialogueIds)
/// - 완료된 퀴즈 목록 (completedQuizIds)
/// - 발견한 도감 항목 (encyclopediaDiscoveryDates)
/// - 획득한 업적 목록 (achievementIds)
///
/// ## 사용 예시
/// ```dart
/// final state = CompletionState(
///   completedDialogueIds: ['dialogue_1', 'dialogue_2'],
///   completedQuizIds: ['quiz_1'],
///   achievementIds: ['first_steps'],
/// );
///
/// print(state.isDialogueCompleted('dialogue_1')); // true
/// print(state.completedDialogueCount); // 2
/// ```
class CompletionState extends Equatable {
  /// 완료된 대화 ID 목록
  final List<String> completedDialogueIds;

  /// 완료된 퀴즈 ID 목록
  final List<String> completedQuizIds;

  /// 도감 항목 ID -> 발견 날짜
  final Map<String, DateTime> encyclopediaDiscoveryDates;

  /// 획득한 업적 ID 목록
  final List<String> achievementIds;

  /// @deprecated 하위 호환성을 위해 유지
  final List<String> discoveredEncyclopediaIds;

  const CompletionState({
    this.completedDialogueIds = const [],
    this.completedQuizIds = const [],
    this.encyclopediaDiscoveryDates = const {},
    this.achievementIds = const [],
    this.discoveredEncyclopediaIds = const [],
  });

  /// 복사본 생성
  CompletionState copyWith({
    List<String>? completedDialogueIds,
    List<String>? completedQuizIds,
    Map<String, DateTime>? encyclopediaDiscoveryDates,
    List<String>? achievementIds,
    List<String>? discoveredEncyclopediaIds,
  }) {
    return CompletionState(
      completedDialogueIds: completedDialogueIds ?? this.completedDialogueIds,
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      encyclopediaDiscoveryDates:
          encyclopediaDiscoveryDates ?? this.encyclopediaDiscoveryDates,
      achievementIds: achievementIds ?? this.achievementIds,
      discoveredEncyclopediaIds:
          discoveredEncyclopediaIds ?? this.discoveredEncyclopediaIds,
    );
  }

  /// 대화가 완료되었는지 확인
  bool isDialogueCompleted(String dialogueId) {
    return completedDialogueIds.contains(dialogueId);
  }

  /// 퀴즈가 완료되었는지 확인
  bool isQuizCompleted(String quizId) {
    return completedQuizIds.contains(quizId);
  }

  /// 도감 항목 발견 여부 확인
  bool isEncyclopediaDiscovered(String entryId) {
    return encyclopediaDiscoveryDates.containsKey(entryId) ||
        discoveredEncyclopediaIds.contains(entryId);
  }

  /// 업적 획득 여부 확인
  bool hasAchievement(String achievementId) {
    return achievementIds.contains(achievementId);
  }

  /// 도감 항목 발견 날짜 반환
  DateTime? getEncyclopediaDiscoveryDate(String entryId) {
    return encyclopediaDiscoveryDates[entryId];
  }

  /// 최신순으로 정렬된 발견된 도감 ID 목록
  List<String> get recentlyDiscoveredEncyclopediaIds {
    final entries = encyclopediaDiscoveryDates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // 최신순 (내림차순)
    return entries.map((e) => e.key).toList();
  }

  /// 대화 완료 처리
  CompletionState completeDialogue(String dialogueId) {
    if (completedDialogueIds.contains(dialogueId)) return this;
    return copyWith(
      completedDialogueIds: [...completedDialogueIds, dialogueId],
    );
  }

  /// 퀴즈 완료 처리
  CompletionState completeQuiz(String quizId) {
    if (completedQuizIds.contains(quizId)) return this;
    return copyWith(
      completedQuizIds: [...completedQuizIds, quizId],
    );
  }

  /// 도감 항목 발견 처리
  CompletionState discoverEncyclopedia(String entryId, [DateTime? date]) {
    if (encyclopediaDiscoveryDates.containsKey(entryId)) return this;
    final updated = Map<String, DateTime>.from(encyclopediaDiscoveryDates);
    updated[entryId] = date ?? DateTime.now();
    return copyWith(encyclopediaDiscoveryDates: updated);
  }

  /// 업적 획득 처리
  CompletionState addAchievement(String achievementId) {
    if (achievementIds.contains(achievementId)) return this;
    return copyWith(
      achievementIds: [...achievementIds, achievementId],
    );
  }

  /// 완료한 대화 수
  int get completedDialogueCount => completedDialogueIds.length;

  /// 완료한 퀴즈 수
  int get completedQuizCount => completedQuizIds.length;

  /// 발견한 도감 항목 수
  int get discoveredEncyclopediaCount => encyclopediaDiscoveryDates.length;

  /// 획득한 업적 수
  int get achievementCount => achievementIds.length;

  @override
  List<Object?> get props => [
        completedDialogueIds,
        completedQuizIds,
        encyclopediaDiscoveryDates,
        achievementIds,
        discoveredEncyclopediaIds,
      ];

  @override
  String toString() =>
      'CompletionState(dialogues: $completedDialogueCount, quizzes: $completedQuizCount, encyclopedia: $discoveredEncyclopediaCount)';
}
