import 'package:time_walker/core/constants/exploration_config.dart';
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
    return UserProgress(
      userId: userId,
      rank: ExplorerRank.novice,
      unlockedRegionIds: const ['asia', 'europe', 'africa', 'americas', 'middle_east'],
      unlockedCountryIds: const [
        'korea',
        'china',
        'japan',
        'india',
        'mongolia',
        'greece',
        'rome',
        'britain',
        'france',
        'germany',
        'egypt',
        'ethiopia',
        'mali',
        'maya',
        'aztec',
        'inca',
        'usa',
        'mesopotamia',
        'persia',
        'ottoman',
        'italy',
      ],
      unlockedEraIds: const [
        'korea_three_kingdoms',
        'korea_goryeo',
        'korea_joseon',
        'europe_renaissance',
      ],
      unlockedCharacterIds: const [
        'encyclo_char_Q128027',
        'encyclo_char_Q9319',
        'gwanggaeto',
        'geunchogo',
        'kim_yushin',
        'seondeok',
        'eulji_mundeok',
        'jangsu',
        'gyebaek',
        'uija',
      ],
      unlockedFactIds: const ['encyclo_char_Q61073'],
      coins: 99999,
    );
  }
}
