import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/data/seeds/user_progress_seed.dart';
import 'package:time_walker/domain/core/use_case.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';

/// 사용자 진행 상태 조회 UseCase
class GetUserProgressUseCase implements UseCase<String, Result<UserProgress>> {
  final UserProgressRepository _repository;

  GetUserProgressUseCase(this._repository);

  @override
  Future<Result<UserProgress>> call(String userId) async {
    try {
      final progress = await _repository.getUserProgress(userId);
      if (progress == null) {
        // 새 사용자라면 기본 진행 상태 생성
        final newProgress = UserProgressSeed.initial(userId);
        await _repository.saveUserProgress(newProgress);
        return Success(newProgress);
      }
      return Success(progress);
    } catch (e) {
      return Failure(mapExceptionToFailure(e));
    }
  }
}

/// 사용자 진행 상태 업데이트 UseCase의 입력 파라미터
class UpdateProgressParams {
  final UserProgress currentProgress;
  final UserProgress Function(UserProgress) updateFn;

  const UpdateProgressParams({
    required this.currentProgress,
    required this.updateFn,
  });
}

/// 사용자 진행 상태 업데이트 및 해금 확인 UseCase
class UpdateUserProgressUseCase 
    implements UseCase<UpdateProgressParams, Result<UpdateProgressResult>> {
  final UserProgressRepository _repository;
  final ProgressionService _progressionService;

  UpdateUserProgressUseCase(this._repository, this._progressionService);

  @override
  Future<Result<UpdateProgressResult>> call(UpdateProgressParams params) async {
    try {
      // 1. 업데이트 함수 적용
      var updated = params.updateFn(params.currentProgress);

      // 2. 해금 이벤트 확인
      final unlocks = _progressionService.checkUnlocks(updated);

      // 3. 해금된 항목 적용
      if (unlocks.isNotEmpty) {
        final newEraIds = List<String>.from(updated.unlockedEraIds);
        final newCountryIds = List<String>.from(updated.unlockedCountryIds);
        final newRegionIds = List<String>.from(updated.unlockedRegionIds);

        for (final event in unlocks) {
          if (event.type == UnlockType.era && !newEraIds.contains(event.id)) {
            newEraIds.add(event.id);
          } else if (event.type == UnlockType.country &&
              !newCountryIds.contains(event.id)) {
            newCountryIds.add(event.id);
          } else if (event.type == UnlockType.region &&
              !newRegionIds.contains(event.id)) {
            newRegionIds.add(event.id);
          }
        }

        updated = updated.copyWith(
          unlockedEraIds: newEraIds,
          unlockedCountryIds: newCountryIds,
          unlockedRegionIds: newRegionIds,
        );

        // Rank 업데이트
        for (final event in unlocks) {
          if (event.type == UnlockType.rank) {
            try {
              final newRank = ExplorerRank.values.firstWhere(
                (e) => e.name == event.id,
              );
              updated = updated.copyWith(rank: newRank);
            } catch (_) {}
          }
        }
      }

      // 4. 저장
      await _repository.saveUserProgress(updated);

      return Success(UpdateProgressResult(
        progress: updated,
        unlocks: unlocks,
      ));
    } catch (e) {
      return Failure(mapExceptionToFailure(e));
    }
  }
}

/// 진행 상태 업데이트 결과
class UpdateProgressResult {
  final UserProgress progress;
  final List<UnlockEvent> unlocks;

  const UpdateProgressResult({
    required this.progress,
    required this.unlocks,
  });
}

/// 지식 포인트 추가 UseCase
class AddKnowledgePointsUseCase 
    implements UseCase<AddKnowledgeParams, Result<UpdateProgressResult>> {
  final UpdateUserProgressUseCase _updateUseCase;

  AddKnowledgePointsUseCase(this._updateUseCase);

  @override
  Future<Result<UpdateProgressResult>> call(AddKnowledgeParams params) async {
    return _updateUseCase.call(UpdateProgressParams(
      currentProgress: params.currentProgress,
      updateFn: (progress) => progress.copyWith(
        totalKnowledge: progress.totalKnowledge + params.points,
      ),
    ));
  }
}

/// 지식 포인트 추가 파라미터
class AddKnowledgeParams {
  final UserProgress currentProgress;
  final int points;

  const AddKnowledgeParams({
    required this.currentProgress,
    required this.points,
  });
}
