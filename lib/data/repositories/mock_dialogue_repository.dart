import 'package:time_walker/data/datasources/dialogue_data.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/repositories/dialogue_repository.dart';

class MockDialogueRepository implements DialogueRepository {
  final List<Dialogue> _dialogues = [...DialogueData.all];
  // Simple in-memory storage for progress (reset on restart)
  final Map<String, DialogueProgress> _progressMap = {};

  @override
  Future<List<Dialogue>> getAllDialogues() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _dialogues;
  }

  @override
  Future<List<Dialogue>> getDialoguesByEra(String eraId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In a real DB, we'd join Character tables. Here we assume we filter somehow or return all for now.
    // Simplifying: Return all for MVP as we only have Sejong/Joseon data
    return _dialogues;
  }

  @override
  Future<List<Dialogue>> getDialoguesByCharacter(String characterId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _dialogues.where((d) => d.characterId == characterId).toList();
  }

  @override
  Future<Dialogue?> getDialogueById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
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
