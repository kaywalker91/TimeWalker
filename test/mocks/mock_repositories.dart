// Mock repository classes for testing (mocktail)
//
// This file contains all mock repository implementations used across tests.
// Using mocktail instead of mockito for simpler syntax and no code generation.

import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_walker/data/datasources/remote/supabase_content_loader.dart';
import 'package:time_walker/domain/repositories/character_repository.dart';
import 'package:time_walker/domain/repositories/country_repository.dart';
import 'package:time_walker/domain/repositories/dialogue_repository.dart';
import 'package:time_walker/domain/repositories/encyclopedia_repository.dart';
import 'package:time_walker/domain/repositories/era_repository.dart';
import 'package:time_walker/domain/repositories/location_repository.dart';
import 'package:time_walker/domain/repositories/quiz_repository.dart';
import 'package:time_walker/domain/repositories/region_repository.dart';
import 'package:time_walker/domain/repositories/shop_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/domain/services/progression_service.dart';
import 'package:time_walker/domain/services/user_progress_factory.dart';

// ============== Repository Mocks ==============

class MockUserProgressRepository extends Mock
    implements UserProgressRepository {}

class MockEraRepository extends Mock implements EraRepository {}

class MockCountryRepository extends Mock implements CountryRepository {}

class MockRegionRepository extends Mock implements RegionRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockCharacterRepository extends Mock implements CharacterRepository {}

class MockDialogueRepository extends Mock implements DialogueRepository {}

class MockEncyclopediaRepository extends Mock
    implements EncyclopediaRepository {}

class MockQuizRepository extends Mock implements QuizRepository {}

class MockShopRepository extends Mock implements ShopRepository {}

// ============== Service Mocks ==============

class MockProgressionService extends Mock implements ProgressionService {}

class MockUserProgressFactory extends Mock implements UserProgressFactory {}

// ============== Supabase Mocks ==============

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock
    implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder<T> extends Mock
    implements PostgrestFilterBuilder<T> {}

class MockPostgrestTransformBuilder<T> extends Mock
    implements PostgrestTransformBuilder<T> {}

class MockSupabaseContentLoader extends Mock implements SupabaseContentLoader {}
