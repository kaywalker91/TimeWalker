import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

void main() {
  group('Country', () {
    const country = Country(
      id: 'korea',
      regionId: 'asia',
      name: 'Korea',
      nameKorean: '한국',
      description: 'Land of the Morning Calm',
      thumbnailAsset: 'korea_thumb.png',
      backgroundAsset: 'korea_bg.png',
      position: MapCoordinates(x: 120, y: 120),
      eraIds: ['three_kingdoms', 'joseon'],
      status: ContentStatus.available,
      progress: 0.35,
    );

    test('props가 올바르게 작동한다 (Equatable)', () {
      const country2 = Country(
        id: 'korea',
        regionId: 'asia',
        name: 'Korea',
        nameKorean: '한국',
        description: 'Land of the Morning Calm',
        thumbnailAsset: 'korea_thumb.png',
        backgroundAsset: 'korea_bg.png',
        position: MapCoordinates(x: 120, y: 120),
        eraIds: ['three_kingdoms', 'joseon'],
        status: ContentStatus.available,
        progress: 0.35,
      );
      expect(country, equals(country2));
    });

    test('progressPercent가 올바른 정수 백분율을 반환한다', () {
      expect(country.progressPercent, equals(35));
    });

    test('isAccessible이 status에 따라 올바른 값을 반환한다', () {
      expect(country.isAccessible, isTrue);
      expect(country.copyWith(status: ContentStatus.locked).isAccessible, isFalse);
    });

    test('isCompleted가 status에 따라 올바른 값을 반환한다', () {
      expect(country.isCompleted, isFalse);
      expect(country.copyWith(status: ContentStatus.completed).isCompleted, isTrue);
    });

    test('eraCount가 올바른 개수를 반환한다', () {
      expect(country.eraCount, equals(2));
    });

    test('copyWith가 올바르게 작동한다', () {
      final updated = country.copyWith(progress: 1.0, status: ContentStatus.completed);
      expect(updated.progress, equals(1.0));
      expect(updated.isCompleted, isTrue);
    });
  });
}
