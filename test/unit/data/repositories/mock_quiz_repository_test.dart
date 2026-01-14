import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/quiz/quiz_entities.dart';
import 'package:time_walker/domain/entities/quiz_category.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockQuizRepository', () {
    group('with asset loading', () {
      setUpAll(() {
        // Set up root bundle for asset loading in tests
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall message) async {
            // Return a sample quiz JSON for testing
            if (message.method == 'loadString' &&
                message.arguments == 'assets/data/quizzes.json') {
              return _mockQuizJson;
            }
            return null;
          },
        );
      });

      tearDownAll(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });

      // Note: Since MockQuizRepository uses rootBundle.loadString which
      // doesn't work in standard unit tests, we test it with widget test
      // binding or need to mock the asset bundle.
    });
  });

  // Test with the quiz entities directly without asset loading
  group('Quiz Entity', () {
    test('creates quiz with required fields', () {
      const quiz = Quiz(
        id: 'test_quiz_1',
        question: '테스트 질문입니다',
        type: QuizType.multipleChoice,
        difficulty: QuizDifficulty.easy,
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 'A',
        explanation: '설명입니다',
        eraId: 'joseon',
        basePoints: 10,
      );

      expect(quiz.id, equals('test_quiz_1'));
      expect(quiz.question, equals('테스트 질문입니다'));
      expect(quiz.type, equals(QuizType.multipleChoice));
      expect(quiz.difficulty, equals(QuizDifficulty.easy));
      expect(quiz.options.length, equals(4));
      expect(quiz.correctAnswer, equals('A'));
      expect(quiz.basePoints, equals(10));
    });

    test('QuizDifficulty has correct point multipliers', () {
      expect(QuizDifficulty.easy.pointMultiplier, equals(1));
      expect(QuizDifficulty.medium.pointMultiplier, equals(2));
      expect(QuizDifficulty.hard.pointMultiplier, equals(3));
    });

    test('QuizDifficulty has display names', () {
      expect(QuizDifficulty.easy.displayName, equals('쉬움'));
      expect(QuizDifficulty.medium.displayName, equals('보통'));
      expect(QuizDifficulty.hard.displayName, equals('어려움'));
    });

    test('QuizType has display names and icons', () {
      expect(QuizType.multipleChoice.displayName, equals('객관식'));
      expect(QuizType.multipleChoice.icon, equals('📝'));
      expect(QuizType.trueFalse.displayName, equals('O/X 퀴즈'));
      expect(QuizType.trueFalse.icon, equals('⭕'));
    });
  });

  group('QuizCategory', () {
    test('creates from JSON', () {
      final json = {
        'id': 'history_korea',
        'title': '한국사',
        'description': '한국의 역사에 관한 퀴즈',
      };

      final category = QuizCategory.fromJson(json);

      expect(category.id, equals('history_korea'));
      expect(category.title, equals('한국사'));
      expect(category.description, equals('한국의 역사에 관한 퀴즈'));
    });

    test('implements Equatable correctly', () {
      const category1 = QuizCategory(
        id: 'test',
        title: 'Test Title',
        description: 'Test Description',
      );
      const category2 = QuizCategory(
        id: 'test',
        title: 'Test Title',
        description: 'Test Description',
      );
      const category3 = QuizCategory(
        id: 'different',
        title: 'Different Title',
        description: 'Different Description',
      );

      expect(category1, equals(category2));
      expect(category1, isNot(equals(category3)));
    });
  });

  group('TestableQuizRepository', () {
    late TestableQuizRepository repository;

    setUp(() {
      repository = TestableQuizRepository();
    });

    group('getAllQuizzes', () {
      test('returns all quizzes from mock data', () async {
        final quizzes = await repository.getAllQuizzes();

        expect(quizzes, isNotEmpty);
        expect(quizzes.length, equals(3));
      });
    });

    group('getQuizzesByEra', () {
      test('returns quizzes filtered by era id', () async {
        final quizzes = await repository.getQuizzesByEra('joseon');

        expect(quizzes, isNotEmpty);
        for (final quiz in quizzes) {
          expect(quiz.eraId, equals('joseon'));
        }
      });

      test('returns empty list for non-existent era', () async {
        final quizzes = await repository.getQuizzesByEra('non_existent_era');

        expect(quizzes, isEmpty);
      });
    });

    group('getQuizzesByDifficulty', () {
      test('returns quizzes filtered by difficulty', () async {
        final easyQuizzes = await repository.getQuizzesByDifficulty(QuizDifficulty.easy);

        expect(easyQuizzes, isNotEmpty);
        for (final quiz in easyQuizzes) {
          expect(quiz.difficulty, equals(QuizDifficulty.easy));
        }
      });

      test('returns different counts for different difficulties', () async {
        final easyQuizzes = await repository.getQuizzesByDifficulty(QuizDifficulty.easy);
        final mediumQuizzes = await repository.getQuizzesByDifficulty(QuizDifficulty.medium);

        expect(easyQuizzes.length, equals(2));
        expect(mediumQuizzes.length, equals(1));
      });
    });

    group('getQuizById', () {
      test('returns quiz for valid id', () async {
        final quiz = await repository.getQuizById('quiz_easy_1');

        expect(quiz, isNotNull);
        expect(quiz!.id, equals('quiz_easy_1'));
      });

      test('returns null for non-existent id', () async {
        final quiz = await repository.getQuizById('non_existent_quiz');

        expect(quiz, isNull);
      });
    });

    group('getQuizCategories', () {
      test('returns all categories', () async {
        final categories = await repository.getQuizCategories();

        expect(categories, isNotEmpty);
        expect(categories.length, equals(2));
      });
    });

    group('getQuizzesByCategory', () {
      test('returns quizzes for valid category', () async {
        final quizzes = await repository.getQuizzesByCategory('joseon_category');

        expect(quizzes, isNotEmpty);
        expect(quizzes.length, equals(2));
      });

      test('returns empty list for non-existent category', () async {
        final quizzes = await repository.getQuizzesByCategory('non_existent_category');

        expect(quizzes, isEmpty);
      });
    });

    group('getQuizzesByDialogueId', () {
      test('returns quizzes for valid dialogue id', () async {
        final quizzes = await repository.getQuizzesByDialogueId('sejong_intro');

        expect(quizzes, isNotEmpty);
        for (final quiz in quizzes) {
          expect(quiz.relatedDialogueId, equals('sejong_intro'));
        }
      });

      test('returns empty list for non-existent dialogue id', () async {
        final quizzes = await repository.getQuizzesByDialogueId('non_existent_dialogue');

        expect(quizzes, isEmpty);
      });
    });
  });
}

