import 'package:time_walker/core/constants/exploration_config.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';

/// 국가 데이터 Mock 저장소
class MockCountryRepository implements CountryRepository {
  // 인메모리 캐시
  final List<Country> _countries = [...CountryData.all];

  @override
  Future<List<Country>> getAllCountries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _countries;
  }

  @override
  Future<List<Country>> getCountriesByRegion(String regionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _countries.where((c) => c.regionId == regionId).toList();
  }

  @override
  Future<Country?> getCountryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _countries.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> unlockCountry(String id) async {
    final index = _countries.indexWhere((c) => c.id == id);
    if (index != -1) {
      final country = _countries[index];
      _countries[index] = country.copyWith(status: ContentStatus.available);
    }
  }
}
