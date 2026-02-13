import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/repositories/supabase_location_repository.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseContentLoader mockLoader;
  late SupabaseLocationRepository repository;

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    mockLoader = MockSupabaseContentLoader();
    repository = SupabaseLocationRepository(mockClient, mockLoader);
  });

  group('SupabaseLocationRepository', () {
    final testLocationJson = {
      'id': 'loc_gyeongbokgung',
      'eraId': 'joseon',
      'name': 'Gyeongbokgung Palace',
      'nameKorean': '경복궁',
      'description': '조선의 법궁',
      'detailedDescription': '경복궁은 1395년 태조 이성계에 의해 창건되었습니다.',
      'backgroundAsset': 'assets/images/locations/gyeongbokgung_bg.png',
      'thumbnailAsset': 'assets/images/locations/gyeongbokgung_thumb.png',
      'characterIds': ['char_sejong'],
      'dialogueIds': ['dialogue_palace_1'],
      'relatedLocationIds': <String>[],
      'quizIds': <String>[],
      'historicalFacts': ['1395년 창건'],
      'latitude': 37.5796,
      'longitude': 126.977,
      'status': 'available',
      'sortOrder': 1,
      'displayYear': '1395년',
      'kingdom': 'joseon',
      'isVirtual': false,
      'position': {'x': 0.5, 'y': 0.3},
    };

    test('getAllLocations returns all locations when loader succeeds', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testLocationJson]);

      // Act
      final result = await repository.getAllLocations();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'loc_gyeongbokgung');
      expect(result.first.nameKorean, '경복궁');
      verify(() => mockLoader.loadList(
        dataset: 'locations',
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });

    test('getLocationsByEra filters locations by era', () async {
      // Arrange
      final modernLocationJson = Map<String, dynamic>.from(testLocationJson)
        ..['id'] = 'loc_modern'
        ..['eraId'] = 'modern'
        ..['nameKorean'] = '현대 건물';

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testLocationJson, modernLocationJson]);

      // Act
      final result = await repository.getLocationsByEra('joseon');

      // Assert
      expect(result.length, 1);
      expect(result.first.eraId, 'joseon');
    });

    test('getLocationById returns location when found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testLocationJson]);

      // Act
      final result = await repository.getLocationById('loc_gyeongbokgung');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'loc_gyeongbokgung');
    });

    test('getLocationById returns null when not found', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testLocationJson]);

      // Act
      final result = await repository.getLocationById('nonexistent');

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
      final result = await repository.getAllLocations();

      // Assert
      expect(result, isEmpty);
    });

    test('skips invalid location JSON entries', () async {
      // Arrange
      final invalidJson = {'id': 'invalid', 'name': 'Invalid'};

      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testLocationJson, invalidJson]);

      // Act
      final result = await repository.getAllLocations();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'loc_gyeongbokgung');
    });

    test('caches data after first load', () async {
      // Arrange
      when(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).thenAnswer((_) async => [testLocationJson]);

      // Act
      await repository.getAllLocations();
      await repository.getAllLocations();

      // Assert
      verify(() => mockLoader.loadList(
        dataset: any(named: 'dataset'),
        fetchRemote: any(named: 'fetchRemote'),
        transform: any(named: 'transform'),
      )).called(1);
    });
  });
}
