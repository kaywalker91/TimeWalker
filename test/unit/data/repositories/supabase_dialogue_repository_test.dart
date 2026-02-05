import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/repositories/supabase_dialogue_repository.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseContentLoader mockLoader;
  late SupabaseDialogueRepository repository;

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    mockLoader = MockSupabaseContentLoader();
    repository = SupabaseDialogueRepository(mockClient, mockLoader);
  });

  group('SupabaseDialogueRepository', () {
    final testDialogueJson = {
      'id': 'dialogue_sejong_1',
      'characterId': 'char_sejong',
      'title': 'Hunminjeongeum',
      'titleKorean': '훈민정음 창제',
      'description': '세종대왕과 한글에 대해 대화합니다.',
      'nodes': [
        {
          'id': 'node_1',
          'speakerId': 'char_sejong',
          'emotion': 'neutral',
          'text': '백성을 위한 글자를 만들고자 합니다.',
          'nextNodeId': null,
          'choices': <Map<String, dynamic>>[],
        }
      ],
      'rewards': <Map<String, dynamic>>[],
      'isCompleted': false,
      'estimatedMinutes': 5,
    };

    test('getAllDialogues returns all dialogues when loader succeeds', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testDialogueJson]);

      // Act
      final result = await repository.getAllDialogues();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'dialogue_sejong_1');
      expect(result.first.titleKorean, '훈민정음 창제');
      verify(() => mockLoader.loadList(
        dataset: 'dialogues',
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });

    test('getDialoguesByCharacter filters dialogues by character', () async {
      // Arrange
      final otherDialogueJson = {
        'id': 'dialogue_other',
        'characterId': 'char_taejong',
        'title': 'Other Dialogue',
        'titleKorean': '다른 대화',
        'description': '',
        'nodes': <Map<String, dynamic>>[],
        'rewards': <Map<String, dynamic>>[],
        'isCompleted': false,
        'estimatedMinutes': 5,
      };

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testDialogueJson, otherDialogueJson]);

      // Act
      final result = await repository.getDialoguesByCharacter('char_sejong');

      // Assert
      expect(result.length, 1);
      expect(result.first.characterId, 'char_sejong');
    });

    test('getDialogueById returns dialogue when found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testDialogueJson]);

      // Act
      final result = await repository.getDialogueById('dialogue_sejong_1');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'dialogue_sejong_1');
    });

    test('getDialogueById returns null when not found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testDialogueJson]);

      // Act
      final result = await repository.getDialogueById('nonexistent');

      // Assert
      expect(result, isNull);
    });

    test('handles Supabase error with fallback', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenThrow(PostgrestException(message: 'Network error'));

      // Act
      final result = await repository.getAllDialogues();

      // Assert
      expect(result, isEmpty);
    });

    test('skips invalid dialogue JSON entries', () async {
      // Arrange
      final invalidJson = {'id': 'invalid', 'title': 'Invalid'};

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testDialogueJson, invalidJson]);

      // Act
      final result = await repository.getAllDialogues();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'dialogue_sejong_1');
    });

    test('caches data after first load', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testDialogueJson]);

      // Act
      await repository.getAllDialogues();
      await repository.getAllDialogues();

      // Assert
      verify(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });
  });
}
