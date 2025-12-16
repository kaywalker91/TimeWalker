import 'package:time_walker/domain/entities/location.dart';

abstract class LocationRepository {
  Future<List<Location>> getAllLocations();
  Future<List<Location>> getLocationsByEra(String eraId);
  Future<Location?> getLocationById(String id);
}
