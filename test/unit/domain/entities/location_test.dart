import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

void main() {
  group('Location', () {
    const location = Location(
      id: 'loc_gyeongbokgung',
      eraId: 'joseon',
      name: 'Gyeongbokgung',
      nameKorean: '경복궁',
      description: 'The main royal palace of the Joseon dynasty.',
      thumbnailAsset: 'gyeongbokgung_thumb.png',
      backgroundAsset: 'gyeongbokgung_bg.png',
      kingdom: 'Joseon',
      latitude: 37.5796,
      longitude: 126.9770,
      displayYear: '1395',
      timelineOrder: 1,
      position: MapCoordinates(x: 100, y: 200),
      characterIds: ['sejong', 'yi_sun_sin'],
      eventIds: ['event_1'],
      status: ContentStatus.locked,
      isHistorical: true,
    );

    test('props가 올바르게 작동한다 (Equatable)', () {
      const location2 = Location(
        id: 'loc_gyeongbokgung',
        eraId: 'joseon',
        name: 'Gyeongbokgung',
        nameKorean: '경복궁',
        description: 'The main royal palace of the Joseon dynasty.',
        thumbnailAsset: 'gyeongbokgung_thumb.png',
        backgroundAsset: 'gyeongbokgung_bg.png',
        kingdom: 'Joseon',
        latitude: 37.5796,
        longitude: 126.9770,
        displayYear: '1395',
        timelineOrder: 1,
        position: MapCoordinates(x: 100, y: 200),
        characterIds: ['sejong', 'yi_sun_sin'],
        eventIds: ['event_1'],
        status: ContentStatus.locked,
        isHistorical: true,
      );

      expect(location, equals(location2));
    });

    test('copyWith가 값을 올바르게 변경한다', () {
      final updated = location.copyWith(
        nameKorean: '수정된 경복궁',
        status: ContentStatus.available,
        characterIds: ['sejong'],
      );

      expect(updated.nameKorean, equals('수정된 경복궁'));
      expect(updated.status, equals(ContentStatus.available));
      expect(updated.characterIds.length, equals(1));
      // 유지
      expect(updated.id, equals(location.id));
      expect(updated.position, equals(location.position));
    });

    test('isAccessible이 status에 따라 올바른 값을 반환한다', () {
      expect(location.copyWith(status: ContentStatus.locked).isAccessible, isFalse);
      
      expect(location.copyWith(status: ContentStatus.available).isAccessible, isTrue);
      expect(location.copyWith(status: ContentStatus.inProgress).isAccessible, isTrue);
      expect(location.copyWith(status: ContentStatus.completed).isAccessible, isTrue);
    });

    test('isCompleted가 status에 따라 올바른 값을 반환한다', () {
      expect(location.copyWith(status: ContentStatus.completed).isCompleted, isTrue);
      expect(location.copyWith(status: ContentStatus.inProgress).isCompleted, isFalse);
    });

    test('characterCount가 올바른 개수를 반환한다', () {
      expect(location.characterCount, equals(2));
    });

    test('fromJson이 정상적으로 파싱한다', () {
      final json = {
        'id': 'loc_test',
        'eraId': 'joseon',
        'name': 'Test Loc',
        'nameKorean': '테스트 장소',
        'description': 'Desc',
        'thumbnailAsset': 'thumb.png',
        'backgroundAsset': 'bg.png',
        'kingdom': 'Korea',
        'latitude': 37.0,
        'longitude': 127.0,
        'displayYear': '2023',
        'timelineOrder': 1,
        'position': {'x': 10.0, 'y': 20.0},
        'characterIds': ['c1'],
        'eventIds': ['e1'],
        'status': 'available',
        'isHistorical': true,
      };

      final parsed = Location.fromJson(json);

      expect(parsed.id, equals('loc_test'));
      expect(parsed.nameKorean, equals('테스트 장소'));
      expect(parsed.position.x, equals(10.0));
      expect(parsed.position.y, equals(20.0));
      expect(parsed.status, equals(ContentStatus.available));
      expect(parsed.characterIds, contains('c1'));
    });

    test('fromJson이 대체 키(lat/lon)를 처리한다', () {
      final json = {
        'id': 'loc_test',
        'eraId': 'joseon',
        'name': 'Test Loc',
        'nameKorean': '테스트 장소',
        'description': 'Desc',
        'thumbnailAsset': 'thumb.png',
        'backgroundAsset': 'bg.png',
        'lat': 37.5, // latitude 대신 lat
        'lon': 127.5, // longitude 대신 lon
        'position': {'x': 0, 'y': 0},
      };

      final parsed = Location.fromJson(json);

      expect(parsed.latitude, equals(37.5));
      expect(parsed.longitude, equals(127.5));
    });
  });
}
