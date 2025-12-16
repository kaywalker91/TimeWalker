import 'package:time_walker/domain/entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getAllCharacters();
  Future<List<Character>> getCharactersByEra(String eraId);
  Future<List<Character>> getCharactersByLocation(String locationId);
  Future<Character?> getCharacterById(String id);
}
