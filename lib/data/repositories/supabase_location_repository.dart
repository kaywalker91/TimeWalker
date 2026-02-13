import 'dart:convert';

import 'package:flutter/foundation.dart';
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
      _locations = _parseLocations(rows);
    } on PostgrestException catch (e) {
      debugPrint('[SupabaseLocationRepository] Supabase error: ${e.message}');
      await _loadFallback();
    } on FormatException catch (e) {
      debugPrint('[SupabaseLocationRepository] JSON parse error: $e');
      await _loadFallback();
    } catch (e) {
      debugPrint('[SupabaseLocationRepository] Unexpected error: $e');
      await _loadFallback();
    }
    _isLoaded = true;
  }

  List<Location> _parseLocations(List<Map<String, dynamic>> rows) {
    final result = <Location>[];
    for (final json in rows) {
      try {
        result.add(Location.fromJson(json));
      } catch (e) {
        debugPrint('[SupabaseLocationRepository] Skip invalid location: $e');
      }
    }
    return result;
  }

  Future<void> _loadFallback() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/locations.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _locations = _parseLocations(
        jsonList.map((e) => e as Map<String, dynamic>).toList(),
      );
      debugPrint('[SupabaseLocationRepository] Loaded ${_locations.length} from fallback');
    } catch (e) {
      debugPrint('[SupabaseLocationRepository] Fallback load failed: $e');
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
    } on StateError {
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
    'description': stringOrNull(row['description']) ?? '',
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
