import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/data/datasources/static/country_data.dart';
import 'package:time_walker/data/datasources/static/era_data.dart';
import 'package:time_walker/domain/entities/user_progress.dart';

/// Seed data for creating new user progress records.
class UserProgressSeed {
  UserProgressSeed._();

  /// Default starting state for a new player.
  static UserProgress initial(String userId) {
    return UserProgress(
      userId: userId,
      rank: ExplorerRank.novice,
      unlockedRegionIds: const ['asia'],
      unlockedCountryIds: const ['korea'],
      unlockedEraIds: const ['korea_three_kingdoms'],
      coins: 99999,
    );
  }

  /// Dev seed with broad unlocks for quick navigation/testing.
  static UserProgress debugAllUnlocked(String userId) {
    // Dynamically fetch all IDs from static data sources
    final allEraIds = EraData.all.map((e) => e.id).toList();
    final allCountryIds = CountryData.all.map((c) => c.id).toList();
    
    // Collect all character IDs defined in eras
    final allCharacterIds = EraData.all
        .expand((e) => e.characterIds)
        .toSet() // Remove duplicates
        .toList();

    // Add some extra specific character IDs if they are not in EraData
    allCharacterIds.addAll([
      'encyclo_char_Q128027',
      'encyclo_char_Q9319',
    ]);

    return UserProgress(
      userId: userId,
      rank: ExplorerRank.master, // Admin mode gets highest rank
      unlockedRegionIds: const ['asia', 'europe', 'africa', 'americas', 'middle_east'],
      unlockedCountryIds: allCountryIds,
      unlockedEraIds: allEraIds,
      unlockedCharacterIds: allCharacterIds,
      unlockedFactIds: const ['encyclo_char_Q61073'], // Facts might need a similar approach if Critical
      coins: 99999,
    );
  }
}
