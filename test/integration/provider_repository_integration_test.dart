import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

import '../fixtures/mock_data.dart';

void main() {
  group('Provider-Repository Integration', () {
    group('UserProgressProvider with MockRepository', () {
      late ProviderContainer container;
      late MockUserProgressRepository mockRepository;

      setUp(() {
        mockRepository = MockUserProgressRepository();
        container = ProviderContainer(
          overrides: [
            userProgressRepositoryProvider.overrideWithValue(mockRepository),
            progressionServiceProvider.overrideWithValue(ProgressionService()),
          ],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test('loads initial user progress on creation', () async {
        // Arrange
        const initialProgress = UserProgress(
          userId: 'user_001',
          totalKnowledge: 1000,
          rank: ExplorerRank.novice,
        );
        await mockRepository.saveUserProgress(initialProgress);

        // Act
        // Reading the provider triggers the constructor and _loadProgress
        final sub = container.listen(userProgressProvider, (_, _) {});
        
        // Wait for async initialization (simulated mock delay is 10ms)
        await Future.delayed(const Duration(milliseconds: 50));
        
        final state = container.read(userProgressProvider);

        // Assert
        expect(state.hasValue, isTrue);
        expect(state.value?.totalKnowledge, equals(1000));
        
        sub.close();
      });

      test('updateProgress saves changes to repository', () async {
        // Arrange
        const initialProgress = UserProgress(
          userId: 'user_001',
          totalKnowledge: 1000,
          coins: 500,
        );
        await mockRepository.saveUserProgress(initialProgress);

        // Wait for initial load
        final sub = container.listen(userProgressProvider, (_, _) {});
        await Future.delayed(const Duration(milliseconds: 50));

        // Act - update progress
        final notifier = container.read(userProgressProvider.notifier);
        await notifier.updateProgress((p) => p.copyWith(
          totalKnowledge: 2000,
          coins: 1000,
        ));

        // Test environment wait for async write
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        final savedProgress = await mockRepository.getUserProgress('user_001');
        expect(savedProgress?.totalKnowledge, equals(2000));
        expect(savedProgress?.coins, equals(1000));
        
        sub.close();
      });

      test('multiple sequential updates accumulate correctly', () async {
        // Arrange
        const initialProgress = UserProgress(
          userId: 'user_001',
          totalKnowledge: 0,
        );
        await mockRepository.saveUserProgress(initialProgress);

        final sub = container.listen(userProgressProvider, (_, _) {});
        await Future.delayed(const Duration(milliseconds: 50));

        final notifier = container.read(userProgressProvider.notifier);

        // Act - multiple updates
        // We await each update to ensure sequential processing
        await notifier.updateProgress((p) => p.copyWith(totalKnowledge: p.totalKnowledge + 100));
        await notifier.updateProgress((p) => p.copyWith(totalKnowledge: p.totalKnowledge + 200));
        await notifier.updateProgress((p) => p.copyWith(totalKnowledge: p.totalKnowledge + 300));

        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        final finalProgress = await mockRepository.getUserProgress('user_001');
        expect(finalProgress?.totalKnowledge, equals(600));
        
        sub.close();
      });

      test('consumeItem removes item from inventory', () async {
        // Arrange
        const initialProgress = UserProgress(
          userId: 'user_001',
          inventoryIds: ['item_1', 'item_2', 'item_1'],
        );
        await mockRepository.saveUserProgress(initialProgress);

        final sub = container.listen(userProgressProvider, (_, _) {});
        await Future.delayed(const Duration(milliseconds: 50));

        final notifier = container.read(userProgressProvider.notifier);

        // Act
        final result = await notifier.consumeItem('item_1');

        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(result, isTrue);
        final savedProgress = await mockRepository.getUserProgress('user_001');
        expect(savedProgress?.inventoryIds.length, equals(2));
        
        sub.close();
      });
    });

    group('EraRepository Integration', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer();
      });

      tearDown(() {
        container.dispose();
      });

      test('eraRepositoryProvider returns EraRepository', () {
        final repository = container.read(eraRepositoryProvider);
        expect(repository, isA<EraRepository>());
      });

      test('can fetch eras through provider', () async {
        final repository = container.read(eraRepositoryProvider);
        final eras = await repository.getAllEras();
        expect(eras, isNotEmpty);
      });
    });
  });

  group('MockData Fixtures', () {
    test('novice user has correct default values', () {
      expect(MockData.noviceUser.userId, equals('novice_user'));
      expect(MockData.noviceUser.rank, equals(ExplorerRank.novice));
    });
  });
}

/// Mock implementation of UserProgressRepository for testing
class MockUserProgressRepository implements UserProgressRepository {
  final Map<String, UserProgress> _storage = {};

  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    await Future.delayed(const Duration(milliseconds: 10)); // Simulate async
    return _storage[userId];
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    await Future.delayed(const Duration(milliseconds: 10)); // Simulate async
    _storage[progress.userId] = progress;
  }

  void clear() {
    _storage.clear();
  }
}
