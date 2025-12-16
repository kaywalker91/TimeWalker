import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/repositories/character_repository.dart';

class MockCharacterRepository implements CharacterRepository {
  final List<Character> _characters = [...CharacterData.all];

  @override
  Future<List<Character>> getAllCharacters() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _characters;
  }

  @override
  Future<List<Character>> getCharactersByEra(String eraId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _characters.where((c) => c.eraId == eraId).toList();
  }

  @override
  Future<List<Character>> getCharactersByLocation(String locationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _characters
        .where((c) => c.relatedLocationIds.contains(locationId))
        .toList();
  }

  @override
  Future<Character?> getCharacterById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
