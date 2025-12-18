import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/repositories/character_repository.dart';

class MockCharacterRepository implements CharacterRepository {
  List<Character> _characters = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/characters.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _characters = jsonList.map((e) => Character.fromJson(e)).toList();
      _isLoaded = true;
    } catch (e) {
      // Fallback/Empty or Log error
      _characters = [];
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    await _ensureLoaded();
    return _characters;
  }

  @override
  Future<List<Character>> getCharactersByEra(String eraId) async {
    await _ensureLoaded();
    return _characters.where((c) => c.eraId == eraId).toList();
  }

  @override
  Future<List<Character>> getCharactersByLocation(String locationId) async {
    await _ensureLoaded();
    return _characters
        .where((c) => c.relatedLocationIds.contains(locationId))
        .toList();
  }

  @override
  Future<Character?> getCharacterById(String id) async {
    await _ensureLoaded();
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
