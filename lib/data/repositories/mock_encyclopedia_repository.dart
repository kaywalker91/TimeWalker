import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/encyclopedia_entry.dart';
import '../../domain/repositories/encyclopedia_repository.dart';

class MockEncyclopediaRepository implements EncyclopediaRepository {
  List<EncyclopediaEntry> _entries = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/encyclopedia.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _entries = jsonList.map((e) => EncyclopediaEntry.fromJson(e)).toList();
      _isLoaded = true;
    } catch (e) {
      // Fallback/Empty or Log
      _entries = [];
    }
  }

  @override
  Future<List<EncyclopediaEntry>> getAllEntries() async {
    await _ensureLoaded();
    return _entries;
  }

  @override
  Future<List<EncyclopediaEntry>> getEntriesByType(EntryType type) async {
    await _ensureLoaded();
    return _entries.where((e) => e.type == type).toList();
  }

  @override
  Future<List<EncyclopediaEntry>> getEntriesByEra(String eraId) async {
    await _ensureLoaded();
    return _entries.where((e) => e.eraId == eraId).toList();
  }

  @override
  Future<EncyclopediaEntry?> getEntryById(String id) async {
    await _ensureLoaded();
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<EncyclopediaEntry>> searchEntries(String query) async {
    await _ensureLoaded();
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return _entries.where((entry) {
      return entry.title.toLowerCase().contains(lowerQuery) ||
             entry.titleKorean.contains(query) ||
             entry.tags.any((tag) => tag.contains(query));
    }).toList();
  }
}
