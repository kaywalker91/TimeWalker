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
      basePoints: basePoints ?? this.basePoints,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
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

/// 기본 퀴즈 데이터 (MVP)
class QuizData {
  QuizData._();

  static const Quiz sejongHangul = Quiz(
    id: 'sejong_hangul_01',
    question: '세종대왕이 훈민정음을 반포한 해는?',
    type: QuizType.multipleChoice,
    difficulty: QuizDifficulty.easy,
    options: ['1443년', '1446년', '1450년', '1455년'],
    correctAnswer: '1446년',
    explanation:
        '훈민정음은 1443년에 창제되었고, 1446년 음력 9월에 반포되었습니다. '
        '이를 기념하여 양력 10월 9일을 한글날로 지정하였습니다.',
    eraId: 'korea_joseon',
    relatedFactId: 'hunminjeongeum',
    basePoints: 10,
    timeLimitSeconds: 20,
  );

  static const Quiz yiSunSinBattle = Quiz(
    id: 'yi_sun_sin_01',
    question: '이순신 장군이 12척의 배로 133척의 왜선을 물리친 해전은?',
    type: QuizType.multipleChoice,
    difficulty: QuizDifficulty.medium,
    options: ['한산도대첩', '명량해전', '노량해전', '옥포해전'],
    correctAnswer: '명량해전',
    explanation:
        '1597년 명량해전에서 이순신 장군은 단 12척의 배로 133척의 왜선을 '
        '물리치는 세계 해전 역사상 가장 위대한 승리를 거두었습니다.',
    eraId: 'korea_joseon',
    relatedFactId: 'myeongryang_battle',
    basePoints: 10,
    timeLimitSeconds: 25,
  );

  static const Quiz gwanggaetoTF = Quiz(
    id: 'gwanggaeto_tf_01',
    question: '광개토대왕은 백제를 정복하고 고구려의 영토를 최대로 넓혔다.',
    type: QuizType.trueFalse,
    difficulty: QuizDifficulty.easy,
    options: ['O', 'X'],
    correctAnswer: 'O',
    explanation:
        '광개토대왕은 18세에 즉위하여 64개의 성과 1,400개의 촌락을 정복하며 '
        '고구려 역사상 최대의 영토를 확보하였습니다.',
    eraId: 'korea_three_kingdoms',
    basePoints: 10,
    timeLimitSeconds: 15,
  );

  static List<Quiz> get all => [sejongHangul, yiSunSinBattle, gwanggaetoTF];

  static List<Quiz> getByEra(String eraId) {
    return all.where((q) => q.eraId == eraId).toList();
  }

  static List<Quiz> getByDifficulty(QuizDifficulty difficulty) {
    return all.where((q) => q.difficulty == difficulty).toList();
  }

  static Quiz? getById(String id) {
    try {
      return all.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }
}
