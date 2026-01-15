import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/core/config/supabase_config.dart';
import 'package:time_walker/data/datasources/remote/supabase_content_loader.dart';
import 'package:time_walker/data/repositories/mock_country_repository.dart';
import 'package:time_walker/data/repositories/mock_era_repository.dart';
import 'package:time_walker/data/repositories/mock_region_repository.dart';
import 'package:time_walker/data/repositories/mock_location_repository.dart';
import 'package:time_walker/data/repositories/mock_character_repository.dart';
import 'package:time_walker/data/repositories/mock_dialogue_repository.dart';
import 'package:time_walker/data/repositories/hive_user_progress_repository.dart';
import 'package:time_walker/data/repositories/mock_encyclopedia_repository.dart';
import 'package:time_walker/data/repositories/mock_quiz_repository.dart';
import 'package:time_walker/data/repositories/mock_shop_repository.dart';
import 'package:time_walker/data/repositories/supabase_character_repository.dart';
import 'package:time_walker/data/repositories/supabase_dialogue_repository.dart';
import 'package:time_walker/data/repositories/supabase_encyclopedia_repository.dart';
import 'package:time_walker/data/repositories/supabase_location_repository.dart';
import 'package:time_walker/data/repositories/supabase_quiz_repository.dart';
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/domain/repositories/location_repository.dart';
import 'package:time_walker/domain/repositories/character_repository.dart';
import 'package:time_walker/domain/repositories/dialogue_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/repositories/encyclopedia_repository.dart';
import 'package:time_walker/domain/repositories/quiz_repository.dart';
import 'package:time_walker/domain/repositories/shop_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';

// Re-export all providers for backward compatibility
// 기존 코드와의 호환성을 위해 다른 provider 파일들을 re-export 합니다.
export 'user_progress_provider.dart';
export 'exploration_providers.dart';
export 'character_providers.dart';
export 'content_providers.dart';

// ============================================================================
// Repository Providers
// ============================================================================
// 이 파일은 Repository 인터페이스와 Mock 구현체를 연결하는 Provider만 포함합니다.
// 실제 데이터 fetching Provider들은 분리된 파일에서 관리됩니다:
// - user_progress_provider.dart: 사용자 진행 상태
// - exploration_providers.dart: Region, Era, Country, Location
// - character_providers.dart: Character, Dialogue
// - content_providers.dart: Encyclopedia, Quiz, Shop
// ============================================================================

/// Region Repository Provider
final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  return MockRegionRepository();
});

/// Era Repository Provider
final eraRepositoryProvider = Provider<EraRepository>((ref) {
  return MockEraRepository();
});

/// Country Repository Provider
final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  return MockCountryRepository();
});

final supabaseContentLoaderProvider = Provider<SupabaseContentLoader>((ref) {
  if (!SupabaseConfig.isConfigured) {
    throw StateError('Supabase is not configured');
  }
  return SupabaseContentLoader(Supabase.instance.client);
});

/// Location Repository Provider
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseLocationRepository(
      Supabase.instance.client,
      ref.read(supabaseContentLoaderProvider),
    );
  }
  return MockLocationRepository();
});

/// Character Repository Provider
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseCharacterRepository(
      Supabase.instance.client,
      ref.read(supabaseContentLoaderProvider),
    );
  }
  return MockCharacterRepository();
});

/// Dialogue Repository Provider
final dialogueRepositoryProvider = Provider<DialogueRepository>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseDialogueRepository(
      Supabase.instance.client,
      ref.read(supabaseContentLoaderProvider),
    );
  }
  return MockDialogueRepository();
});

/// UserProgress Repository Provider
/// 
/// Hive를 사용한 영속성 저장 구현 (앱 종료 후에도 데이터 유지)
final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  return HiveUserProgressRepository();
});

/// Encyclopedia Repository Provider
final encyclopediaRepositoryProvider = Provider<EncyclopediaRepository>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseEncyclopediaRepository(
      Supabase.instance.client,
      ref.read(supabaseContentLoaderProvider),
    );
  }
  return MockEncyclopediaRepository();
});

/// Quiz Repository Provider
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  if (SupabaseConfig.isConfigured) {
    return SupabaseQuizRepository(
      Supabase.instance.client,
      ref.read(supabaseContentLoaderProvider),
    );
  }
  return MockQuizRepository();
});

/// Shop Repository Provider
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return MockShopRepository();
});

/// Progression Service Provider
final progressionServiceProvider = Provider<ProgressionService>((ref) {
  return ProgressionService();
});
