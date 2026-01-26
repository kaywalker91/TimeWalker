import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/location_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

@GenerateNiceMocks([
  MockSpec<RegionRepository>(),
  MockSpec<EraRepository>(),
  MockSpec<CountryRepository>(),
  MockSpec<LocationRepository>(),
])
import 'exploration_providers_test.mocks.dart';

void main() {
  late MockRegionRepository mockRegionRepo;
  late MockEraRepository mockEraRepo;
  late MockCountryRepository mockCountryRepo;
  late MockLocationRepository mockLocationRepo;

  setUp(() {
    mockRegionRepo = MockRegionRepository();
    mockEraRepo = MockEraRepository();
    mockCountryRepo = MockCountryRepository();
    mockLocationRepo = MockLocationRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        regionRepositoryProvider.overrideWithValue(mockRegionRepo),
        eraRepositoryProvider.overrideWithValue(mockEraRepo),
        countryRepositoryProvider.overrideWithValue(mockCountryRepo),
        locationRepositoryProvider.overrideWithValue(mockLocationRepo),
      ],
    );
  }

  group('Region Providers', () {
    test('regionListProvider가 모든 지역 목록을 반환한다', () async {
      final container = createContainer();
      final mockRegions = [
        const Region(
          id: 'asia',
          name: 'Asia',
          nameKorean: '아시아',
          description: '',
          iconAsset: '',
          thumbnailAsset: '',
          countryIds: [],
          center: MapCoordinates(x: 0, y: 0),
        ),
      ];
      when(mockRegionRepo.getAllRegions()).thenAnswer((_) async => mockRegions);

      final result = await container.read(regionListProvider.future);
      expect(result, equals(mockRegions));
      verify(mockRegionRepo.getAllRegions()).called(1);
    });

    test('regionByIdProvider가 ID로 지역을 반환한다', () async {
      final container = createContainer();
      const mockRegion = Region(
        id: 'asia',
        name: 'Asia',
        nameKorean: '아시아',
        description: '',
        iconAsset: '',
        thumbnailAsset: '',
        countryIds: [],
        center: MapCoordinates(x: 0, y: 0),
      );
      when(mockRegionRepo.getRegionById('asia')).thenAnswer((_) async => mockRegion);

      final result = await container.read(regionByIdProvider('asia').future);
      expect(result, equals(mockRegion));
      verify(mockRegionRepo.getRegionById('asia')).called(1);
    });
  });

  group('Era Providers', () {
    test('eraListByCountryProvider가 국가별 시대 목록을 반환한다', () async {
      final container = createContainer();
      final mockEras = <Era>[];
      when(mockEraRepo.getErasByCountry('korea')).thenAnswer((_) async => mockEras);

      final result = await container.read(eraListByCountryProvider('korea').future);
      expect(result, equals(mockEras));
    });
  });

  group('Country Providers', () {
    test('countryListByRegionProvider가 지역별 국가 목록을 반환한다', () async {
      final container = createContainer();
      final mockCountries = <Country>[];
      when(mockCountryRepo.getCountriesByRegion('asia')).thenAnswer((_) async => mockCountries);

      final result = await container.read(countryListByRegionProvider('asia').future);
      expect(result, equals(mockCountries));
    });
  });

  group('Location Providers', () {
    test('locationListByEraProvider가 시대별 장소 목록을 반환한다', () async {
      final container = createContainer();
      final mockLocations = <Location>[];
      when(mockLocationRepo.getLocationsByEra('joseon')).thenAnswer((_) async => mockLocations);

      final result = await container.read(locationListByEraProvider('joseon').future);
      expect(result, equals(mockLocations));
    });
  });
}
