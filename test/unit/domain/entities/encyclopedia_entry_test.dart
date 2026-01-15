import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';

void main() {
  group('EncyclopediaEntry', () {
    final entry = EncyclopediaEntry(
      id: 'entry_sejong',
      type: EntryType.character,
      title: 'Sejong',
      titleKorean: '세종대왕',
      summary: 'Great King',
      content: 'Detailed content...',
      thumbnailAsset: 'sejong_thumb.png',
      imageAsset: 'sejong_full.png',
      eraId: 'joseon',
      relatedEntryIds: const ['entry_hangeul', 'entry_joseon'],
      tags: const ['king', 'scholar'],
      isDiscovered: true,
      discoveredAt: DateTime(2023, 1, 1),
      discoverySource: 'dialogue_sejong_1',
    );

    test('props가 올바르게 작동한다 (Equatable)', () {
      final entry2 = EncyclopediaEntry(
        id: 'entry_sejong',
        type: EntryType.character,
        title: 'Sejong',
        titleKorean: '세종대왕',
        summary: 'Great King',
        content: 'Detailed content...',
        thumbnailAsset: 'sejong_thumb.png',
        imageAsset: 'sejong_full.png',
        eraId: 'joseon',
        relatedEntryIds: const ['entry_hangeul', 'entry_joseon'],
        tags: const ['king', 'scholar'],
        isDiscovered: true,
        discoveredAt: DateTime(2023, 1, 1),
        discoverySource: 'dialogue_sejong_1',
      );

      expect(entry, equals(entry2));
    });

    test('copyWith가 값을 올바르게 변경한다', () {
      final updated = entry.copyWith(
        titleKorean: '세종',
        isDiscovered: false,
      );

      expect(updated.titleKorean, equals('세종'));
      expect(updated.isDiscovered, isFalse);
      // 유지
      expect(updated.id, equals(entry.id));
      expect(updated.type, equals(entry.type));
    });

    test('relatedCount가 올바른 개수를 반환한다', () {
      expect(entry.relatedCount, equals(2));
    });

    test('fromJson이 정상적으로 파싱한다', () {
      final json = {
        'id': 'entry_test',
        'type': 'artifact',
        'title': 'Test',
        'titleKorean': '테스트',
        'summary': 'Sum',
        'content': 'Cont',
        'thumbnailAsset': 'thumb.png',
        'eraId': 'joseon',
        'relatedEntryIds': ['r1'],
        'tags': ['t1'],
        'isDiscovered': true,
        'discoveredAt': '2023-01-01T00:00:00.000',
      };

      final parsed = EncyclopediaEntry.fromJson(json);

      expect(parsed.id, equals('entry_test'));
      expect(parsed.type, equals(EntryType.artifact));
      expect(parsed.titleKorean, equals('테스트'));
      expect(parsed.isDiscovered, isTrue);
      expect(parsed.discoveredAt?.year, equals(2023));
    });

    test('fromJson이 잘못된 타입에 대해 기본값(term)을 사용한다', () {
      final json = {
        'id': 'entry_test',
        'type': 'unknown_type',
        'title': 'Test',
        'titleKorean': '테스트',
        'summary': 'Sum',
        'content': 'Cont',
        'thumbnailAsset': 'thumb.png',
        'eraId': 'joseon',
      };

      final parsed = EncyclopediaEntry.fromJson(json);

      expect(parsed.type, equals(EntryType.term));
    });

    group('EntryTypeExtension', () {
      test('displayName이 올바른 문자열을 반환한다', () {
        expect(EntryType.character.displayName, equals('인물'));
        expect(EntryType.event.displayName, equals('사건'));
        expect(EntryType.location.displayName, equals('장소'));
        expect(EntryType.artifact.displayName, equals('문화재'));
        expect(EntryType.term.displayName, equals('용어'));
      });

      test('icon이 올바른 아이콘을 반환한다', () {
        expect(EntryType.character.icon, equals('👤'));
      });
    });
  });

  group('EncyclopediaStats', () {
    const stats = EncyclopediaStats(
      totalEntries: 100,
      discoveredEntries: 20,
      totalByType: {EntryType.character: 50, EntryType.event: 50},
      discoveredByType: {EntryType.character: 10, EntryType.event: 10},
    );

    test('discoveryRate가 올바른 비율을 계산한다', () {
      expect(stats.discoveryRate, equals(0.2));
    });

    test('discoveryPercent가 올바른 백분율을 반환한다', () {
      expect(stats.discoveryPercent, equals(20));
    });

    test('getTypeDiscoveryRate가 올바른 타입별 비율을 계산한다', () {
      expect(stats.getTypeDiscoveryRate(EntryType.character), equals(0.2));
    });

    test('데이터가 0일 때 0.0을 반환한다 (division by zero 방지)', () {
      const emptyStats = EncyclopediaStats(
        totalEntries: 0,
        discoveredEntries: 0,
        totalByType: {},
        discoveredByType: {},
      );

      expect(emptyStats.discoveryRate, equals(0.0));
      expect(emptyStats.getTypeDiscoveryRate(EntryType.character), equals(0.0));
    });
  });
}
