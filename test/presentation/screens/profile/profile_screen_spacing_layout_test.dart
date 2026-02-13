import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/settings.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/settings_repository.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/profile/profile_screen.dart';
import 'package:time_walker/presentation/screens/profile/widgets/profile_layout_spec.dart';

void main() {
  const widths = <double>[320, 360, 390, 412];
  const textScales = <double>[1.0, 1.3];
  const locales = <Locale>[Locale('ko'), Locale('en')];

  Future<void> pumpProfileScreen(
    WidgetTester tester, {
    required double width,
    required double textScale,
    required Locale locale,
  }) async {
    const userProgress = UserProgress(
      userId: 'test_user',
      rank: ExplorerRank.apprentice,
      totalKnowledge: 1234,
      completedDialogueIds: <String>['d1', 'd2', 'd3'],
      unlockedRegionIds: <String>['asia'],
      unlockedCountryIds: <String>['korea'],
      unlockedEraIds: <String>['joseon'],
      unlockedCharacterIds: <String>['c1', 'c2'],
      unlockedFactIds: ['f1'],
      totalPlayTimeMinutes: 95,
    );
    const settings = GameSettings(playerName: '시간 여행자', playerAvatarIndex: 0);

    await tester.binding.setSurfaceSize(Size(width, 900));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProgressRepositoryProvider.overrideWithValue(
            _FakeUserProgressRepository(userProgress),
          ),
          settingsRepositoryProvider.overrideWithValue(
            _FakeSettingsRepository(settings),
          ),
          encyclopediaListProvider.overrideWith((ref) async => const []),
        ],
        child: MediaQuery(
          data: MediaQueryData(
            size: Size(width, 900),
            textScaler: TextScaler.linear(textScale),
          ),
          child: MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const ProfileScreen(),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
  }

  void expectCloseToToken(
    double actual,
    double expected, {
    required String reason,
  }) {
    expect(
      (actual - expected).abs(),
      lessThanOrEqualTo(1.0),
      reason: '$reason (actual=$actual, expected=$expected)',
    );
  }

  group('ProfileScreen spacing layout', () {
    testWidgets('renders without overflow across width/textScale/locale matrix', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final width in widths) {
        for (final textScale in textScales) {
          for (final locale in locales) {
            await pumpProfileScreen(
              tester,
              width: width,
              textScale: textScale,
              locale: locale,
            );

            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Unexpected exception at width=$width, scale=$textScale, locale=${locale.languageCode}',
            );
            expect(find.byKey(const Key('profile_id_card')), findsOneWidget);
            expect(
              find.byKey(const Key('profile_edit_section')),
              findsOneWidget,
            );
            expect(
              find.byKey(const Key('profile_rank_section')),
              findsOneWidget,
            );
            expect(find.byKey(const Key('profile_stats_grid')), findsOneWidget);
          }
        }
      }
    });

    testWidgets('keeps section gaps aligned to sectionGap token', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpProfileScreen(
        tester,
        width: 360,
        textScale: 1.0,
        locale: const Locale('ko'),
      );

      final spec = ProfileLayoutSpec.fromValues(width: 360, textScale: 1.0);
      final idRect = tester.getRect(find.byKey(const Key('profile_id_card')));
      final editRect = tester.getRect(
        find.byKey(const Key('profile_edit_section')),
      );
      final rankRect = tester.getRect(
        find.byKey(const Key('profile_rank_section')),
      );
      final statsRect = tester.getRect(
        find.byKey(const Key('profile_stats_grid')),
      );

      expectCloseToToken(
        editRect.top - idRect.bottom,
        spec.sectionGap,
        reason: 'ID card -> edit section gap must match sectionGap',
      );
      expectCloseToToken(
        rankRect.top - editRect.bottom,
        spec.sectionGap,
        reason: 'Edit section -> rank section gap must match sectionGap',
      );
      expectCloseToToken(
        statsRect.top - rankRect.bottom,
        spec.sectionGap,
        reason: 'Rank section -> stats grid gap must match sectionGap',
      );
    });

    testWidgets('applies internal spacing tokens within tolerance', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpProfileScreen(
        tester,
        width: 360,
        textScale: 1.0,
        locale: const Locale('ko'),
      );

      final spec = ProfileLayoutSpec.fromValues(width: 360, textScale: 1.0);

      final nameLabelRect = tester.getRect(
        find.byKey(const Key('profile_id_name_label')),
      );
      final nameValueRect = tester.getRect(
        find.byKey(const Key('profile_id_name_value')),
      );
      expectCloseToToken(
        nameValueRect.top - nameLabelRect.bottom,
        spec.microGap,
        reason: 'ID card label -> value gap must match microGap',
      );

      final editTitleRect = tester.getRect(
        find.byKey(const Key('profile_edit_name_row')),
      );
      final avatarTitleRect = tester.getRect(
        find.byKey(const Key('profile_avatar_title_row')),
      );
      expectCloseToToken(
        avatarTitleRect.top - editTitleRect.bottom,
        spec.clusterGap,
        reason: 'Edit title row -> avatar title row gap must match clusterGap',
      );

      final rankBarRect = tester.getRect(
        find.byKey(const Key('profile_rank_bar')),
      );
      final rankNextRect = tester.getRect(
        find.byKey(const Key('profile_rank_next_text')),
      );
      expectCloseToToken(
        rankNextRect.top - rankBarRect.bottom,
        spec.microGap * 2,
        reason: 'Rank bar -> helper text gap must match microGap*2',
      );
    });

    testWidgets('keeps avatar option and name edit button at least 48dp', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpProfileScreen(
        tester,
        width: 320,
        textScale: 1.3,
        locale: const Locale('ko'),
      );

      final editButtonSize = tester.getSize(
        find.byKey(const Key('profile_name_edit_button')),
      );
      final firstAvatarSize = tester.getSize(
        find.byKey(const ValueKey<String>('profile_avatar_option_0')),
      );

      expect(editButtonSize.width, greaterThanOrEqualTo(48));
      expect(editButtonSize.height, greaterThanOrEqualTo(48));
      expect(firstAvatarSize.width, greaterThanOrEqualTo(48));
      expect(firstAvatarSize.height, greaterThanOrEqualTo(48));
    });
  });
}

class _FakeUserProgressRepository implements UserProgressRepository {
  UserProgress? _progress;

  _FakeUserProgressRepository(UserProgress initialProgress)
    : _progress = initialProgress;

  @override
  Future<UserProgress?> getUserProgress(String userId) async => _progress;

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    _progress = progress;
  }
}

class _FakeSettingsRepository implements SettingsRepository {
  GameSettings _settings;

  _FakeSettingsRepository(this._settings);

  @override
  Future<GameSettings> getSettings() async => _settings;

  @override
  Future<void> saveSettings(GameSettings settings) async {
    _settings = settings;
  }
}
