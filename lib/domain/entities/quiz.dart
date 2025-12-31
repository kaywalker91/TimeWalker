import 'package:equatable/equatable.dart';

/// 퀴즈 타입
enum QuizType {
  multipleChoice, // 객관식 (4지선다)
  trueFalse, // O/X 퀴즈
  timeline, // 순서 맞추기
  matching, // 연결하기 (인물-업적)
  imageGuess, // 이미지 보고 맞추기
}

/// 퀴즈 타입 확장
extension QuizTypeExtension on QuizType {
  String get displayName {
    switch (this) {
      case QuizType.multipleChoice:
        return '객관식';
      case QuizType.trueFalse:
        return 'O/X 퀴즈';
      case QuizType.timeline:
        return '순서 맞추기';
      case QuizType.matching:
        return '연결하기';
      case QuizType.imageGuess:
        return '이미지 퀴즈';
    }
  }

  String get icon {
    switch (this) {
      case QuizType.multipleChoice:
        return '📝';
      case QuizType.trueFalse:
        return '⭕';
      case QuizType.timeline:
        return '📅';
      case QuizType.matching:
        return '🔗';
      case QuizType.imageGuess:
        return '🖼️';
    }
  }
}

/// 퀴즈 난이도
enum QuizDifficulty { easy, medium, hard }

/// 퀴즈 난이도 확장
extension QuizDifficultyExtension on QuizDifficulty {
  String get displayName {
    switch (this) {
      case QuizDifficulty.easy:
        return '쉬움';
      case QuizDifficulty.medium:
        return '보통';
      case QuizDifficulty.hard:
        return '어려움';
    }
  }

  int get pointMultiplier {
    switch (this) {
      case QuizDifficulty.easy:
        return 1;
      case QuizDifficulty.medium:
        return 2;
      case QuizDifficulty.hard:
        return 3;
    }
  }
}

/// 퀴즈 엔티티
class Quiz extends Equatable {
  final String id;
  final String question;
  final QuizType type;
  final QuizDifficulty difficulty;
  final List<String> options;
  final String correctAnswer; // 또는 정답 인덱스
  final String explanation; // 정답 해설
  final String? imageAsset; // 이미지 퀴즈용
  final String eraId; // 관련 시대
  final String? relatedFactId; // 연관 도감 항목
  final String? relatedDialogueId; // 연관 대화 ID (대화 후 퀴즈용)
  final int basePoints;
  final int timeLimitSeconds;

  const Quiz({
    required this.id,
    required this.question,
    required this.type,
    required this.difficulty,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.imageAsset,
    required this.eraId,
    this.relatedFactId,
    this.relatedDialogueId,
    this.basePoints = 10,
    this.timeLimitSeconds = 30,
  });

  Quiz copyWith({
    String? id,
    String? question,
    QuizType? type,
    QuizDifficulty? difficulty,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    String? imageAsset,
    String? eraId,
    String? relatedFactId,
    String? relatedDialogueId,
    int? basePoints,
    int? timeLimitSeconds,
  }) {
    return Quiz(
      id: id ?? this.id,
      question: question ?? this.question,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      imageAsset: imageAsset ?? this.imageAsset,
      eraId: eraId ?? this.eraId,
      relatedFactId: relatedFactId ?? this.relatedFactId,
      relatedDialogueId: relatedDialogueId ?? this.relatedDialogueId,
      basePoints: basePoints ?? this.basePoints,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
    );
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      question: json['question'] as String,
      type: QuizType.values.firstWhere(
        (e) => e.name == (json['type'] as String),
        orElse: () => QuizType.multipleChoice,
      ),
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.name == (json['difficulty'] as String),
        orElse: () => QuizDifficulty.medium,
      ),
      options: List<String>.from(json['options'] as List? ?? []),
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
      imageAsset: json['imageAsset'] as String?,
      eraId: json['eraId'] as String,
      relatedFactId: json['relatedFactId'] as String?,
      relatedDialogueId: json['relatedDialogueId'] as String?,
      basePoints: json['basePoints'] as int? ?? 10,
      timeLimitSeconds: json['timeLimitSeconds'] as int? ?? 30,
    );
  }

  /// 획득 가능 포인트 (난이도 보너스 포함)
  int get maxPoints => basePoints * difficulty.pointMultiplier;

  /// 정답 확인
  bool checkAnswer(String answer) {
    return answer.toLowerCase() == correctAnswer.toLowerCase();
  }

  /// 옵션 인덱스로 정답 확인
  bool checkAnswerByIndex(int index) {
    if (index < 0 || index >= options.length) return false;
    return options[index] == correctAnswer;
  }

  @override
  List<Object?> get props => [
    id,
    question,
    type,
    difficulty,
    options,
    correctAnswer,
    explanation,
    imageAsset,
    eraId,
    relatedFactId,
    relatedDialogueId,
    basePoints,
    timeLimitSeconds,
  ];

  @override
  String toString() => 'Quiz(id: $id, type: ${type.displayName})';
}

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
