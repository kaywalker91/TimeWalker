import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Character Providers ==============

/// 모든 캐릭터 목록 불러오기
final allCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getAllCharacters();
});

/// 시대별 인물 목록 불러오기
final characterListByEraProvider =
    FutureProvider.family<List<Character>, String>((ref, eraId) async {
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByEra(eraId);
    });

/// 장소별 인물 목록 불러오기 (해당 장소와 관련된 인물)
final characterListByLocationProvider =
    FutureProvider.family<List<Character>, String>((ref, locationId) async {
      final repository = ref.watch(characterRepositoryProvider);
      return repository.getCharactersByLocation(locationId);
    });

// ============== Dialogue Providers ==============

/// 인물별 대화 목록 불러오기
final dialogueListByCharacterProvider =
    FutureProvider.family<List<Dialogue>, String>((ref, characterId) async {
      final repository = ref.watch(dialogueRepositoryProvider);
      return repository.getDialoguesByCharacter(characterId);
    });

/// 대화 ID로 대화 정보 불러오기
final dialogueByIdProvider = FutureProvider.family<Dialogue?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(dialogueRepositoryProvider);
  return repository.getDialogueById(id);
});
