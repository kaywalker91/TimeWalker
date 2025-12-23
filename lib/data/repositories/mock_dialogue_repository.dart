import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/repositories/dialogue_repository.dart';
import 'package:time_walker/data/datasources/local/dialogue_yaml_parser.dart';

class MockDialogueRepository implements DialogueRepository {
  List<Dialogue> _dialogues = [];
  // Simple in-memory storage for progress (reset on restart)
  final Map<String, DialogueProgress> _progressMap = {};
  bool _isLoaded = false;
  final DialogueYamlParser _yamlParser = DialogueYamlParser();

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    debugPrint('[MockDialogueRepository] loading dialogues');
    try {
      // Try to load YAML files first (priority), then fallback to JSON
      await _loadYamlDialogues();
      
      // If no YAML files found, load JSON
      if (_dialogues.isEmpty) {
        await _loadJsonDialogues();
      }
      
      _isLoaded = true;
      debugPrint('[MockDialogueRepository] loaded count=${_dialogues.length}');
    } catch (e) {
      // Fallback/Empty or Log error
      debugPrint('[MockDialogueRepository] load failed error=$e');
      _dialogues = [];
    }
  }
  
  /// YAML 파일 로드 (assets/content/dialogues/ 디렉토리에서)
  Future<void> _loadYamlDialogues() async {
    try {
      // TODO: 실제 YAML 파일이 추가되면 이 부분을 활성화
      // 현재는 JSON만 있으므로 주석 처리
      // final manifestContent = await rootBundle.loadString('AssetManifest.json');
      // final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
      // 
      // final yamlFiles = manifestMap.keys
      //     .where((key) => key.startsWith('assets/content/dialogues/') && key.endsWith('.yaml'))
      //     .toList();
      // 
      // for (final yamlFile in yamlFiles) {
      //   try {
      //     final dialogue = await _yamlParser.loadFromAsset(yamlFile);
      //     _dialogues.add(dialogue);
      //   } catch (e) {
      //     // Skip invalid YAML files
      //     continue;
      //   }
      // }
    } catch (e) {
      // YAML 로드 실패 시 무시 (JSON으로 fallback)
    }
  }
  
  /// JSON 파일 로드
  Future<void> _loadJsonDialogues() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/dialogues.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _dialogues = jsonList.map((e) => Dialogue.fromJson(e)).toList();
    } catch (e) {
      // Fallback/Empty or Log error
      debugPrint('[MockDialogueRepository] json load failed error=$e');
      _dialogues = [];
    }
  }
  
  /// YAML 문자열에서 Dialogue 로드 (테스트/개발용)
  Dialogue? parseYamlString(String yamlContent) {
    try {
      return _yamlParser.parseYaml(yamlContent);
    } catch (e) {
      return null;
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
