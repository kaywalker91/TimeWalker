import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/repositories/supabase_character_repository.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseContentLoader mockLoader;
  late SupabaseCharacterRepository repository;

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    mockLoader = MockSupabaseContentLoader();
    repository = SupabaseCharacterRepository(mockClient, mockLoader);
  });

  group('SupabaseCharacterRepository', () {
    final testCharacterJson = {
      'id': 'char_sejong',
      'eraId': 'joseon',
      'name': 'Sejong the Great',
      'nameKorean': '세종대왕',
      'title': '조선의 4대 왕',
      'birth': '1397',
      'death': '1450',
      'biography': '한글 창제',
      'fullBiography': '세종대왕은 훈민정음을 창제하였습니다.',
      'portraitAsset': 'assets/images/characters/sejong.png',
      'emotionAssets': <String>[],
      'dialogueIds': ['dialogue_sejong_1'],
      'relatedCharacterIds': <String>[],
      'relatedLocationIds': ['loc_gyeongbokgung'],
      'achievements': ['한글 창제'],
      'status': 'available',
      'isHistorical': true,
    };

    test('getAllCharacters returns all characters when loader succeeds', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testCharacterJson]);

      // Act
      final result = await repository.getAllCharacters();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'char_sejong');
      expect(result.first.nameKorean, '세종대왕');
      verify(() => mockLoader.loadList(
        dataset: 'characters',
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });

    test('getCharactersByEra filters characters by era', () async {
      // Arrange
      final goryeoCharacterJson = Map<String, dynamic>.from(testCharacterJson)
        ..['id'] = 'char_wanggeon'
        ..['eraId'] = 'goryeo'
        ..['nameKorean'] = '왕건';

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testCharacterJson, goryeoCharacterJson]);

      // Act
      final result = await repository.getCharactersByEra('joseon');

      // Assert
      expect(result.length, 1);
      expect(result.first.eraId, 'joseon');
    });

    test('getCharactersByLocation filters characters by location', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testCharacterJson]);

      // Act
      final result = await repository.getCharactersByLocation('loc_gyeongbokgung');

      // Assert
      expect(result.length, 1);
      expect(result.first.relatedLocationIds, contains('loc_gyeongbokgung'));
    });

    test('getCharacterById returns character when found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testCharacterJson]);

      // Act
      final result = await repository.getCharacterById('char_sejong');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'char_sejong');
    });

    test('getCharacterById returns null when not found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testCharacterJson]);

      // Act
      final result = await repository.getCharacterById('nonexistent');

      // Assert
      expect(result, isNull);
    });

    test('handles Supabase error by using fallback (loadList throws)', () async {
      // Arrange: loader throws PostgrestException
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenThrow(PostgrestException(message: 'Network error'));

      // Act
      final result = await repository.getAllCharacters();

      // Assert: Should return empty list from fallback (no assets in test)
      expect(result, isEmpty);
    });

    test('skips invalid character JSON entries', () async {
      // Arrange: Invalid JSON (missing required fields)
      final invalidJson = {'id': 'invalid', 'name': 'Invalid'};

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testCharacterJson, invalidJson]);

      // Act
      final result = await repository.getAllCharacters();

      // Assert: Should only contain valid character
      expect(result.length, 1);
      expect(result.first.id, 'char_sejong');
    });

    test('caches data after first load', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testCharacterJson]);

      // Act: Call twice
      await repository.getAllCharacters();
      await repository.getAllCharacters();

      // Assert: Loader should only be called once
      verify(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });
  });
}
