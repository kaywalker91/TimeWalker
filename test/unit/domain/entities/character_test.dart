import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/character.dart';

void main() {
  group('Character', () {
    final character = Character(
      id: 'sejong',
      eraId: 'joseon',
      name: 'Sejong',
      nameKorean: '세종대왕',
      title: '조선 제4대 국왕',
      birth: '1397',
      death: '1450',
      biography: 'Great King Sejong',
      fullBiography: 'Detailed biography...',
      portraitAsset: 'sejong.png',
      emotionAssets: const ['happy.png', 'sad.png'],
      dialogueIds: const ['d1', 'd2'],
      status: CharacterStatus.locked,
    );

    test('props가 올바르게 작동한다 (Equatable)', () {
      final character2 = Character(
        id: 'sejong',
        eraId: 'joseon',
        name: 'Sejong',
        nameKorean: '세종대왕',
        title: '조선 제4대 국왕',
        birth: '1397',
        death: '1450',
        biography: 'Great King Sejong',
        fullBiography: 'Detailed biography...',
        portraitAsset: 'sejong.png',
        emotionAssets: const ['happy.png', 'sad.png'],
        dialogueIds: const ['d1', 'd2'],
        status: CharacterStatus.locked,
      );

      expect(character, equals(character2));
    });

    test('copyWith가 값을 올바르게 변경한다', () {
      final updated = character.copyWith(
        nameKorean: '이도',
        status: CharacterStatus.available,
        dialogueIds: ['d1', 'd2', 'd3'],
      );

      expect(updated.nameKorean, equals('이도'));
      expect(updated.status, equals(CharacterStatus.available));
      expect(updated.dialogueIds.length, equals(3));
      // 유지
      expect(updated.id, equals(character.id));
      expect(updated.birth, equals(character.birth));
    });

    test('isAccessible이 status에 따라 올바른 값을 반환한다', () {
      expect(character.copyWith(status: CharacterStatus.locked).isAccessible, isFalse);
      
      expect(character.copyWith(status: CharacterStatus.available).isAccessible, isTrue);
      expect(character.copyWith(status: CharacterStatus.inProgress).isAccessible, isTrue);
      expect(character.copyWith(status: CharacterStatus.completed).isAccessible, isTrue);
    });

    test('isCompleted가 status에 따라 올바른 값을 반환한다', () {
      expect(character.copyWith(status: CharacterStatus.completed).isCompleted, isTrue);
      expect(character.copyWith(status: CharacterStatus.inProgress).isCompleted, isFalse);
    });

    test('lifespan이 올바른 문자열을 반환한다', () {
      expect(character.lifespan, equals('1397 - 1450'));
    });

    test('dialogueCount가 올바른 개수를 반환한다', () {
      expect(character.dialogueCount, equals(2));
    });

    test('fromJson이 정상적으로 파싱한다', () {
      final json = {
        'id': 'yi_sun_sin',
        'eraId': 'joseon',
        'name': 'Yi Sun-sin',
        'nameKorean': '이순신',
        'title': 'Admiral',
        'birth': '1545',
        'death': '1598',
        'description': 'Hero of Joseon', // maps to biography
        'thumbnailAsset': 'yi.png', // maps to portraitAsset
        'emotionAssets': ['angry.png'],
        'dialogueIds': ['d1'],
        'status': 'available',
        'isHistorical': true,
      };

      final parsed = Character.fromJson(json);

      expect(parsed.id, equals('yi_sun_sin'));
      expect(parsed.nameKorean, equals('이순신'));
      expect(parsed.title, equals('Admiral'));
      expect(parsed.biography, equals('Hero of Joseon'));
      expect(parsed.portraitAsset, equals('yi.png'));
      expect(parsed.status, equals(CharacterStatus.available));
      expect(parsed.isHistorical, isTrue);
    });

    test('fromJson이 누락된 필드에 대해 기본값을 사용한다', () {
      final json = {
        'id': 'unknown',
        'eraId': 'joseon',
      };

      final parsed = Character.fromJson(json);

      expect(parsed.id, equals('unknown'));
      expect(parsed.nameKorean, equals('알 수 없음'));
      expect(parsed.birth, equals('?'));
      expect(parsed.status, equals(CharacterStatus.locked));
      expect(parsed.isHistorical, isTrue); // default
    });
  });
}
