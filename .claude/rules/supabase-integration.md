---
paths:
  - "lib/data/datasources/remote/**"
  - "lib/core/config/**"
---

# Supabase Integration Rules

## Fallback Chain (Critical)

```
Supabase (remote) -> Hive (local cache) -> Static (bundled data)
```

Every remote data fetch must implement this chain:
```dart
Future<List<Entity>> getAll() async {
  try {
    // 1. Try remote
    final remote = await _supabaseClient.from('table').select();
    final entities = remote.map((e) => Model.fromJson(e).toEntity()).toList();
    // 2. Cache locally
    await _localCache.put('key', entities);
    return entities;
  } catch (e) {
    // 3. Try local cache
    final cached = await _localCache.get('key');
    if (cached != null) return cached;
    // 4. Fall back to static
    return StaticData.getAll().map((m) => m.toEntity()).toList();
  }
}
```

## Repository Switching

In `lib/presentation/providers/repository_providers.dart`:
```dart
final eraRepositoryProvider = Provider<EraRepository>((ref) {
  // Switch between implementations
  return MockEraRepository();        // Static data
  // return SupabaseEraRepository(); // Remote data
});
```

## Remote DataSource Pattern

```dart
class SupabaseXxxLoader {
  final SupabaseClient _client;

  SupabaseXxxLoader(this._client);

  Future<List<XxxModel>> fetchAll() async {
    final response = await _client.from('xxx').select();
    return response.map((json) => XxxModel.fromJson(json)).toList();
  }
}
```

## Configuration

- Supabase credentials in `.env` (never commit)
- Initialize in `main.dart` before `runApp()`
- Use `Supabase.instance.client` for access

## Table Naming (Supabase)

- Use `snake_case` for table/column names
- Match entity field names where possible
- Prefix: none (Supabase handles namespacing)

## Auth Integration

- Anonymous auth for initial app usage
- Migrate to email/social auth when user registers
- Store user ID for progress sync

## Rules

- NEVER commit `.env` or Supabase keys
- Always handle `SocketException` / network errors
- Cache timestamps for freshness checks
- Batch requests where possible (reduce API calls)
- Use Supabase realtime only for multiplayer features
- Test with mock repositories (never hit real Supabase in tests)
