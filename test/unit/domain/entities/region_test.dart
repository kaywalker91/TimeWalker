import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

void main() {
  group('Region', () {
    const region = Region(
      id: 'asia',
      name: 'Asia',
      nameKorean: '아시아',
      description: 'The largest continent.',
      iconAsset: 'asia_icon.png',
      thumbnailAsset: 'asia_thumb.png',
      countryIds: ['korea', 'china', 'japan'],
      center: MapCoordinates(x: 100, y: 100),
      defaultZoom: 1.5,
      status: ContentStatus.locked,
      progress: 0.5,
      unlockLevel: 1,
    );

    test('props가 올바르게 작동한다 (Equatable)', () {
      const region2 = Region(
        id: 'asia',
        name: 'Asia',
        nameKorean: '아시아',
        description: 'The largest continent.',
        iconAsset: 'asia_icon.png',
        thumbnailAsset: 'asia_thumb.png',
        countryIds: ['korea', 'china', 'japan'],
        center: MapCoordinates(x: 100, y: 100),
        defaultZoom: 1.5,
        status: ContentStatus.locked,
        progress: 0.5,
        unlockLevel: 1,
      );

      expect(region, equals(region2));
    });

    test('copyWith가 값을 올바르게 변경한다', () {
      final updated = region.copyWith(
        nameKorean: '수정된 아시아',
        status: ContentStatus.available,
        progress: 0.8,
      );

      expect(updated.nameKorean, equals('수정된 아시아'));
      expect(updated.status, equals(ContentStatus.available));
      expect(updated.progress, equals(0.8));
      // 유지
      expect(updated.id, equals(region.id));
      expect(updated.center, equals(region.center));
    });

    test('progressPercent가 올바른 백분율을 반환한다', () {
      expect(region.progressPercent, equals(50));
      
      final full = region.copyWith(progress: 1.0);
      expect(full.progressPercent, equals(100));
    });

    test('isAccessible이 status에 따라 올바른 값을 반환한다', () {
      expect(region.copyWith(status: ContentStatus.locked).isAccessible, isFalse);
      
      expect(region.copyWith(status: ContentStatus.available).isAccessible, isTrue);
      expect(region.copyWith(status: ContentStatus.inProgress).isAccessible, isTrue);
      expect(region.copyWith(status: ContentStatus.completed).isAccessible, isTrue);
    });

    test('isCompleted가 status에 따라 올바른 값을 반환한다', () {
      expect(region.copyWith(status: ContentStatus.completed).isCompleted, isTrue);
      expect(region.copyWith(status: ContentStatus.inProgress).isCompleted, isFalse);
    });
  });

  group('MapCoordinates', () {
    test('props가 올바르게 작동한다', () {
      const c1 = MapCoordinates(x: 10, y: 20);
      const c2 = MapCoordinates(x: 10, y: 20);
      expect(c1, equals(c2));
    });

    test('copyWith가 값을 올바르게 변경한다', () {
      const c1 = MapCoordinates(x: 10, y: 20);
      final c2 = c1.copyWith(x: 15);
      expect(c2.x, equals(15));
      expect(c2.y, equals(20));
    });
  });
}
