import '../entities/era.dart';

/// 시대 데이터 저장소 인터페이스
abstract class EraRepository {
  /// 모든 시대 목록 가져오기
  Future<List<Era>> getAllEras();

  /// 특정 국가의 시대 목록 가져오기
  Future<List<Era>> getErasByCountry(String countryId);

  /// ID로 시대 조회
  Future<Era?> getEraById(String id);

  /// 시대 해금 상태 업데이트
  Future<void> unlockEra(String id);
}
