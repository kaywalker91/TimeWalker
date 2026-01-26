import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/constants/era_theme_ids.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/services/progression_service.dart';

import '../../../helpers/test_utils.dart';

void main() {
  late ProgressionService service;

  setUp(() {
    service = ProgressionService();
  });

  group('UnlockEvent', () {
    test('동일한 속성을 가진 두 이벤트는 같아야 함 (Equatable)', () {
      const event1 = UnlockEvent(
        type: UnlockType.era,
        id: 'joseon',
        name: '조선',
        message: '조선 시대가 해금되었습니다!',
      );
      const event2 = UnlockEvent(
        type: UnlockType.era,
        id: 'joseon',
        name: '조선',
        message: '조선 시대가 해금되었습니다!',
      );

      expect(event1, equals(event2));
    });

    test('다른 속성을 가진 두 이벤트는 달라야 함', () {
      const event1 = UnlockEvent(
        type: UnlockType.era,
        id: 'joseon',
        name: '조선',
      );
      const event2 = UnlockEvent(
        type: UnlockType.era,
        id: 'goryeo',
        name: '고려',
      );

      expect(event1, isNot(equals(event2)));
    });
  });

  group('ProgressionService', () {
    // =========================================================
    // checkUnlocks 테스트
    // =========================================================
    group('checkUnlocks', () {
      test('이미 해금된 시대는 다시 해금 이벤트가 발생하지 않음', () {
        // Given: joseon 시대가 이미 해금된 상태
        final progress = createMockUserProgress(
          unlockedEraIds: ['joseon'],
        );
        
        // 테스트용 Era (이미 해금된 시대)
        final testEras = [
          _createMockEra(
            id: 'joseon',
            nameKorean: '조선',
            previousEraId: null,
          ),
        ];

        // When: 해금 확인
        final events = service.checkUnlocks(
          progress,
          content: UnlockContent(eras: testEras),
        );

        // Then: 이미 해금된 joseon의 해금 이벤트 없음
        final eraEvents = events.where((e) => e.type == UnlockType.era && e.id == 'joseon');
        expect(eraEvents, isEmpty);
      });

      test('선행 조건 없는 시대는 즉시 해금 가능', () {
        // Given: 시대가 해금되지 않은 상태
        final progress = createMockUserProgress(
          unlockedEraIds: [],
        );
        
        // 선행 조건 없는 시대
        final testEras = [
          _createMockEra(
            id: 'joseon',
            nameKorean: '조선',
            previousEraId: null,
          ),
        ];

        // When: 해금 확인
        final events = service.checkUnlocks(
          progress,
          content: UnlockContent(eras: testEras),
        );

        // Then: joseon 해금 이벤트 발생
        final joseonEvent = events.firstWhere(
          (e) => e.type == UnlockType.era && e.id == 'joseon',
          orElse: () => throw Exception('joseon 해금 이벤트 없음'),
        );
        expect(joseonEvent.name, equals('조선'));
        expect(joseonEvent.message, contains('해금'));
      });

      test('선행 시대 진행률이 충족되면 해금됨', () {
        // Given: 선행 시대 진행률 50% (조건: 50% 이상)
        final progress = createMockUserProgress(
          unlockedEraIds: ['joseon'],
          eraProgress: {'joseon': 0.5},
        );
        
        final testEras = [
          _createMockEra(
            id: 'joseon',
            nameKorean: '조선',
            previousEraId: null,
          ),
          _createMockEra(
            id: 'three_kingdoms',
            nameKorean: '삼국시대',
            previousEraId: 'joseon',
            requiredProgress: 0.5,
          ),
        ];

        // When
        final events = service.checkUnlocks(
          progress,
          content: UnlockContent(eras: testEras),
        );

        // Then: three_kingdoms 해금
        final tkEvent = events.firstWhere(
          (e) => e.type == UnlockType.era && e.id == 'three_kingdoms',
          orElse: () => throw Exception('삼국시대 해금 이벤트 없음'),
        );
        expect(tkEvent.name, equals('삼국시대'));
      });

      test('선행 시대 진행률이 미달이면 해금되지 않음', () {
        // Given: 선행 시대 진행률 30% (조건: 50%)
        final progress = createMockUserProgress(
          unlockedEraIds: ['joseon'],
          eraProgress: {'joseon': 0.3},
        );
        
        final testEras = [
          _createMockEra(
            id: 'three_kingdoms',
            nameKorean: '삼국시대',
            previousEraId: 'joseon',
            requiredProgress: 0.5,
          ),
        ];

        // When
        final events = service.checkUnlocks(
          progress,
          content: UnlockContent(eras: testEras),
        );

        // Then: three_kingdoms 해금 이벤트 없음
        final tkEvents = events.where(
          (e) => e.type == UnlockType.era && e.id == 'three_kingdoms',
        );
        expect(tkEvents, isEmpty);
      });

      test('등급 승급 시 해금 이벤트 발생', () {
        // Given: novice에서 apprentice로 승급할 수 있는 포인트
        // apprentice threshold: 1000
        final progress = createMockUserProgress(
          rank: ExplorerRank.novice,
          totalKnowledge: 1500, // 승급 조건 초과
        );

        // When
        final events = service.checkUnlocks(
          progress,
          content: const UnlockContent(eras: []),
        );

        // Then: 랭크 승급 이벤트 발생
        final rankEvents = events.where((e) => e.type == UnlockType.rank);
        expect(rankEvents.isNotEmpty, isTrue);
      });

      test('등급 승급 시 지역 해금도 함께 발생', () {
        // Given: apprentice로 승급 (europe 해금)
        final progress = createMockUserProgress(
          rank: ExplorerRank.novice,
          totalKnowledge: 1500,
        );

        // When
        final events = service.checkUnlocks(
          progress,
          content: const UnlockContent(eras: []),
        );

        // Then: europe 지역 해금 이벤트
        final regionEvents = events.where(
          (e) => e.type == UnlockType.region && e.id == 'europe',
        );
        expect(regionEvents.isNotEmpty, isTrue);
      });

      test('등급이 하락하지 않음 (등업만 처리)', () {
        // Given: 이미 expert인 사용자, 포인트가 낮아도 등급 유지
        final progress = createMockUserProgress(
          rank: ExplorerRank.expert,
          totalKnowledge: 500, // novice 포인트지만 expert 유지
        );

        // When
        final events = service.checkUnlocks(
          progress,
          content: const UnlockContent(eras: []),
        );

        // Then: 등급 변경 이벤트 없음
        final rankEvents = events.where((e) => e.type == UnlockType.rank);
        expect(rankEvents, isEmpty);
      });
    });

    // =========================================================
    // calculateEraProgress 테스트
    // =========================================================
    group('calculateEraProgress', () {
      test('대화가 없으면 0 반환', () {
        // Given
        final progress = createMockUserProgress();
        final dialogues = <Dialogue>[];

        // When
        final result = service.calculateEraProgress('joseon', progress, dialogues);

        // Then
        expect(result, equals(0.0));
      });

      test('모든 대화를 완료하면 1.0 반환', () {
        // Given: 3개 대화 모두 완료
        final progress = createMockUserProgress(
          completedDialogueIds: ['d1', 'd2', 'd3'],
        );
        final dialogues = [
          _createMockDialogue('d1'),
          _createMockDialogue('d2'),
          _createMockDialogue('d3'),
        ];

        // When
        final result = service.calculateEraProgress('joseon', progress, dialogues);

        // Then
        expect(result, equals(1.0));
      });

      test('일부 대화 완료 시 비율 반환', () {
        // Given: 4개 중 2개 완료 = 50%
        final progress = createMockUserProgress(
          completedDialogueIds: ['d1', 'd2'],
        );
        final dialogues = [
          _createMockDialogue('d1'),
          _createMockDialogue('d2'),
          _createMockDialogue('d3'),
          _createMockDialogue('d4'),
        ];

        // When
        final result = service.calculateEraProgress('joseon', progress, dialogues);

        // Then
        expect(result, equals(0.5));
      });

      test('완료된 대화가 없으면 0 반환', () {
        // Given: 완료된 대화 없음
        final progress = createMockUserProgress(
          completedDialogueIds: [],
        );
        final dialogues = [
          _createMockDialogue('d1'),
          _createMockDialogue('d2'),
        ];

        // When
        final result = service.calculateEraProgress('joseon', progress, dialogues);

        // Then
        expect(result, equals(0.0));
      });

      test('결과값이 0.0 ~ 1.0 범위로 클램핑됨', () {
        // Given: 정상적인 케이스
        final progress = createMockUserProgress(
          completedDialogueIds: ['d1'],
        );
        final dialogues = [_createMockDialogue('d1')];

        // When
        final result = service.calculateEraProgress('joseon', progress, dialogues);

        // Then
        expect(result, greaterThanOrEqualTo(0.0));
        expect(result, lessThanOrEqualTo(1.0));
      });
    });

    // =========================================================
    // calculateRegionProgress 테스트
    // =========================================================
    group('calculateRegionProgress', () {
      test('시대가 없으면 0 반환', () {
        // Given
        final progress = createMockUserProgress();
        final eras = <Era>[];

        // When
        final result = service.calculateRegionProgress('asia', progress, eras);

        // Then
        expect(result, equals(0.0));
      });

      test('진행한 시대가 없으면 0 반환', () {
        // Given: 진행률 모두 0
        final progress = createMockUserProgress(
          eraProgress: {'joseon': 0.0, 'goryeo': 0.0},
        );
        final eras = [
          _createMockEra(id: 'joseon', nameKorean: '조선'),
          _createMockEra(id: 'goryeo', nameKorean: '고려'),
        ];

        // When
        final result = service.calculateRegionProgress('asia', progress, eras);

        // Then
        expect(result, equals(0.0));
      });

      test('진행한 시대들의 평균 진행률 반환', () {
        // Given: joseon 80%, goryeo 40% → 평균 60%
        final progress = createMockUserProgress().copyWith(
          eraProgress: {'joseon': 0.8, 'goryeo': 0.4},
        );
        final eras = [
          _createMockEra(id: 'joseon', nameKorean: '조선'),
          _createMockEra(id: 'goryeo', nameKorean: '고려'),
        ];

        // When
        final result = service.calculateRegionProgress('asia', progress, eras);

        // Then: (0.8 + 0.4) / 2 = 0.6
        expect(result, closeTo(0.6, 0.001));
      });

      test('0보다 큰 진행률만 평균에 포함', () {
        // Given: joseon 100%, goryeo 0% → joseon만 포함
        final progress = createMockUserProgress().copyWith(
          eraProgress: {'joseon': 1.0, 'goryeo': 0.0},
        );
        final eras = [
          _createMockEra(id: 'joseon', nameKorean: '조선'),
          _createMockEra(id: 'goryeo', nameKorean: '고려'),
        ];

        // When
        final result = service.calculateRegionProgress('asia', progress, eras);

        // Then: joseon만 포함되어 1.0
        expect(result, equals(1.0));
      });
    });

    // =========================================================
    // rankUnlocks 상수 테스트
    // =========================================================
    group('rankUnlocks', () {
      test('apprentice 등급에 europe과 hint가 포함됨', () {
        final unlocks = ProgressionService.rankUnlocks[ExplorerRank.apprentice];
        
        expect(unlocks, contains('region_europe'));
        expect(unlocks, contains('feature_hint'));
      });

      test('intermediate 등급에 africa와 quiz가 포함됨', () {
        final unlocks = ProgressionService.rankUnlocks[ExplorerRank.intermediate];
        
        expect(unlocks, contains('region_africa'));
        expect(unlocks, contains('feature_quiz'));
      });

      test('advanced 등급에 americas와 timeline이 포함됨', () {
        final unlocks = ProgressionService.rankUnlocks[ExplorerRank.advanced];
        
        expect(unlocks, contains('region_americas'));
        expect(unlocks, contains('feature_timeline'));
      });

      test('expert 등급에 middle_east와 whatif가 포함됨', () {
        final unlocks = ProgressionService.rankUnlocks[ExplorerRank.expert];
        
        expect(unlocks, contains('region_middle_east'));
        expect(unlocks, contains('feature_whatif'));
      });

      test('master 등급에 hidden era와 master title이 포함됨', () {
        final unlocks = ProgressionService.rankUnlocks[ExplorerRank.master];
        
        expect(unlocks, contains('era_hidden'));
        expect(unlocks, contains('title_master'));
      });
    });
  });
}

