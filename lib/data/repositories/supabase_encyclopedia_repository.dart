import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/datasources/remote/supabase_content_loader.dart';
import 'package:time_walker/data/repositories/supabase_mapping_utils.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/domain/repositories/encyclopedia_repository.dart';

class SupabaseEncyclopediaRepository implements EncyclopediaRepository {
  SupabaseEncyclopediaRepository(this._client, this._loader);

  final SupabaseClient _client;
  final SupabaseContentLoader _loader;

  List<EncyclopediaEntry> _entries = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final rows = await _loader.loadList(
        dataset: 'encyclopedia_entries',
        fetchRemote: () async {
          final response = await _client.from('encyclopedia_entries').select();
          return List<Map<String, dynamic>>.from(response as List);
        },
        transform: _mapRow,
      );
      _entries = rows.map((e) => EncyclopediaEntry.fromJson(e)).toList();
    } catch (_) {
      final jsonString = await rootBundle.loadString('assets/data/encyclopedia.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _entries = jsonList.map((e) => EncyclopediaEntry.fromJson(e)).toList();
    }
    _isLoaded = true;
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

Map<String, dynamic> _mapRow(Map<String, dynamic> row) {
  return {
    'id': row['id'],
    'type': row['type'],
    'title': row['title'],
    'titleKorean': row['title_korean'],
    'summary': row['summary'],
    'content': row['content'],
    'thumbnailAsset': row['thumbnail_asset'],
    'imageAsset': row['image_asset'],
    'eraId': row['era_id'],
    'relatedEntryIds': stringList(row['related_entry_ids']),
    'tags': stringList(row['tags']),
    'isDiscovered': row['is_discovered'] ?? false,
    'discoveredAt': isoStringOrNull(row['discovered_at']),
    'discoverySource': row['discovery_source'],
  };
}
