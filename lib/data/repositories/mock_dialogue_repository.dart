import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/repositories/dialogue_repository.dart';

class MockDialogueRepository implements DialogueRepository {
  List<Dialogue> _dialogues = [];
  // Simple in-memory storage for progress (reset on restart)
  final Map<String, DialogueProgress> _progressMap = {};
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/dialogues.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _dialogues = jsonList.map((e) => Dialogue.fromJson(e)).toList();
      _isLoaded = true;
    } catch (e) {
      // Fallback/Empty or Log error
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
    // In a real DB, we'd join Character tables. Here we return all for now or filter if we had eraId on dialogue.
    // Ideally, we should fetch characters of the era, then fetch dialogues for those characters.
    // But for MVP simplicity and given the interface, returning all or filtering by logic elsewhere.
    // Let's rely on getDialoguesByCharacter usually.
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
