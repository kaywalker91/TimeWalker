import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/data/repositories/mock_dialogue_repository.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_entities.dart';

// Mock JSON Data
const mockDialogueJson = '''
[
  {
    "id": "test_dialogue",
    "characterId": "test_char",
    "title": "Test Title",
    "titleKorean": "테스트 제목",
    "description": "Test Description",
    "nodes": [
      {
        "id": "start",
        "speakerId": "test_char",
        "text": "Hello Tester",
        "emotion": "happy",
        "isEnd": true
      }
    ],
    "isCompleted": false,
    "estimatedMinutes": 3
  }
]
''';

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/data/dialogues.json') {
      return mockDialogueJson;
    }
    throw FormatException('Unexpected key: $key');
  }
}

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); // Not strictly needed with MockAssetBundle but good practice

  group('MockDialogueRepository', () {
    late MockDialogueRepository repository;

    setUp(() {
      // Inject MockAssetBundle
      repository = MockDialogueRepository(MockAssetBundle());
    });

    test('getAllDialogues returns loaded dialogues', () async {
      final dialogues = await repository.getAllDialogues();
      expect(dialogues, isNotEmpty);
      expect(dialogues.length, equals(1));
      expect(dialogues.first.id, equals('test_dialogue'));
    });

    test('getDialogueById returns correct dialogue', () async {
      final dialogue = await repository.getDialogueById('test_dialogue');
      expect(dialogue, isNotNull);
      expect(dialogue!.titleKorean, equals('테스트 제목'));
    });

    test('getDialogueById returns null for non-existent id', () async {
      final dialogue = await repository.getDialogueById('non_existent');
      expect(dialogue, isNull);
    });

    test('getDialoguesByCharacter filters correctly', () async {
      // 1. Existing character
      final dialogues = await repository.getDialoguesByCharacter('test_char');
      expect(dialogues, isNotEmpty);
      expect(dialogues.first.characterId, equals('test_char'));

      // 2. Non-existent character
      final emptyDialogues = await repository.getDialoguesByCharacter('other_char');
      expect(emptyDialogues, isEmpty);
    });

    test('getDialoguesByIds returns matching dialogues', () async {
      // 1. Existing IDs
      final dialogues = await repository.getDialoguesByIds(['test_dialogue']);
      expect(dialogues, isNotEmpty);
      expect(dialogues.first.id, equals('test_dialogue'));

      // 2. Empty list
      final emptyResult = await repository.getDialoguesByIds([]);
      expect(emptyResult, isEmpty);

      // 3. Non-existent IDs
      final noMatch = await repository.getDialoguesByIds(['non_existent']);
      expect(noMatch, isEmpty);
    });

    test('save and get DialogueProgress', () async {
      final progress = DialogueProgress(
        dialogueId: 'test_dialogue',
        currentNodeId: 'start',
        isCompleted: true,
        visitedNodeIds: const ['start'],
      );

      await repository.saveDialogueProgress(progress);
      
      final saved = await repository.getDialogueProgress('test_dialogue');
      expect(saved, isNotNull);
      expect(saved!.isCompleted, isTrue);
      expect(saved.currentNodeId, equals('start'));
    });
  });

  group('Dialogue Entities', () {
    test('Dialogue implements Equatable', () {
      const dialogue1 = Dialogue(
        id: 'd1',
        characterId: 'c1',
        title: 't1',
        titleKorean: 'tk1',
        description: 'desc',
        nodes: [],
        isCompleted: false,
      );
      const dialogue2 = Dialogue(
        id: 'd1',
        characterId: 'c1',
        title: 't1',
        titleKorean: 'tk1',
        description: 'desc',
        nodes: [],
        isCompleted: false,
      );
      
      expect(dialogue1, equals(dialogue2));
    });

    test('Dialogue startNode returns node with id "start"', () {
      const node1 = DialogueNode(id: 'intro', speakerId: 's1', text: 't');
      const node2 = DialogueNode(id: 'start', speakerId: 's1', text: 't');
      
      const dialogue = Dialogue(
        id: 'd1',
        characterId: 'c1',
        title: 't1',
        titleKorean: 'tk1',
        description: 'desc',
        nodes: [node1, node2],
      );

      expect(dialogue.startNode, equals(node2));
    });
  });
}
