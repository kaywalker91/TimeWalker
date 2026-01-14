import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseContentLoader {
  SupabaseContentLoader(
    this._client, {
    this.cacheBoxName = 'content_cache',
    this.metaBoxName = 'content_meta',
  });

  final SupabaseClient _client;
  final String cacheBoxName;
  final String metaBoxName;

  Future<List<Map<String, dynamic>>> loadList({
    required String dataset,
    required Future<List<Map<String, dynamic>>> Function() fetchRemote,
    Map<String, dynamic> Function(Map<String, dynamic> row)? transform,
  }) async {
    final cacheBox = await _openBox(cacheBoxName);
    final metaBox = await _openBox(metaBoxName);
    final cacheKey = _cacheKey(dataset);
    final versionKey = _versionKey(dataset);

    final remoteToken = await _fetchVersionToken(dataset);
    final localToken = metaBox.get(versionKey);
    final cachedJson = cacheBox.get(cacheKey);

    if (remoteToken != null && localToken == remoteToken && cachedJson != null) {
      final cached = _decodeList(cachedJson);
      if (cached != null) return cached;
    }

    try {
      final rows = await fetchRemote();
      final mapped = transform == null ? rows : rows.map(transform).toList();
      await cacheBox.put(cacheKey, jsonEncode(mapped));
      if (remoteToken != null) {
        await metaBox.put(versionKey, remoteToken);
      }
      return mapped;
    } catch (_) {
      if (cachedJson != null) {
        final cached = _decodeList(cachedJson);
        if (cached != null) return cached;
      }
      rethrow;
    }
  }

  Future<Box<String>> _openBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<String>(name);
    }
    return Hive.openBox<String>(name);
  }

  String _cacheKey(String dataset) => 'cache:$dataset';

  String _versionKey(String dataset) => 'version:$dataset';

  Future<String?> _fetchVersionToken(String dataset) async {
    try {
      final response = await _client
          .from('content_versions')
          .select('dataset, version, checksum')
          .eq('dataset', dataset)
          .limit(1);

      if (response.isNotEmpty) {
        final row = Map<String, dynamic>.from(response.first as Map);
        final version = row['version']?.toString();
        final checksum = row['checksum']?.toString();
        if (version == null && checksum == null) return null;
        return '${version ?? ''}|${checksum ?? ''}';
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  List<Map<String, dynamic>>? _decodeList(String cachedJson) {
    try {
      final decoded = jsonDecode(cachedJson) as List<dynamic>;
      return decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (_) {
      return null;
    }
  }
}
