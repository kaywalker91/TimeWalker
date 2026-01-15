import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_entities.dart';

void main() {
  group('Dialogue Entities', () {
    // =========================================================
    // DialogueChoice Tests
    // =========================================================
    group('DialogueChoice', () {
      const choice = DialogueChoice(
        id: 'c1',
        text: 'Yes',
        preview: 'Say Yes',
        nextNodeId: 'node2',
        reward: DialogueReward(knowledgePoints: 10),
        condition: ChoiceCondition(requiredKnowledge: 100),
      );

      test('props가 올바르게 작동한다', () {
        const choice2 = DialogueChoice(
          id: 'c1',
          text: 'Yes',
          preview: 'Say Yes',
          nextNodeId: 'node2',
          reward: DialogueReward(knowledgePoints: 10),
          condition: ChoiceCondition(requiredKnowledge: 100),
        );
        expect(choice, equals(choice2));
      });

      test('hasCondition이 올바르게 작동한다', () {
        expect(choice.hasCondition, isTrue);
        
        const simpleChoice = DialogueChoice(
          id: 'c2',
          text: 'No',
          nextNodeId: 'node3',
        );
        expect(simpleChoice.hasCondition, isFalse);
      });

      test('fromJson이 정상적으로 파싱한다', () {
        final json = {
          'id': 'c1',
          'text': 'Yes',
          'nextNodeId': 'node2',
          'reward': {'knowledgePoints': 10},
          'condition': {'requiredKnowledge': 100}
        };
        final parsed = DialogueChoice.fromJson(json);
        expect(parsed.id, equals('c1'));
        expect(parsed.reward?.knowledgePoints, equals(10));
        expect(parsed.condition?.requiredKnowledge, equals(100));
      });
    });

    // =========================================================
    // DialogueNode Tests
    // =========================================================
    group('DialogueNode', () {
      const node = DialogueNode(
        id: 'start',
        speakerId: 'sejong',
        text: 'Welcome',
        emotion: 'happy',
        choices: [
          DialogueChoice(id: 'c1', text: 'Hi', nextNodeId: 'node2'),
        ],
      );

      test('props가 올바르게 작동한다', () {
        const node2 = DialogueNode(
          id: 'start',
          speakerId: 'sejong',
          text: 'Welcome',
          emotion: 'happy',
          choices: [
            DialogueChoice(id: 'c1', text: 'Hi', nextNodeId: 'node2'),
          ],
        );
        expect(node, equals(node2));
      });

      test('hasChoices가 올바르게 작동한다', () {
        expect(node.hasChoices, isTrue);
        
        const autoNode = DialogueNode(
          id: 'auto',
          speakerId: 'sejong',
          text: 'Next...',
          nextNodeId: 'next',
        );
        expect(autoNode.hasChoices, isFalse);
      });

      test('isAutoProgress가 올바르게 작동한다', () {
        const autoNode = DialogueNode(
          id: 'auto',
          speakerId: 'sejong',
          text: 'Next...',
          nextNodeId: 'next',
        );
        expect(autoNode.isAutoProgress, isTrue);
        expect(node.isAutoProgress, isFalse); // has choices
        
        const endNode = DialogueNode(
          id: 'end',
          speakerId: 'sejong',
          text: 'Bye',
          isEnd: true,
        );
        expect(endNode.isAutoProgress, isFalse); // is end
      });
    });

    // =========================================================
    // Dialogue Tests
    // =========================================================
    group('Dialogue', () {
      const startNode = DialogueNode(id: 'start', speakerId: 's', text: 'Hi');
      const nextNode = DialogueNode(id: 'next', speakerId: 's', text: 'Bye');
      
      const dialogue = Dialogue(
        id: 'd1',
        characterId: 'char1',
        title: 'Title',
        titleKorean: '제목',
        description: 'Desc',
        nodes: [startNode, nextNode],
        rewards: [DialogueReward(knowledgePoints: 50)],
        isCompleted: false,
      );

      test('props가 올바르게 작동한다', () {
        const dialogue2 = Dialogue(
          id: 'd1',
          characterId: 'char1',
          title: 'Title',
          titleKorean: '제목',
          description: 'Desc',
          nodes: [startNode, nextNode],
          rewards: [DialogueReward(knowledgePoints: 50)],
          isCompleted: false,
        );
        expect(dialogue, equals(dialogue2));
      });

      test('startNode가 시작 노드를 반환한다', () {
        expect(dialogue.startNode, equals(startNode));
      });

      test('startNode가 없으면 첫 번째 노드를 반환한다', () {
        const d = Dialogue(
          id: 'd2',
          characterId: 'c',
          title: 't',
          titleKorean: 'tk',
          description: 'd',
          nodes: [nextNode], // no 'start' id
        );
        expect(d.startNode, equals(nextNode));
      });

      test('getNodeById가 노드를 찾는다', () {
        expect(dialogue.getNodeById('start'), equals(startNode));
        expect(dialogue.getNodeById('next'), equals(nextNode));
        expect(dialogue.getNodeById('unknown'), isNull);
      });

      test('totalRewardPoints가 보상 합계를 계산한다', () {
        expect(dialogue.totalRewardPoints, equals(50));
        
        final d2 = dialogue.copyWith(rewards: [
          const DialogueReward(knowledgePoints: 10),
          const DialogueReward(knowledgePoints: 20),
        ]);
        expect(d2.totalRewardPoints, equals(30));
      });

      test('fromJson이 정상적으로 파싱한다', () {
        final json = {
          'id': 'd1',
          'characterId': 'char1',
          'title': 'Title',
          'titleKorean': '제목',
          'nodes': [
            {
              'id': 'start',
              'speakerId': 's',
              'text': 'Hi',
              'isEnd': false
            }
          ],
          'rewards': [
            {'knowledgePoints': 50}
          ]
        };
        final parsed = Dialogue.fromJson(json);
        expect(parsed.id, equals('d1'));
        expect(parsed.nodes.length, equals(1));
        expect(parsed.rewards.length, equals(1));
        expect(parsed.rewards.first.knowledgePoints, equals(50));
      });
    });
  });
}