/// TestableQuizRepository that doesn't require asset loading
/// Uses in-memory mock data for testing
class TestableQuizRepository {
  final List<Quiz> _quizzes = [
    const Quiz(
      id: 'quiz_easy_1',
      question: '훈민정음을 창제한 왕은 누구일까요?',
      type: QuizType.multipleChoice,
      difficulty: QuizDifficulty.easy,
      options: ['세종대왕', '태조 이성계', '정조', '고종'],
      correctAnswer: '세종대왕',
      explanation: '세종대왕은 1443년에 훈민정음을 창제했습니다.',
      eraId: 'joseon',
      basePoints: 10,
      relatedDialogueId: 'sejong_intro',
    ),
    const Quiz(
      id: 'quiz_easy_2',
      question: '임진왜란에서 거북선을 이끈 장군은?',
      type: QuizType.multipleChoice,
      difficulty: QuizDifficulty.easy,
      options: ['강감찬', '을지문덕', '이순신', '김유신'],
      correctAnswer: '이순신',
      explanation: '이순신 장군은 거북선을 이끌고 임진왜란에서 승리했습니다.',
      eraId: 'joseon',
      basePoints: 10,
    ),
    const Quiz(
      id: 'quiz_medium_1',
      question: '고려시대 팔만대장경이 제작된 이유는?',
      type: QuizType.multipleChoice,
      difficulty: QuizDifficulty.medium,
      options: ['불교 전파', '몽골 침입 격퇴 기원', '왕권 강화', '학문 발전'],
      correctAnswer: '몽골 침입 격퇴 기원',
      explanation: '팔만대장경은 몽골 침입을 부처의 힘으로 막고자 제작되었습니다.',
      eraId: 'goryeo',
      basePoints: 15,
    ),
  ];

