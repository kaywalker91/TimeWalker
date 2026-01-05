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
