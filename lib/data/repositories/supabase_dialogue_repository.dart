import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/core/constants/app_durations.dart';
import 'package:time_walker/data/datasources/remote/supabase_content_loader.dart';
import 'package:time_walker/data/repositories/supabase_mapping_utils.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/repositories/dialogue_repository.dart';

class SupabaseDialogueRepository implements DialogueRepository {
  SupabaseDialogueRepository(this._client, this._loader);

  final SupabaseClient _client;
  final SupabaseContentLoader _loader;

  List<Dialogue> _dialogues = [];
  final Map<String, DialogueProgress> _progressMap = {};
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final rows = await _loader.loadList(
        dataset: 'dialogues',
        fetchRemote: () async {
          final response = await _client.from('dialogues').select();
          return List<Map<String, dynamic>>.from(response as List);
        },
        transform: _mapRow,
      );
      _dialogues = _parseDialogues(rows);
    } on PostgrestException catch (e) {
      debugPrint('[SupabaseDialogueRepository] Supabase error: ${e.message}');
      await _loadFallback();
    } on FormatException catch (e) {
      debugPrint('[SupabaseDialogueRepository] JSON parse error: $e');
      await _loadFallback();
    } catch (e) {
      debugPrint('[SupabaseDialogueRepository] Unexpected error: $e');
      await _loadFallback();
    }
    _isLoaded = true;
  }

  List<Dialogue> _parseDialogues(List<Map<String, dynamic>> rows) {
    final result = <Dialogue>[];
    for (final json in rows) {
      try {
        result.add(Dialogue.fromJson(json));
      } catch (e) {
        debugPrint('[SupabaseDialogueRepository] Skip invalid dialogue: $e');
      }
    }
    return result;
  }

  Future<void> _loadFallback() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/dialogues.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _dialogues = _parseDialogues(
        jsonList.map((e) => e as Map<String, dynamic>).toList(),
      );
      debugPrint('[SupabaseDialogueRepository] Loaded ${_dialogues.length} from fallback');
    } catch (e) {
      debugPrint('[SupabaseDialogueRepository] Fallback load failed: $e');
      _dialogues = [];
    }
  }

  @override
  Future<List<Dialogue>> getAllDialogues() async {
    await _ensureLoaded();
    return _dialogues;
  }

  @override
  Future<List<Dialogue>> getDialoguesByEra(String eraId) async {
    await _ensureLoaded();
    return _dialogues;
  }

  @override
  Future<List<Dialogue>> getDialoguesByCharacter(String characterId) async {
    await _ensureLoaded();
    return _dialogues.where((d) => d.characterId == characterId).toList();
  }

  @override
  Future<Dialogue?> getDialogueById(String id) async {
    await _ensureLoaded();
    try {
      return _dialogues.firstWhere((d) => d.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<List<Dialogue>> getDialoguesByIds(List<String> ids) async {
    await _ensureLoaded();
    if (ids.isEmpty) return [];
    final idSet = ids.toSet();
    return _dialogues.where((d) => idSet.contains(d.id)).toList();
  }

  @override
  Future<void> saveDialogueProgress(DialogueProgress progress) async {
    await Future.delayed(AppDurations.mockDelayShort);
    _progressMap[progress.dialogueId] = progress;
  }

  @override
  Future<DialogueProgress?> getDialogueProgress(String dialogueId) async {
    await Future.delayed(AppDurations.mockDelayShort);
    return _progressMap[dialogueId];
  }
}

Map<String, dynamic> _mapRow(Map<String, dynamic> row) {
  return {
    'id': row['id'],
    'characterId': row['character_id'],
    'title': row['title'],
    'titleKorean': row['title_korean'],
    'description': row['description'] ?? '',
    'estimatedMinutes': intOrNull(row['estimated_minutes']) ?? 5,
    'nodes': dynamicList(row['nodes']),
    'rewards': dynamicList(row['rewards']),
    'isCompleted': row['is_completed'] ?? false,
  };
}
