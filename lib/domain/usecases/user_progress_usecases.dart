import 'package:time_walker/domain/core/use_case.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/domain/services/user_progress_factory.dart';

/// 사용자 진행 상태 조회 UseCase
class GetUserProgressUseCase implements UseCase<String, Result<UserProgress>> {
  final UserProgressRepository _repository;
  final UserProgressFactory _factory;

  GetUserProgressUseCase(this._repository, this._factory);

  @override
  Future<Result<UserProgress>> call(String userId) async {
    try {
      final progress = await _repository.getUserProgress(userId);
      if (progress == null) {
        // 새 사용자라면 기본 진행 상태 생성
        final newProgress = _factory.initial(userId);
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
  final EraRepository _eraRepository;
  final CountryRepository _countryRepository;
  final RegionRepository _regionRepository;

  UpdateUserProgressUseCase(
    this._repository,
    this._progressionService,
    this._eraRepository,
    this._countryRepository,
    this._regionRepository,
  );

  @override
  Future<Result<UpdateProgressResult>> call(UpdateProgressParams params) async {
    try {
      // 1. 업데이트 함수 적용
      var updated = params.updateFn(params.currentProgress);

      // 2. 해금 이벤트 확인
      final unlockContent = await _loadUnlockContent();
      final unlocks = _progressionService.checkUnlocks(
        updated,
        content: unlockContent,
      );

      // 3. 해금된 항목 적용 (ProgressionService에 위임)
      updated = _progressionService.applyUnlocks(updated, unlocks);

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

  Future<UnlockContent> _loadUnlockContent() async {
    final eras = await _eraRepository.getAllEras();
    final countries = await _countryRepository.getAllCountries();
    final regions = await _regionRepository.getAllRegions();
    final regionById = {
      for (final region in regions) region.id: region,
    };

    return UnlockContent(
      eras: eras,
      countries: countries,
      regionsById: regionById,
    );
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
