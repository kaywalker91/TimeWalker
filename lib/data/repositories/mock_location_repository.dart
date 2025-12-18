import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/repositories/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  List<Location> _locations = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/locations.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _locations = jsonList.map((e) => Location.fromJson(e)).toList();
      _isLoaded = true;
    } catch (e) {
      // Fallback/Empty or Log error
      _locations = [];
    }
  }

  @override
  Future<List<Location>> getAllLocations() async {
    await _ensureLoaded();
    return _locations;
  }

  @override
  Future<List<Location>> getLocationsByEra(String eraId) async {
    await _ensureLoaded();
    return _locations.where((l) => l.eraId == eraId).toList();
  }

  @override
  Future<Location?> getLocationById(String id) async {
    await _ensureLoaded();
    try {
      return _locations.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
