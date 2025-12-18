import 'package:time_walker/domain/core/use_case.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';

/// 국가별 시대 목록 조회 UseCase
/// 
/// Clean Architecture에서 비즈니스 로직을 캡슐화합니다.
/// Repository에서 데이터를 가져와 Result 타입으로 래핑합니다.
class GetErasByCountryUseCase implements UseCase<String, Result<List<Era>>> {
  final EraRepository _repository;

  GetErasByCountryUseCase(this._repository);

  @override
  Future<Result<List<Era>>> call(String countryId) async {
    try {
      final eras = await _repository.getErasByCountry(countryId);
      return Success(eras);
    } catch (e) {
      return Failure(mapExceptionToFailure(e));
    }
  }
}

/// 시대 상세 조회 UseCase
class GetEraByIdUseCase implements UseCase<String, Result<Era?>> {
  final EraRepository _repository;

  GetEraByIdUseCase(this._repository);

  @override
  Future<Result<Era?>> call(String eraId) async {
    try {
      final era = await _repository.getEraById(eraId);
      if (era == null) {
        return const Failure(NotFoundFailure(message: '시대 정보를 찾을 수 없습니다.'));
      }
      return Success(era);
    } catch (e) {
      return Failure(mapExceptionToFailure(e));
    }
  }
}