// =============================================================================
// 테스트용 Mock 팩토리 함수
// =============================================================================

/// 테스트용 Era 생성
Era _createMockEra({
  required String id,
  required String nameKorean,
  String? previousEraId,
  double requiredProgress = 0.3,
  bool isPremium = false,
}) {
  return Era(
    id: id,
    countryId: 'korea',
    name: id,
    nameKorean: nameKorean,
    period: '1392-1897',
    startYear: 1392,
    endYear: 1897,
    description: 'Test era description',
    thumbnailAsset: 'assets/images/eras/test_thumb.jpg',
    backgroundAsset: 'assets/images/eras/test_bg.jpg',
    bgmAsset: 'assets/audio/bgm/test.mp3',
    themeId: EraThemeIds.defaultTheme,
    chapterIds: const [],
    characterIds: const [],
    locationIds: const [],
    unlockCondition: UnlockCondition(
      previousEraId: previousEraId,
      requiredProgress: requiredProgress,
      isPremium: isPremium,
    ),
  );
}

/// 테스트용 Dialogue 생성
Dialogue _createMockDialogue(String id) {
  return Dialogue(
    id: id,
    characterId: 'test_character',
    title: 'Test Dialogue',
    titleKorean: '테스트 대화',
    description: 'Test description',
    nodes: const [],
  );
}
