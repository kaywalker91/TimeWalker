import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/domain/entities/localized_string.dart';

/// YAML 형식의 대화 스크립트를 파싱하는 클래스
/// PRD 부록 B의 YAML 형식을 지원합니다.
class DialogueYamlParser {
  /// YAML 문자열을 Dialogue 객체로 변환
  Dialogue parseYaml(String yamlContent) {
    try {
      final doc = loadYaml(yamlContent);
      final dialogueData = doc['dialogue'] as Map;
      
      return Dialogue(
        id: dialogueData['id'] as String,
        characterId: dialogueData['character'] as String,
        title: dialogueData['title'] as String? ?? '',
        titleKorean: dialogueData['titleKorean'] as String? ?? 
                     dialogueData['title'] as String? ?? '',
        description: dialogueData['description'] as String? ?? '',
        nodes: _parseNodes(dialogueData['nodes'] as List),
        rewards: _parseRewards(dialogueData['rewards'] as List?),
        estimatedMinutes: dialogueData['estimatedMinutes'] as int? ?? 5,
      );
    } catch (e) {
      throw FormatException('Failed to parse YAML dialogue: $e');
    }
  }
  
  /// YAML 파일 경로에서 Dialogue 로드
  Future<Dialogue> loadFromAsset(String assetPath) async {
    try {
      final yamlString = await rootBundle.loadString(assetPath);
      return parseYaml(yamlString);
    } catch (e) {
      throw FormatException('Failed to load YAML from asset $assetPath: $e');
    }
  }
  

  /// 노드 리스트 파싱
  List<DialogueNode> _parseNodes(List nodes) {
    return nodes.map((node) {
      final nodeMap = node as Map;
      
      // Parse text
      final textNode = nodeMap['text'];
      String text = '';
      LocalizedString? localizedText;
      if (textNode is Map) {
         localizedText = LocalizedString.fromJson(Map<String, dynamic>.from(textNode));
         text = localizedText.ko;
      } else {
         text = textNode as String;
         localizedText = LocalizedString.same(text);
      }
      
      return DialogueNode(
        id: nodeMap['id'] as String,
        speakerId: nodeMap['speaker'] as String,
        emotion: nodeMap['emotion'] as String? ?? 'neutral',
        text: text,
        localizedText: localizedText,
        choices: _parseChoices(nodeMap['choices'] as List?),
        nextNodeId: nodeMap['next'] as String? ?? nodeMap['nextNodeId'] as String?,
        reward: nodeMap['reward'] != null 
            ? _parseReward(nodeMap['reward'] as Map) 
            : null,
        isEnd: nodeMap['end'] as bool? ?? nodeMap['isEnd'] as bool? ?? false,
      );
    }).toList();
  }
  
  /// 선택지 리스트 파싱
  List<DialogueChoice> _parseChoices(List? choices) {
    if (choices == null || choices.isEmpty) return [];
    
    return choices.asMap().entries.map((entry) {
      final choice = entry.value as Map;
      
      // Parse text
      final textNode = choice['text'];
      String text = '';
      LocalizedString? localizedText;
      if (textNode is Map) {
         localizedText = LocalizedString.fromJson(Map<String, dynamic>.from(textNode));
         text = localizedText.ko;
      } else {
         text = textNode as String;
         localizedText = LocalizedString.same(text);
      }
      
      // Parse preview
      final previewNode = choice['preview'];
      String? preview;
      LocalizedString? localizedPreview;
      if (previewNode is Map) {
         localizedPreview = LocalizedString.fromJson(Map<String, dynamic>.from(previewNode));
         preview = localizedPreview.ko;
      } else if (previewNode is String) {
         preview = previewNode;
         localizedPreview = LocalizedString.same(preview);
      }
      
      return DialogueChoice(
        id: choice['id'] as String? ?? 'c${entry.key}',
        text: text,
        localizedText: localizedText,
        preview: preview,
        localizedPreview: localizedPreview,
        nextNodeId: choice['next'] as String? ?? choice['nextNodeId'] as String,
        reward: choice['reward'] != null
            ? _parseReward(choice['reward'] as Map)
            : null,
        condition: choice['condition'] != null
            ? _parseCondition(choice['condition'] as Map)
            : null,
      );
    }).toList();
  }
  
  /// 보상 파싱
  DialogueReward _parseReward(Map reward) {
    return DialogueReward(
      knowledgePoints: _parseIntValue(reward, ['knowledge', 'knowledgePoints']) ?? 0,
      unlockFactId: reward['unlock_fact'] as String? ?? 
                    reward['unlockFactId'] as String?,
      unlockCharacterId: reward['unlock_character'] as String? ?? 
                          reward['unlockCharacterId'] as String?,
      achievementId: reward['achievement'] as String? ?? 
                     reward['achievementId'] as String?,
    );
  }
  
  /// 조건 파싱
  ChoiceCondition _parseCondition(Map condition) {
    return ChoiceCondition(
      requiredFact: condition['required_fact'] as String? ?? 
                     condition['requiredFact'] as String?,
      requiredCharacter: condition['required_character'] as String? ?? 
                          condition['requiredCharacter'] as String?,
      requiredKnowledge: _parseIntValue(condition, ['required_knowledge', 'requiredKnowledge']),
    );
  }
  
  /// 보상 리스트 파싱 (dialogue 레벨의 rewards)
  List<DialogueReward> _parseRewards(List? rewards) {
    if (rewards == null || rewards.isEmpty) return [];
    
    return rewards.map((reward) {
      return _parseReward(reward as Map);
    }).toList();
  }
  
  /// 정수 값 파싱 헬퍼 (여러 키 시도)
  int? _parseIntValue(Map map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value != null) {
        if (value is int) return value;
        if (value is String) return int.tryParse(value);
      }
    }
    return null;
  }
}

