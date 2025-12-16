import '../entities/country.dart';

/// 국가/문명 데이터 저장소 인터페이스
abstract class CountryRepository {
  /// 모든 국가 목록 가져오기
  Future<List<Country>> getAllCountries();

  /// 특정 지역의 국가 목록 가져오기
  Future<List<Country>> getCountriesByRegion(String regionId);

  /// ID로 국가 조회
  Future<Country?> getCountryById(String id);

  /// 국가 해금 상태 업데이트
  Future<void> unlockCountry(String id);
}
