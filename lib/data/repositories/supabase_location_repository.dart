import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/datasources/remote/supabase_content_loader.dart';
import 'package:time_walker/data/repositories/supabase_mapping_utils.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/repositories/location_repository.dart';

class SupabaseLocationRepository implements LocationRepository {
  SupabaseLocationRepository(this._client, this._loader);

  final SupabaseClient _client;
  final SupabaseContentLoader _loader;

  List<Location> _locations = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final rows = await _loader.loadList(
        dataset: 'locations',
        fetchRemote: () async {
          final response = await _client.from('locations').select();
          return List<Map<String, dynamic>>.from(response as List);
        },
        transform: _mapRow,
      );
      _locations = rows.map((e) => Location.fromJson(e)).toList();
    } catch (_) {
      final jsonString = await rootBundle.loadString('assets/data/locations.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _locations = jsonList.map((e) => Location.fromJson(e)).toList();
    }
    _isLoaded = true;
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

Map<String, dynamic> _mapRow(Map<String, dynamic> row) {
  return {
    'id': row['id'],
    'eraId': row['era_id'],
    'name': row['name'],
    'nameKorean': row['name_korean'],
    'description': row['description'],
    'thumbnailAsset': row['thumbnail_asset'],
    'backgroundAsset': row['background_asset'],
    'kingdom': row['kingdom'],
    'latitude': doubleOrNull(row['latitude']),
    'longitude': doubleOrNull(row['longitude']),
    'displayYear': stringOrNull(row['display_year']),
    'timelineOrder': intOrNull(row['timeline_order']),
    'position': _position(row['position']),
    'characterIds': stringList(row['character_ids']),
    'eventIds': stringList(row['event_ids']),
    'status': row['status'],
    'isHistorical': row['is_historical'] ?? true,
  };
}

Map<String, dynamic> _position(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return {'x': 0.0, 'y': 0.0};
}