  final List<QuizCategory> _categories = [
    const QuizCategory(
      id: 'joseon_category',
      title: '조선시대',
      description: '조선시대 역사 퀴즈',
    ),
    const QuizCategory(
      id: 'goryeo_category',
      title: '고려시대',
      description: '고려시대 역사 퀴즈',
    ),
  ];

  final Map<String, List<Quiz>> _quizzesByCategory = {
    'joseon_category': [
      const Quiz(
        id: 'quiz_easy_1',
        question: '훈민정음을 창제한 왕은 누구일까요?',
        type: QuizType.multipleChoice,
        difficulty: QuizDifficulty.easy,
        options: ['세종대왕', '태조 이성계', '정조', '고종'],
        correctAnswer: '세종대왕',
        explanation: '세종대왕은 1443년에 훈민정음을 창제했습니다.',
        eraId: 'joseon',
        basePoints: 10,
      ),
      const Quiz(
        id: 'quiz_easy_2',
        question: '임진왜란에서 거북선을 이끈 장군은?',
        type: QuizType.multipleChoice,
        difficulty: QuizDifficulty.easy,
        options: ['강감찬', '을지문덕', '이순신', '김유신'],
        correctAnswer: '이순신',
        explanation: '이순신 장군은 거북선을 이끌고 임진왜란에서 승리했습니다.',
        eraId: 'joseon',
        basePoints: 10,
      ),
    ],
    'goryeo_category': [
      const Quiz(
        id: 'quiz_medium_1',
        question: '고려시대 팔만대장경이 제작된 이유는?',
        type: QuizType.multipleChoice,
        difficulty: QuizDifficulty.medium,
        options: ['불교 전파', '몽골 침입 격퇴 기원', '왕권 강화', '학문 발전'],
        correctAnswer: '몽골 침입 격퇴 기원',
        explanation: '팔만대장경은 몽골 침입을 부처의 힘으로 막고자 제작되었습니다.',
        eraId: 'goryeo',
        basePoints: 15,
      ),
    ],
  };

  Future<List<Quiz>> getAllQuizzes() async {
    return _quizzes;
  }

  Future<List<Quiz>> getQuizzesByEra(String eraId) async {
    return _quizzes.where((q) => q.eraId == eraId).toList();
  }

  Future<List<Quiz>> getQuizzesByDifficulty(QuizDifficulty difficulty) async {
    return _quizzes.where((q) => q.difficulty == difficulty).toList();
  }

  Future<Quiz?> getQuizById(String id) async {
    try {
      return _quizzes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<QuizCategory>> getQuizCategories() async {
    return _categories;
  }

  Future<List<Quiz>> getQuizzesByCategory(String categoryId) async {
    return _quizzesByCategory[categoryId] ?? [];
  }

  Future<List<Quiz>> getQuizzesByDialogueId(String dialogueId) async {
    return _quizzes.where((q) => q.relatedDialogueId == dialogueId).toList();
  }
}

/// Mock JSON for asset loading tests (not used due to rootBundle limitations in unit tests)
const String _mockQuizJson = '''
{
  "categories": [
    {
      "id": "test_category",
      "title": "Test",
      "description": "Test Category",
      "quizzes": [
        {
          "id": "test_quiz_1",
          "question": "Test question?",
          "type": "multipleChoice",
          "difficulty": "easy",
          "options": ["A", "B", "C", "D"],
          "correctAnswer": "A",
          "explanation": "Test explanation",
          "eraId": "joseon",
          "basePoints": 10
        }
      ]
    }
  ]
}
''';
