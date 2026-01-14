import 'dart:convert';

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
      _characters = rows.map((e) => Character.fromJson(e)).toList();
    } catch (_) {
      final jsonString = await rootBundle.loadString('assets/data/characters.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _characters = jsonList.map((e) => Character.fromJson(e)).toList();
    }
    _isLoaded = true;
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
    await _ensureLoaded();
    try {
      return _characters.firstWhere((c) => c.id == id);
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
