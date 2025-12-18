import '../entities/encyclopedia_entry.dart';

abstract class EncyclopediaRepository {
  Future<List<EncyclopediaEntry>> getAllEntries();
  Future<List<EncyclopediaEntry>> getEntriesByType(EntryType type);
  Future<List<EncyclopediaEntry>> getEntriesByEra(String eraId);
  Future<EncyclopediaEntry?> getEntryById(String id);
  Future<List<EncyclopediaEntry>> searchEntries(String query);
}
