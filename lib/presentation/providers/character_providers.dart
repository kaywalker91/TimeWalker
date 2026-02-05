import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Character Providers ==============

/// 모든 캐릭터 목록 불러오기
/// Note: keepAlive 제거 - 대량 데이터는 화면 이탈 시 메모리 해제
final allCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getAllCharacters();
});

/// 시대별 인물 목록 불러오기
/// Note: keepAlive 제거 - 화면별 데이터는 화면 이탈 시 해제
final characterListByEraProvider =
    FutureProvider.family<List<Character>, String>((ref, eraId) async {
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByEra(eraId);
    });

/// 장소별 인물 목록 불러오기 (해당 장소와 관련된 인물)
/// Note: keepAlive 제거 - 화면별 데이터는 화면 이탈 시 해제
final characterListByLocationProvider =
    FutureProvider.family<List<Character>, String>((ref, locationId) async {
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByLocation(locationId);
    });

/// 캐릭터 ID로 인물 정보 불러오기
/// keepAlive: 대화 화면에서 위젯 rebuild 시 캐싱된 데이터 유지
final characterByIdProvider = FutureProvider.family<Character?, String>((
  ref,
  id,
) async {
  debugPrint('[characterByIdProvider] fetching id=$id');
  final repository = ref.watch(characterRepositoryProvider);
  final result = await repository.getCharacterById(id);
  debugPrint('[characterByIdProvider] result for $id: ${result?.id ?? 'null'}');
  return result;
});

/// 캐릭터 프리로더 (대화 진입 전 호출용)
/// 캐릭터 데이터를 미리 로드하여 대화 화면 진입 시 즉시 표시되도록 함
Future<void> prefetchCharacter(WidgetRef ref, String characterId) async {
  await ref.read(characterByIdProvider(characterId).future);
}

// ============== Dialogue Providers ==============

/// Note: keepAlive 제거 - 화면별 데이터는 화면 이탈 시 해제
final dialogueListByCharacterProvider =
    FutureProvider.family<List<Dialogue>, String>((ref, characterId) async {
  debugPrint('[dialogueListByCharacterProvider] characterId: $characterId');

  // 1. 캐릭터 정보 가져오기
  final character = await ref.watch(characterByIdProvider(characterId).future);
  if (character == null) {
    debugPrint('[dialogueListByCharacterProvider] character is NULL!');
    return [];
  }

  debugPrint('[dialogueListByCharacterProvider] character.dialogueIds: ${character.dialogueIds}');

  // 2. 캐릭터의 dialogueIds로 대화 목록 조회 (N+1 방지용 배치 쿼리)
  // 크로스오버 대화도 포함됨 (dialogueIds에 포함되어 있으면 표시)
  final repository = ref.watch(dialogueRepositoryProvider);
  final dialogues = await repository.getDialoguesByIds(character.dialogueIds);

  debugPrint('[dialogueListByCharacterProvider] loaded ${dialogues.length} dialogues');
  return dialogues;
});

/// 대화 ID로 대화 정보 불러오기
/// Note: keepAlive 제거 - 화면별 데이터는 화면 이탈 시 해제
final dialogueByIdProvider = FutureProvider.family<Dialogue?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(dialogueRepositoryProvider);
  return repository.getDialogueById(id);
});
