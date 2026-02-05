import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/datasources/remote/supabase_content_loader.dart';
import 'package:time_walker/data/repositories/supabase_mapping_utils.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/repositories/character_repository.dart';

class SupabaseCharacterRepository implements CharacterRepository {
  SupabaseCharacterRepository(this._client, this._loader);

  final SupabaseClient _client;
  final SupabaseContentLoader _loader;

  List<Character> _characters = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final rows = await _loader.loadList(
        dataset: 'characters',
        fetchRemote: () async {
          final response = await _client.from('characters').select();
          return List<Map<String, dynamic>>.from(response as List);
        },
        transform: _mapRow,
      );
      _characters = _parseCharacters(rows);
    } on PostgrestException catch (e) {
      debugPrint('[SupabaseCharacterRepository] Supabase error: ${e.message}');
      await _loadFallback();
    } on FormatException catch (e) {
      debugPrint('[SupabaseCharacterRepository] JSON parse error: $e');
      await _loadFallback();
    } catch (e) {
      debugPrint('[SupabaseCharacterRepository] Unexpected error: $e');
      await _loadFallback();
    }
    _isLoaded = true;
  }

  List<Character> _parseCharacters(List<Map<String, dynamic>> rows) {
    final result = <Character>[];
    for (final json in rows) {
      try {
        result.add(Character.fromJson(json));
      } catch (e) {
        debugPrint('[SupabaseCharacterRepository] Skip invalid character: $e');
      }
    }
    return result;
  }

  Future<void> _loadFallback() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/characters.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _characters = _parseCharacters(
        jsonList.map((e) => e as Map<String, dynamic>).toList(),
      );
      debugPrint('[SupabaseCharacterRepository] Loaded ${_characters.length} from fallback');
    } catch (e) {
      debugPrint('[SupabaseCharacterRepository] Fallback load failed: $e');
      _characters = [];
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    await _ensureLoaded();
    return _characters;
  }

  @override
  Future<List<Character>> getCharactersByEra(String eraId) async {
    await _ensureLoaded();
    return _characters.where((c) => c.eraId == eraId).toList();
  }

  @override
  Future<List<Character>> getCharactersByLocation(String locationId) async {
    await _ensureLoaded();
    return _characters
        .where((c) => c.relatedLocationIds.contains(locationId))
        .toList();
  }

  @override
  Future<Character?> getCharacterById(String id) async {
    debugPrint('[SupabaseCharacterRepository] getCharacterById id=$id');
    await _ensureLoaded();
    debugPrint('[SupabaseCharacterRepository] loaded ${_characters.length} characters');
    try {
      final char = _characters.firstWhere((c) => c.id == id);
      debugPrint('[SupabaseCharacterRepository] found: ${char.id} portrait=${char.portraitAsset}');
      return char;
    } on StateError {
      debugPrint('[SupabaseCharacterRepository] NOT FOUND: $id');
      debugPrint('[SupabaseCharacterRepository] available IDs: ${_characters.map((c) => c.id).toList()}');
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
    'title': row['title'],
    'birth': row['birth'],
    'death': row['death'],
    'biography': row['biography'],
    'fullBiography': row['full_biography'],
    'portraitAsset': row['portrait_asset'],
    'emotionAssets': stringList(row['emotion_assets']),
    'dialogueIds': stringList(row['dialogue_ids']),
    'relatedCharacterIds': stringList(row['related_character_ids']),
    'relatedLocationIds': stringList(row['related_location_ids']),
    'achievements': stringList(row['achievements']),
    'status': row['status'],
    'isHistorical': row['is_historical'] ?? true,
  };
}
