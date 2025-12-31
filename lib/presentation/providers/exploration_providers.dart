import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Region Providers ==============

/// 모든 지역 목록 불러오기
final regionListProvider = FutureProvider<List<Region>>((ref) async {
  final repository = ref.watch(regionRepositoryProvider);
  return repository.getAllRegions();
});

/// 지역 ID로 지역 정보 불러오기
final regionByIdProvider = FutureProvider.family<Region?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(regionRepositoryProvider);
  return repository.getRegionById(id);
});

// ============== Era Providers ==============

/// 특정 국가의 시대 목록 불러오기
final eraListByCountryProvider = FutureProvider.family<List<Era>, String>((
  ref,
  countryId,
) async {
  final repository = ref.watch(eraRepositoryProvider);
  return repository.getErasByCountry(countryId);
});

/// 시대 ID로 시대 정보 불러오기
final eraByIdProvider = FutureProvider.family<Era?, String>((ref, id) async {
  final repository = ref.watch(eraRepositoryProvider);
  return repository.getEraById(id);
});

// ============== Country Providers ==============

/// 특정 지역의 국가 목록 불러오기
final countryListByRegionProvider =
    FutureProvider.family<List<Country>, String>((ref, regionId) async {
      final repository = ref.watch(countryRepositoryProvider);
      return repository.getCountriesByRegion(regionId);
    });

/// 국가 ID로 국가 정보 불러오기
final countryByIdProvider = FutureProvider.family<Country?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(countryRepositoryProvider);
  return repository.getCountryById(id);
});

// ============== Location Providers ==============

/// 시대별 장소 목록 불러오기
final locationListByEraProvider = FutureProvider.family<List<Location>, String>(
  (ref, eraId) async {
    final repository = ref.watch(locationRepositoryProvider);
    return repository.getLocationsByEra(eraId);
  },
);

/// 장소 ID로 장소 정보 불러오기
final locationByIdProvider = FutureProvider.family<Location?, String>(
  (ref, locationId) async {
    final repository = ref.watch(locationRepositoryProvider);
    return repository.getLocationById(locationId);
  },
);

