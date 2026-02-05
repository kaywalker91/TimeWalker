import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Region Providers ==============

/// 모든 지역 목록 불러오기
/// Note: keepAlive 유지 - 작은 정적 데이터, 항상 필요 (네비게이션)
final regionListProvider = FutureProvider<List<Region>>((ref) async {
  ref.keepAlive();
  final repository = ref.watch(regionRepositoryProvider);
  return repository.getAllRegions();
});

/// 지역 ID로 지역 정보 불러오기
/// Note: keepAlive 유지 - 작은 정적 데이터
final regionByIdProvider = FutureProvider.family<Region?, String>((
  ref,
  id,
) async {
  ref.keepAlive();
  final repository = ref.watch(regionRepositoryProvider);
  return repository.getRegionById(id);
});

// ============== Era Providers ==============

/// 특정 국가의 시대 목록 불러오기
/// Note: keepAlive 유지 - 시대 데이터는 작고 자주 사용됨
final eraListByCountryProvider = FutureProvider.family<List<Era>, String>((
  ref,
  countryId,
) async {
  ref.keepAlive();
  final repository = ref.watch(eraRepositoryProvider);
  return repository.getErasByCountry(countryId);
});

/// 시대 ID로 시대 정보 불러오기
/// Note: keepAlive 유지 - 시대 데이터는 작고 자주 사용됨
final eraByIdProvider = FutureProvider.family<Era?, String>((ref, id) async {
  ref.keepAlive();
  final repository = ref.watch(eraRepositoryProvider);
  return repository.getEraById(id);
});

// ============== Country Providers ==============

/// 특정 지역의 국가 목록 불러오기
/// Note: keepAlive 유지 - 국가 데이터는 작고 자주 사용됨
final countryListByRegionProvider =
    FutureProvider.family<List<Country>, String>((ref, regionId) async {
      ref.keepAlive();
      final repository = ref.watch(countryRepositoryProvider);
      return repository.getCountriesByRegion(regionId);
    });

/// 국가 ID로 국가 정보 불러오기
/// Note: keepAlive 유지 - 국가 데이터는 작고 자주 사용됨
final countryByIdProvider = FutureProvider.family<Country?, String>((
  ref,
  id,
) async {
  ref.keepAlive();
  final repository = ref.watch(countryRepositoryProvider);
  return repository.getCountryById(id);
});

// ============== Location Providers ==============

/// 시대별 장소 목록 불러오기
/// Note: keepAlive 제거 - 화면별 데이터는 화면 이탈 시 해제
final locationListByEraProvider = FutureProvider.family<List<Location>, String>(
  (ref, eraId) async {
    final repository = ref.watch(locationRepositoryProvider);
    return repository.getLocationsByEra(eraId);
  },
);

/// 장소 ID로 장소 정보 불러오기
/// Note: keepAlive 제거 - 화면별 데이터는 화면 이탈 시 해제
final locationByIdProvider = FutureProvider.family<Location?, String>(
  (ref, locationId) async {
    final repository = ref.watch(locationRepositoryProvider);
    return repository.getLocationById(locationId);
  },
);

