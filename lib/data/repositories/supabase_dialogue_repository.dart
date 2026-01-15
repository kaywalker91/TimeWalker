import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      _dialogues = rows.map((e) => Dialogue.fromJson(e)).toList();
    } catch (_) {
      final jsonString = await rootBundle.loadString('assets/data/dialogues.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _dialogues = jsonList.map((e) => Dialogue.fromJson(e)).toList();
    }
    _isLoaded = true;
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
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveDialogueProgress(DialogueProgress progress) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _progressMap[progress.dialogueId] = progress;
  }

  @override
  Future<DialogueProgress?> getDialogueProgress(String dialogueId) async {
    await Future.delayed(const Duration(milliseconds: 50));
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
