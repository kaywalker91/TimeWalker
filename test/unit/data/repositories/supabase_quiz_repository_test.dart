import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/repositories/supabase_quiz_repository.dart';
import 'package:time_walker/domain/entities/quiz.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseContentLoader mockLoader;
  late SupabaseQuizRepository repository;

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    mockLoader = MockSupabaseContentLoader();
    repository = SupabaseQuizRepository(mockClient, mockLoader);
  });

  group('SupabaseQuizRepository', () {
    final testCategoryJson = {
      'id': 'cat_korean_history',
      'title': '한국사',
      'description': '한국 역사 퀴즈',
    };

    final testQuizJson = {
      'id': 'quiz_sejong_1',
      'question': '한글을 창제한 왕은?',
      'type': 'multipleChoice',
      'difficulty': 'easy',
      'options': ['세종대왕', '태조', '영조', '정조'],
      'correctAnswer': '세종대왕',
      'explanation': '세종대왕이 1443년에 훈민정음을 창제하였습니다.',
      'imageAsset': null,
      'eraId': 'joseon',
      'relatedFactId': null,
      'relatedDialogueId': 'dialogue_sejong',
      'relatedCharacterId': 'char_sejong',
      'relatedLocationId': null,
      'basePoints': 10,
      'timeLimitSeconds': 30,
      'categoryId': 'cat_korean_history',
    };

    test('getAllQuizzes returns all quizzes when loader succeeds', () async {
      // Arrange

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') {

          return [testCategoryJson];
        }
        if (dataset == 'quizzes') {
          return [testQuizJson];
        }
        return [];
      });

      // Act
      final result = await repository.getAllQuizzes();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'quiz_sejong_1');
      expect(result.first.question, '한글을 창제한 왕은?');
    });

    test('getQuizzesByEra filters quizzes by era', () async {
      // Arrange
      final modernQuizJson = Map<String, dynamic>.from(testQuizJson)
        ..['id'] = 'quiz_modern_1'
        ..['eraId'] = 'modern';

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson, modernQuizJson];
        return [];
      });

      // Act
      final result = await repository.getQuizzesByEra('joseon');

      // Assert
      expect(result.length, 1);
      expect(result.first.eraId, 'joseon');
    });

    test('getQuizzesByDifficulty filters quizzes by difficulty', () async {
      // Arrange
      final hardQuizJson = Map<String, dynamic>.from(testQuizJson)
        ..['id'] = 'quiz_hard_1'
        ..['difficulty'] = 'hard';

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson, hardQuizJson];
        return [];
      });

      // Act
      final result = await repository.getQuizzesByDifficulty(QuizDifficulty.easy);

      // Assert
      expect(result.length, 1);
      expect(result.first.difficulty, QuizDifficulty.easy);
    });

    test('getQuizById returns quiz when found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson];
        return [];
      });

      // Act
      final result = await repository.getQuizById('quiz_sejong_1');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'quiz_sejong_1');
    });

    test('getQuizById returns null when not found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson];
        return [];
      });

      // Act
      final result = await repository.getQuizById('nonexistent');

      // Assert
      expect(result, isNull);
    });

    test('getQuizCategories returns all categories', () async {
      // Arrange
      final anotherCategoryJson = {
        'id': 'cat_world_history',
        'title': '세계사',
        'description': '세계 역사 퀴즈',
      };

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') {
          return [testCategoryJson, anotherCategoryJson];
        }
        if (dataset == 'quizzes') return [testQuizJson];
        return [];
      });

      // Act
      final result = await repository.getQuizCategories();

      // Assert
      expect(result.length, 2);
      expect(result.map((c) => c.id), containsAll(['cat_korean_history', 'cat_world_history']));
    });

    test('getQuizzesByCategory returns quizzes for category', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson];
        return [];
      });

      // Act
      final result = await repository.getQuizzesByCategory('cat_korean_history');

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'quiz_sejong_1');
    });

    test('getQuizzesByDialogueId returns quizzes for dialogue', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson];
        return [];
      });

      // Act
      final result = await repository.getQuizzesByDialogueId('dialogue_sejong');

      // Assert
      expect(result.length, 1);
      expect(result.first.relatedDialogueId, 'dialogue_sejong');
    });

    test('handles Supabase error with fallback', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenThrow(PostgrestException(message: 'Network error'));

      // Act
      final result = await repository.getAllQuizzes();

      // Assert: Should return empty list from fallback
      expect(result, isEmpty);
    });

    test('skips invalid quiz JSON entries', () async {
      // Arrange
      final invalidJson = {'id': 'invalid', 'question': 'Invalid'};

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson, invalidJson];
        return [];
      });

      // Act
      final result = await repository.getAllQuizzes();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'quiz_sejong_1');
    });

    test('caches data after first load', () async {
      // Arrange
      var loadCount = 0;
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((invocation) async {
        loadCount++;
        final dataset = invocation.namedArguments[const Symbol('dataset')] as String;
        if (dataset == 'quiz_categories') return [testCategoryJson];
        if (dataset == 'quizzes') return [testQuizJson];
        return [];
      });

      // Act
      await repository.getAllQuizzes();
      await repository.getAllQuizzes();

      // Assert: Should only load twice (categories + quizzes) for first call
      expect(loadCount, 2); // categories + quizzes
    });
  });
}
