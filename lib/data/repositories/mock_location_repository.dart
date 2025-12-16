import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/repositories/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  final List<Location> _locations = [...LocationData.all];

  @override
  Future<List<Location>> getAllLocations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _locations;
  }

  @override
  Future<List<Location>> getLocationsByEra(String eraId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _locations.where((l) => l.eraId == eraId).toList();
  }

  @override
  Future<Location?> getLocationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _locations.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
