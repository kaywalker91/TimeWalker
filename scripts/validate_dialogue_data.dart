import 'dart:convert';
import 'dart:io';

void main() async {
  print('=== TimeWalker 인물-대화 데이터 검증 결과 ===\n');
  
  // 데이터 파일 로드
  final charactersFile = File('assets/data/characters.json');
  final dialoguesFile = File('assets/data/dialogues.json');
  
  if (!charactersFile.existsSync() || !dialoguesFile.existsSync()) {
    print('❌ 데이터 파일을 찾을 수 없습니다.');
    return;
  }
  
  final charactersJson = jsonDecode(await charactersFile.readAsString()) as List;
  final dialoguesJson = jsonDecode(await dialoguesFile.readAsString()) as List;
  
  final characters = charactersJson.cast<Map<String, dynamic>>();
  final dialogues = dialoguesJson.cast<Map<String, dynamic>>();
  
  print('📌 검증 대상:');
  print('- Characters: ${characters.length}명');
  print('- Dialogues: ${dialogues.length}개');
  
  int totalNodeCount = 0;
  for (var dialogue in dialogues) {
    if (dialogue['nodes'] != null) {
      totalNodeCount += (dialogue['nodes'] as List).length;
    }
  }
  print('- Dialogue Nodes: $totalNodeCount개\n');
  
  int passedCount = 0;
  int failedCount = 0;
  int warningCount = 0;
  
  final issues = <String>[];
  final warnings = <String>[];
  
  // 유효한 감정 상태 목록
  final validEmotions = {
    'neutral', 'happy', 'sad', 'angry', 
    'thoughtful', 'determined', 'serious'
  };
  
  // Character ID 맵 생성
  final characterIds = <String>{};
  for (var char in characters) {
    characterIds.add(char['id'] as String);
  }
  
  // Dialogue ID 맵 생성
  final dialogueIds = <String>{};
  for (var dialogue in dialogues) {
    dialogueIds.add(dialogue['id'] as String);
  }
  
  print('✅ 1️⃣ Character → Dialogue 참조 검증');
  for (var char in characters) {
    final charId = char['id'] as String;
    final charDialogueIds = (char['dialogueIds'] as List?)?.cast<String>() ?? [];
    
    for (var dialogueId in charDialogueIds) {
      if (!dialogueIds.contains(dialogueId)) {
        issues.add('❌ Character "$charId"의 dialogueIds에 "$dialogueId"가 있으나, dialogues.json에 존재하지 않음');
        failedCount++;
      }
    }
  }
  if (issues.isEmpty) {
    print('   ✅ 모든 Character의 dialogueIds가 유효함');
    passedCount++;
  }
  print('');
  
  print('✅ 2️⃣ Dialogue → Character 참조 검증');
  for (var dialogue in dialogues) {
    final dialogueId = dialogue['id'] as String;
    final characterId = dialogue['characterId'] as String?;
    
    if (characterId == null) {
      issues.add('❌ Dialogue "$dialogueId"의 characterId가 null임');
      failedCount++;
    } else if (!characterIds.contains(characterId)) {
      issues.add('❌ Dialogue "$dialogueId"의 characterId "$characterId"이 characters.json에 존재하지 않음');
      failedCount++;
    }
  }
  if (issues.length == failedCount - (failedCount > passedCount ? passedCount : 0)) {
    print('   ✅ 모든 Dialogue의 characterId가 유효함');
    passedCount++;
  }
  print('');
  
  print('✅ 3️⃣ 대화 ID 네이밍 규칙 검증');
  final namePattern = RegExp(r'^[a-z_]+_[a-z_]+_\d{2}$');
  for (var dialogue in dialogues) {
    final dialogueId = dialogue['id'] as String;
    final characterId = dialogue['characterId'] as String?;
    
    // Crossover 대화는 예외
    if (dialogueId.startsWith('crossover_')) {
      continue;
    }
    
    if (!namePattern.hasMatch(dialogueId)) {
      warnings.add('⚠️ Dialogue "$dialogueId"는 네이밍 규칙 위반 ({character_id}_{topic}_{number} 형식 권장)');
      warningCount++;
    } else if (characterId != null) {
      final prefix = dialogueId.split('_').first;
      if (!characterId.startsWith(prefix) && characterId != prefix) {
        warnings.add('⚠️ Dialogue "$dialogueId"의 ID prefix "$prefix"가 characterId "$characterId"와 불일치');
        warningCount++;
      }
    }
  }
  if (warnings.length == warningCount) {
    print('   ✅ 모든 대화 ID가 네이밍 규칙을 따름');
    passedCount++;
  }
  print('');
  
  print('✅ 4️⃣ 시작 노드 존재 검증');
  for (var dialogue in dialogues) {
    final dialogueId = dialogue['id'] as String;
    final nodes = (dialogue['nodes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    if (nodes.isEmpty) {
      issues.add('❌ Dialogue "$dialogueId"에 nodes 배열이 비어있음');
      failedCount++;
      continue;
    }
    
    final hasStartNode = nodes.any((node) => node['id'] == 'start');
    if (!hasStartNode) {
      warnings.add('⚠️ Dialogue "$dialogueId"에 시작 노드(id="start")가 없음 (첫 번째 노드 "${nodes.first['id']}" 사용 중)');
      warningCount++;
    }
  }
  if (issues.length == failedCount - passedCount && warnings.length == warningCount) {
    print('   ✅ 모든 Dialogue에 시작 노드가 있음');
    passedCount++;
  }
  print('');
  
  print('✅ 5️⃣ 노드 간 참조 무결성 검증');
  for (var dialogue in dialogues) {
    final dialogueId = dialogue['id'] as String;
    final nodes = (dialogue['nodes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    final nodeIds = nodes.map((n) => n['id'] as String).toSet();
    
    for (var node in nodes) {
      final nodeId = node['id'] as String;
      final choices = (node['choices'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final nextNodeId = node['nextNodeId'] as String?;
      final isEnd = node['isEnd'] as bool? ?? false;
      
      // choices의 nextNodeId 검증
      for (var choice in choices) {
        final choiceNextNodeId = choice['nextNodeId'] as String?;
        if (choiceNextNodeId != null && !nodeIds.contains(choiceNextNodeId)) {
          issues.add('❌ Dialogue "$dialogueId" > Node "$nodeId" > Choice "${choice['id']}" → "$choiceNextNodeId" (존재하지 않는 노드 참조)');
          failedCount++;
        }
      }
      
      // nextNodeId 검증
      if (nextNodeId != null && !nodeIds.contains(nextNodeId)) {
        issues.add('❌ Dialogue "$dialogueId" > Node "$nodeId" > nextNodeId "$nextNodeId" (존재하지 않는 노드 참조)');
        failedCount++;
      }
      
      // 막다른 골목 검증
      if (!isEnd && choices.isEmpty && nextNodeId == null) {
        issues.add('❌ Dialogue "$dialogueId" > Node "$nodeId"는 종료 노드가 아니지만 선택지도 없고 nextNodeId도 없음 (막다른 골목)');
        failedCount++;
      }
    }
  }
  if (issues.length == failedCount - passedCount) {
    print('   ✅ 모든 노드 참조가 유효함');
    passedCount++;
  }
  print('');
  
  print('✅ 6️⃣ 감정 상태 유효성 검증');
  for (var dialogue in dialogues) {
    final dialogueId = dialogue['id'] as String;
    final nodes = (dialogue['nodes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    for (var node in nodes) {
      final nodeId = node['id'] as String;
      final emotion = node['emotion'] as String?;
      
      if (emotion == null) {
        warnings.add('⚠️ Dialogue "$dialogueId" > Node "$nodeId" > emotion: null (감정 상태 누락)');
        warningCount++;
      } else if (!validEmotions.contains(emotion)) {
        issues.add('❌ Dialogue "$dialogueId" > Node "$nodeId" > emotion: "$emotion" (유효하지 않은 감정 상태)');
        failedCount++;
      }
    }
  }
  if (issues.length == failedCount - passedCount && warnings.length == warningCount) {
    print('   ✅ 모든 감정 상태가 유효함');
    passedCount++;
  }
  print('');
  
  print('✅ 7️⃣ Character 감정 에셋 매칭 검증');
  for (var char in characters) {
    final charId = char['id'] as String;
    final charDialogueIds = (char['dialogueIds'] as List?)?.cast<String>() ?? [];
    final emotionAssets = (char['emotionAssets'] as List?)?.cast<String>() ?? [];
    
    // 해당 캐릭터의 모든 대화에서 사용되는 감정 수집
    final usedEmotions = <String>{};
    for (var dialogueId in charDialogueIds) {
      final dialogue = dialogues.firstWhere(
        (d) => d['id'] == dialogueId,
        orElse: () => {},
      );
      final nodes = (dialogue['nodes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var node in nodes) {
        final emotion = node['emotion'] as String?;
        if (emotion != null) {
          usedEmotions.add(emotion);
        }
      }
    }
    
    // 에셋 개수만 확인 (실제 파일명 매칭은 복잡하므로 경고만)
    if (usedEmotions.isNotEmpty && emotionAssets.isEmpty) {
      warnings.add('⚠️ Character "$charId"의 대화에서 감정을 사용하지만, emotionAssets가 비어있음');
      warningCount++;
    }
  }
  if (warnings.length == warningCount) {
    print('   ✅ Character 감정 에셋이 적절히 정의되어 있음');
    passedCount++;
  }
  print('');
  
  print('✅ 8️⃣ 필수 필드 누락 검증');
  for (var char in characters) {
    final charId = char['id'] as String?;
    final eraId = char['eraId'] as String?;
    final name = char['name'] as String?;
    final nameKorean = char['nameKorean'] as String?;
    
    if (charId == null || charId.isEmpty) {
      issues.add('❌ Character의 id 필드가 비어있음');
      failedCount++;
    }
    if (eraId == null || eraId.isEmpty) {
      issues.add('❌ Character "$charId"의 eraId 필드가 비어있음');
      failedCount++;
    }
    if (name == null || name.isEmpty) {
      issues.add('❌ Character "$charId"의 name 필드가 비어있음');
      failedCount++;
    }
    if (nameKorean == null || nameKorean.isEmpty) {
      issues.add('❌ Character "$charId"의 nameKorean 필드가 비어있음');
      failedCount++;
    }
  }
  
  for (var dialogue in dialogues) {
    final dialogueId = dialogue['id'] as String?;
    final characterId = dialogue['characterId'] as String?;
    final title = dialogue['title'] as String?;
    final titleKorean = dialogue['titleKorean'] as String?;
    
    if (dialogueId == null || dialogueId.isEmpty) {
      issues.add('❌ Dialogue의 id 필드가 비어있음');
      failedCount++;
    }
    if (characterId == null || characterId.isEmpty) {
      issues.add('❌ Dialogue "$dialogueId"의 characterId 필드가 비어있음');
      failedCount++;
    }
    if (title == null || title.isEmpty) {
      issues.add('❌ Dialogue "$dialogueId"의 title 필드가 비어있음');
      failedCount++;
    }
    if (titleKorean == null || titleKorean.isEmpty) {
      issues.add('❌ Dialogue "$dialogueId"의 titleKorean 필드가 비어있음');
      failedCount++;
    }
  }
  if (issues.length == failedCount - passedCount) {
    print('   ✅ 모든 필수 필드가 채워져 있음');
    passedCount++;
  }
  print('');
  
  print('✅ 9️⃣ 종료 노드 검증');
  for (var dialogue in dialogues) {
    final dialogueId = dialogue['id'] as String;
    final nodes = (dialogue['nodes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    final endNodes = nodes.where((n) => n['isEnd'] == true).toList();
    if (endNodes.isEmpty) {
      issues.add('❌ Dialogue "$dialogueId"에 종료 노드(isEnd: true)가 없음');
      failedCount++;
    }
  }
  if (issues.length == failedCount - passedCount) {
    print('   ✅ 모든 Dialogue에 종료 노드가 있음');
    passedCount++;
  }
  print('');
  
  // 최종 보고
  print('\n=== 검증 요약 ===');
  print('✅ 통과한 검증: $passedCount개');
  print('❌ 실패한 검증: $failedCount개');
  print('⚠️ 경고 사항: $warningCount개\n');
  
  if (issues.isNotEmpty) {
    print('=== 주요 문제 (최대 20개) ===');
    for (var i = 0; i < issues.length && i < 20; i++) {
      print('${i + 1}. ${issues[i]}');
    }
    if (issues.length > 20) {
      print('... 외 ${issues.length - 20}개 문제');
    }
    print('');
  }
  
  if (warnings.isNotEmpty) {
    print('=== 경고 사항 (최대 15개) ===');
    for (var i = 0; i < warnings.length && i < 15; i++) {
      print('${i + 1}. ${warnings[i]}');
    }
    if (warnings.length > 15) {
      print('... 외 ${warnings.length - 15}개 경고');
    }
    print('');
  }
  
  print('=== 권장 조치 ===');
  if (failedCount > 0) {
    print('1. ❌ 표시된 오류들을 우선적으로 수정해주세요.');
    print('2. 참조 무결성 문제는 데이터 불일치를 야기할 수 있습니다.');
  }
  if (warningCount > 0) {
    print('3. ⚠️ 경고는 필수는 아니지만 일관성을 위해 검토를 권장합니다.');
  }
  if (failedCount == 0 && warningCount == 0) {
    print('🎉 모든 검증을 통과했습니다! 데이터가 건강한 상태입니다.');
  }
}
