import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/domain/services/user_progress_factory.dart';
import 'package:time_walker/domain/usecases/user_progress_usecases.dart';

import '../../../helpers/test_utils.dart';
@GenerateNiceMocks([
  MockSpec<UserProgressRepository>(),
  MockSpec<UserProgressFactory>(),
  MockSpec<ProgressionService>(),
  MockSpec<EraRepository>(),
  MockSpec<CountryRepository>(),
  MockSpec<RegionRepository>(),
])
import 'user_progress_usecases_test.mocks.dart';

void main() {
  late MockUserProgressRepository mockRepository;
  late MockUserProgressFactory mockFactory;
  late MockProgressionService mockProgressionService;
  late MockEraRepository mockEraRepository;
  late MockCountryRepository mockCountryRepository;
  late MockRegionRepository mockRegionRepository;
  late GetUserProgressUseCase getUserProgressUseCase;
  late UpdateUserProgressUseCase updateUserProgressUseCase;
  late AddKnowledgePointsUseCase addKnowledgePointsUseCase;

  setUp(() {
    mockRepository = MockUserProgressRepository();
    mockFactory = MockUserProgressFactory();
    mockProgressionService = MockProgressionService();
    mockEraRepository = MockEraRepository();
    mockCountryRepository = MockCountryRepository();
    mockRegionRepository = MockRegionRepository();
    getUserProgressUseCase = GetUserProgressUseCase(mockRepository, mockFactory);
    updateUserProgressUseCase = UpdateUserProgressUseCase(
      mockRepository,
      mockProgressionService,
      mockEraRepository,
      mockCountryRepository,
      mockRegionRepository,
    );
    addKnowledgePointsUseCase = AddKnowledgePointsUseCase(updateUserProgressUseCase);

    when(mockEraRepository.getAllEras()).thenAnswer((_) async => []);
    when(mockCountryRepository.getAllCountries()).thenAnswer((_) async => []);
    when(mockRegionRepository.getAllRegions()).thenAnswer((_) async => []);
  });

  group('GetUserProgressUseCase', () {
    const userId = 'test_user';

    test('저장된 진행 상태가 있으면 반환한다', () async {
      // Given
      final existingProgress = createMockUserProgress(userId: userId);
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => existingProgress);

      // When
      final result = await getUserProgressUseCase(userId);

      // Then
      expect(result.isSuccess, isTrue);
      expect(result.data, equals(existingProgress));
      verify(mockRepository.getUserProgress(userId)).called(1);
      verifyNever(mockRepository.saveUserProgress(any));
    });

    test('저장된 진행 상태가 없으면 초기 상태를 생성하고 저장 후 반환한다', () async {
      // Given
      when(mockRepository.getUserProgress(userId))
          .thenAnswer((_) async => null);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});
      when(mockFactory.initial(userId))
          .thenReturn(createMockUserProgress(userId: userId, totalKnowledge: 0));

      // When
      final result = await getUserProgressUseCase(userId);

      // Then
      expect(result.isSuccess, isTrue);
      final progress = result.data;
      expect(progress, isNotNull);
      expect(progress!.userId, equals(userId));
      expect(progress.totalKnowledge, equals(0)); // 초기값
      
      verify(mockRepository.getUserProgress(userId)).called(1);
      verify(mockRepository.saveUserProgress(any)).called(1);
    });

    test('리포지토리 에러 시 Failure 반환', () async {
      // Given
      when(mockRepository.getUserProgress(any))
          .thenThrow(Exception('DB Error'));

      // When
      final result = await getUserProgressUseCase(userId);

      // Then
      expect(result.isFailure, isTrue);
    });
  });

  group('UpdateUserProgressUseCase', () {
    final currentProgress = createMockUserProgress(
      totalKnowledge: 100,
      unlockedEraIds: ['joseon'],
    );

    test('업데이트 함수가 적용되고 저장된다', () async {
      // Given
      when(mockProgressionService.checkUnlocks(any, content: anyNamed('content')))
          .thenReturn([]); // 해금 없음
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});

      // When
      final result = await updateUserProgressUseCase(UpdateProgressParams(
        currentProgress: currentProgress,
        updateFn: (p) => p.copyWith(totalKnowledge: 200),
      ));

      // Then
      expect(result.isSuccess, isTrue);
      final updated = result.data?.progress;
      expect(updated!.totalKnowledge, equals(200));
      verify(mockRepository.saveUserProgress(argThat(
        isA<UserProgress>().having((p) => p.totalKnowledge, 'knowledge', 200)
      ))).called(1);
    });

    test('해금 이벤트 발생 시 상태에 반영된다', () async {
      // Given
      const newEraId = 'three_kingdoms';
      final unlockEvent = UnlockEvent(
        type: UnlockType.era,
        id: newEraId,
        name: '삼국시대',
      );

      when(mockProgressionService.checkUnlocks(any, content: anyNamed('content')))
          .thenReturn([unlockEvent]);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});

      // When
      final result = await updateUserProgressUseCase(UpdateProgressParams(
        currentProgress: currentProgress,
        updateFn: (p) => p, // 변경 없음
      ));

      // Then
      expect(result.isSuccess, isTrue);
      final updateResult = result.data;
      expect(updateResult!.unlocks, contains(unlockEvent));
      expect(updateResult.progress.unlockedEraIds, contains(newEraId));
      
      verify(mockRepository.saveUserProgress(argThat(
        isA<UserProgress>().having((p) => p.unlockedEraIds, 'eras', contains(newEraId))
      ))).called(1);
    });

    test('랭크 해금 시 랭크가 업데이트된다', () async {
      // Given
      final unlockEvent = UnlockEvent(
        type: UnlockType.rank,
        id: ExplorerRank.apprentice.name,
        name: 'Apprentice',
      );

      when(mockProgressionService.checkUnlocks(any, content: anyNamed('content')))
          .thenReturn([unlockEvent]);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});

      // When
      final result = await updateUserProgressUseCase(UpdateProgressParams(
        currentProgress: currentProgress,
        updateFn: (p) => p,
      ));

      // Then
      expect(result.isSuccess, isTrue);
      final updated = result.data?.progress;
      expect(updated!.rank, equals(ExplorerRank.apprentice));
    });
  });

  group('AddKnowledgePointsUseCase', () {
    final currentProgress = createMockUserProgress(totalKnowledge: 100);

    test('지식 포인트가 추가된다', () async {
      // Given
      when(mockProgressionService.checkUnlocks(any, content: anyNamed('content')))
          .thenReturn([]);
      when(mockRepository.saveUserProgress(any))
          .thenAnswer((_) async => {});

      // When
      final result = await addKnowledgePointsUseCase(AddKnowledgeParams(
        currentProgress: currentProgress,
        points: 50,
      ));

      // Then
      expect(result.isSuccess, isTrue);
      final updated = result.data?.progress;
      expect(updated!.totalKnowledge, equals(150));
    });
  });
}
