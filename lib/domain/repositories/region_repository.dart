import '../entities/region.dart';

/// 지역 데이터 저장소 인터페이스
abstract class RegionRepository {
  /// 모든 지역 목록 가져오기
  Future<List<Region>> getAllRegions();

  /// ID로 지역 조회
  Future<Region?> getRegionById(String id);

  /// 지역 해금 상태 업데이트
  Future<void> unlockRegion(String id);
}
