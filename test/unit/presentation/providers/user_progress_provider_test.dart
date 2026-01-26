import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/domain/services/user_progress_factory.dart';
import 'package:time_walker/presentation/providers/user_progress_provider.dart';

import '../../../helpers/test_utils.dart';
@GenerateNiceMocks([
  MockSpec<UserProgressRepository>(),
  MockSpec<ProgressionService>(),
  MockSpec<EraRepository>(),
  MockSpec<CountryRepository>(),
  MockSpec<RegionRepository>(),
  MockSpec<UserProgressFactory>(),
])
import 'user_progress_provider_test.mocks.dart';

void main() {
  late MockUserProgressRepository mockRepository;
  late MockProgressionService mockProgressionService;
  late MockEraRepository mockEraRepository;
  late MockCountryRepository mockCountryRepository;
  late MockRegionRepository mockRegionRepository;
  late MockUserProgressFactory mockFactory;
  late UserProgressNotifier notifier;

  setUp(() {
    mockRepository = MockUserProgressRepository();
    mockProgressionService = MockProgressionService();
    mockEraRepository = MockEraRepository();
    mockCountryRepository = MockCountryRepository();
    mockRegionRepository = MockRegionRepository();
    mockFactory = MockUserProgressFactory();

    when(mockEraRepository.getAllEras()).thenAnswer((_) async => []);
    when(mockCountryRepository.getAllCountries()).thenAnswer((_) async => []);
    when(mockRegionRepository.getAllRegions()).thenAnswer((_) async => []);
  });

  group('UserProgressNotifier', () {
    const userId = 'user_001';
    UserProgressNotifier createNotifier() {
      return UserProgressNotifier(
        mockRepository,
        mockProgressionService,
        mockEraRepository,
        mockCountryRepository,
        mockRegionRepository,
        mockFactory,
      );
    }

    test('초기화 시 저장된 진행 상태를 불러온다', () async {
      // Given
      final progress = createMockUserProgress(userId: userId);
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => progress);

      // Re-initialize to trigger load
      notifier = createNotifier();
      
      // Wait for async load
      await Future.delayed(Duration.zero);

      // Then
      expect(notifier.state.value, equals(progress));
    });

    test('저장된 상태가 없으면 초기 상태를 생성하고 저장한다', () async {
      // Given
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => null);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});
      when(mockFactory.initial(userId))
          .thenReturn(createMockUserProgress(userId: userId, totalKnowledge: 0));

      // Re-initialize
      notifier = createNotifier();
      
      // Wait for async load
      await Future.delayed(Duration.zero);

      // Then
      expect(notifier.state.value, isNotNull);
      expect(notifier.state.value!.totalKnowledge, equals(0));
      verify(mockRepository.saveUserProgress(any)).called(1);
    });

    test('updateProgress가 상태를 업데이트하고 저장한다', () async {
      // Given: Initial load complete
      final initialProgress = createMockUserProgress(userId: userId);
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => initialProgress);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});
      when(mockProgressionService.checkUnlocks(any, content: anyNamed('content')))
          .thenReturn([]);

      notifier = createNotifier();
      await Future.delayed(Duration.zero);

      // When
      await notifier.updateProgress(
        (p) => p.copyWith(totalKnowledge: 100),
      );

      // Then
      expect(notifier.state.value!.totalKnowledge, equals(100));
      verify(mockRepository.saveUserProgress(argThat(
        isA<UserProgress>().having((p) => p.totalKnowledge, 'knowledge', 100)
      ))).called(1);
    });

    test('updateProgress가 해금 이벤트를 처리하고 반영한다', () async {
      // Given
      final initialProgress = createMockUserProgress(userId: userId);
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => initialProgress);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});
      
      const newEraId = 'new_era';
      final unlockEvent = UnlockEvent(
        type: UnlockType.era,
        id: newEraId,
        name: 'New Era',
      );
      when(mockProgressionService.checkUnlocks(any, content: anyNamed('content')))
          .thenReturn([unlockEvent]);

      notifier = createNotifier();
      await Future.delayed(Duration.zero);

      // When
      final unlocks = await notifier.updateProgress((p) => p);

      // Then
      expect(unlocks, contains(unlockEvent));
      expect(notifier.state.value!.unlockedEraIds, contains(newEraId));
      verify(mockRepository.saveUserProgress(any)).called(1);
    });

    test('consumeItem이 아이템을 제거하고 저장한다', () async {
      // Given
      final progress = createMockUserProgress(userId: userId).copyWith(
        inventoryIds: ['item1', 'item2'],
      );
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => progress);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});

      notifier = createNotifier();
      await Future.delayed(Duration.zero);

      // When
      final result = await notifier.consumeItem('item1');

      // Then
      expect(result, isTrue);
      expect(notifier.state.value!.inventoryIds, isNot(contains('item1')));
      expect(notifier.state.value!.inventoryIds, contains('item2'));
      verify(mockRepository.saveUserProgress(any)).called(1);
    });

    test('consumeItem이 없는 아이템에 대해 false를 반환한다', () async {
      // Given
      final progress = createMockUserProgress(userId: userId); // Empty inventory
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => progress);

      notifier = createNotifier();
      await Future.delayed(Duration.zero);

      // When
      final result = await notifier.consumeItem('missing_item');

      // Then
      expect(result, isFalse);
      verifyNever(mockRepository.saveUserProgress(any));
    });

    test('unlockAllContent가 모든 콘텐츠를 해금한다 (Admin)', () async {
      // Given
      final progress = createMockUserProgress(userId: userId);
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => progress);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});
      when(mockFactory.debugAllUnlocked(userId)).thenReturn(
        createMockUserProgress(userId: userId, rank: ExplorerRank.master),
      );

      notifier = createNotifier();
      await Future.delayed(Duration.zero);

      // When
      await notifier.unlockAllContent();

      // Then
      final updated = notifier.state.value!;
      expect(updated.rank, equals(ExplorerRank.master));
      // UserProgressSeed.debugAllUnlocked implementation check (assumed full unlock)
      verify(mockRepository.saveUserProgress(any)).called(1);
    });
  });
}
