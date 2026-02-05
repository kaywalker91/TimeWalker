import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/repositories/supabase_encyclopedia_repository.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseContentLoader mockLoader;
  late SupabaseEncyclopediaRepository repository;

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    mockLoader = MockSupabaseContentLoader();
    repository = SupabaseEncyclopediaRepository(mockClient, mockLoader);
  });

  group('SupabaseEncyclopediaRepository', () {
    final testEntryJson = {
      'id': 'enc_sejong',
      'type': 'character',
      'title': '세종대왕',
      'content': '조선의 4대 왕으로 훈민정음을 창제하였습니다.',
      'summary': '한글 창제자',
      'imageAsset': 'assets/images/encyclopedia/sejong.png',
      'eraId': 'joseon',
      'relatedCharacterId': 'char_sejong',
      'relatedLocationId': null,
      'relatedFactIds': <String>[],
      'tags': ['왕', '조선', '한글'],
      'status': 'available',
    };

    test('getAllEntries returns all entries when loader succeeds', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson]);

      // Act
      final result = await repository.getAllEntries();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'enc_sejong');
      expect(result.first.title, '세종대왕');
      verify(() => mockLoader.loadList(
        dataset: 'encyclopedia_entries',
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });

    test('getEntriesByType filters entries by type', () async {
      // Arrange
      final locationEntryJson = Map<String, dynamic>.from(testEntryJson)
        ..['id'] = 'enc_gyeongbokgung'
        ..['type'] = 'location'
        ..['title'] = '경복궁';

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson, locationEntryJson]);

      // Act
      final result = await repository.getEntriesByType(EntryType.character);

      // Assert
      expect(result.length, 1);
      expect(result.first.type, EntryType.character);
    });

    test('getEntriesByEra filters entries by era', () async {
      // Arrange
      final goryeoEntryJson = Map<String, dynamic>.from(testEntryJson)
        ..['id'] = 'enc_goryeo'
        ..['eraId'] = 'goryeo'
        ..['title'] = '고려 왕조';

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson, goryeoEntryJson]);

      // Act
      final result = await repository.getEntriesByEra('joseon');

      // Assert
      expect(result.length, 1);
      expect(result.first.eraId, 'joseon');
    });

    test('getEntryById returns entry when found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson]);

      // Act
      final result = await repository.getEntryById('enc_sejong');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'enc_sejong');
    });

    test('getEntryById returns null when not found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson]);

      // Act
      final result = await repository.getEntryById('nonexistent');

      // Assert
      expect(result, isNull);
    });

    test('searchEntries returns matching entries', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson]);

      // Act
      final result = await repository.searchEntries('세종');

      // Assert
      expect(result.length, 1);
      expect(result.first.title, contains('세종'));
    });

    test('handles Supabase error with fallback', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenThrow(PostgrestException(message: 'Network error'));

      // Act
      final result = await repository.getAllEntries();

      // Assert
      expect(result, isEmpty);
    });

    test('skips invalid entry JSON entries', () async {
      // Arrange
      final invalidJson = {'id': 'invalid', 'title': 'Invalid'};

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson, invalidJson]);

      // Act
      final result = await repository.getAllEntries();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'enc_sejong');
    });

    test('caches data after first load', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testEntryJson]);

      // Act
      await repository.getAllEntries();
      await repository.getAllEntries();

      // Assert
      verify(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });
  });
}
