import 'package:equatable/equatable.dart';

/// 퀴즈 결과
class QuizResult extends Equatable {
  final String quizId;
  final bool isCorrect;
  final String userAnswer;
  final int pointsEarned;
  final int timeSpentSeconds;
  final DateTime answeredAt;

  const QuizResult({
    required this.quizId,
    required this.isCorrect,
    required this.userAnswer,
    required this.pointsEarned,
    required this.timeSpentSeconds,
    required this.answeredAt,
  });

  @override
  List<Object?> get props => [
    quizId,
    isCorrect,
    userAnswer,
    pointsEarned,
    timeSpentSeconds,
    answeredAt,
  ];
}

/// 퀴즈 세션 (연속 퀴즈 진행)
class QuizSession extends Equatable {
  final String id;
  final String eraId;
  final List<String> quizIds;
  final List<QuizResult> results;
  final int currentIndex;
  final DateTime startedAt;
  final DateTime? completedAt;

  const QuizSession({
    required this.id,
    required this.eraId,
    required this.quizIds,
    this.results = const [],
    this.currentIndex = 0,
    required this.startedAt,
    this.completedAt,
  });

  QuizSession copyWith({
    String? id,
    String? eraId,
    List<String>? quizIds,
    List<QuizResult>? results,
    int? currentIndex,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return QuizSession(
      id: id ?? this.id,
      eraId: eraId ?? this.eraId,
      quizIds: quizIds ?? this.quizIds,
      results: results ?? this.results,
      currentIndex: currentIndex ?? this.currentIndex,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// 총 퀴즈 수
  int get totalQuizzes => quizIds.length;

  /// 완료한 퀴즈 수
  int get completedQuizzes => results.length;

  /// 정답 수
  int get correctAnswers => results.where((r) => r.isCorrect).length;

  /// 정답률 (0.0 ~ 1.0)
  double get accuracy {
    if (results.isEmpty) return 0.0;
    return correctAnswers / results.length;
  }

  /// 정답률 백분율 (0-100)
  int get accuracyPercent => (accuracy * 100).round();

  /// 총 획득 포인트
  int get totalPointsEarned =>
      results.fold(0, (sum, r) => sum + r.pointsEarned);

  /// 완료 여부
  bool get isCompleted => completedAt != null;

  /// 진행률 (0.0 ~ 1.0)
  double get progress {
    if (quizIds.isEmpty) return 0.0;
    return completedQuizzes / totalQuizzes;
  }

  @override
  List<Object?> get props => [
    id,
    eraId,
    quizIds,
    results,
    currentIndex,
    startedAt,
    completedAt,
  ];
}
