import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Character Providers ==============

/// 모든 캐릭터 목록 불러오기
final allCharactersProvider = FutureProvider<List<Character>>((ref) async {
  ref.keepAlive(); // 결과 캐시 유지
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getAllCharacters();
});

/// 시대별 인물 목록 불러오기
final characterListByEraProvider =
    FutureProvider.family<List<Character>, String>((ref, eraId) async {
      ref.keepAlive(); // 결과 캐시 유지
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByEra(eraId);
    });

/// 장소별 인물 목록 불러오기 (해당 장소와 관련된 인물)
final characterListByLocationProvider =
    FutureProvider.family<List<Character>, String>((ref, locationId) async {
      ref.keepAlive(); // 결과 캐시 유지
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByLocation(locationId);
    });

/// 캐릭터 ID로 인물 정보 불러오기
final characterByIdProvider = FutureProvider.family<Character?, String>((
  ref,
  id,
) async {
  ref.keepAlive(); // 결과 캐시 유지
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getCharacterById(id);
});

// ============== Dialogue Providers ==============

final dialogueListByCharacterProvider =
    FutureProvider.family<List<Dialogue>, String>((ref, characterId) async {
  ref.keepAlive(); // 결과 캐시 유지
  
  // 1. 캐릭터 정보 가져오기
  final character = await ref.watch(characterByIdProvider(characterId).future);
  if (character == null) return [];

  // 2. 모든 대화 가져오기 (MVP: Repository에 ID 리스트로 조회하는 기능이 없으므로 전체 조회 후 필터링)
  final repository = ref.watch(dialogueRepositoryProvider);
  final allDialogues = await repository.getAllDialogues();

  // 3. 캐릭터의 dialogueIds에 포함된 대화만 필터링
  // 이를 통해 '주인'이 아니더라도(크로스오버 등) 내 대화 목록에 표시됨
  final targetIds = character.dialogueIds.toSet();
  return allDialogues.where((d) => targetIds.contains(d.id)).toList();
});

/// 대화 ID로 대화 정보 불러오기
final dialogueByIdProvider = FutureProvider.family<Dialogue?, String>((
  ref,
  id,
) async {
  ref.keepAlive(); // 결과 캐시 유지
  final repository = ref.watch(dialogueRepositoryProvider);
  return repository.getDialogueById(id);
});
