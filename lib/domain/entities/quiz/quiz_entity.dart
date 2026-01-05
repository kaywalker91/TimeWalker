import 'package:equatable/equatable.dart';
import 'package:time_walker/domain/entities/quiz/quiz_enums.dart';

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
