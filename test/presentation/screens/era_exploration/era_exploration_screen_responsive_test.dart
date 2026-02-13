import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/constants/era_theme_ids.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/era_exploration/era_exploration_screen.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_hud_panel.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/location_story_card.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

void main() {
  const widths = <double>[320, 360, 390, 412, 600, 900];
  const textScales = <double>[1.0, 1.15, 1.3, 1.6];
  const locales = <Locale>[Locale('ko'), Locale('en')];
  const eraId = 'korea_three_kingdoms';

  final era = const Era(
    id: eraId,
    countryId: 'korea',
    name: 'Three Kingdoms',
    nameKorean: '삼국시대',
    period: '57 BC - 668 AD',
    startYear: -57,
    endYear: 668,
    description: 'Era description',
    thumbnailAsset: 'assets/images/locations/three_kingdoms_bg.png',
    backgroundAsset: 'assets/images/locations/three_kingdoms_bg.png',
    bgmAsset: 'assets/audio/bgm/era_three_kingdoms.mp3',
    themeId: EraThemeIds.threeKingdoms,
    chapterIds: <String>[],
    characterIds: <String>[],
    locationIds: <String>[],
    status: ContentStatus.available,
    progress: 0.13,
  );

  final locations = List<Location>.generate(6, (index) {
    final order = index + 1;
    return Location(
      id: 'goguryeo_location_$order',
      eraId: eraId,
      name: 'Long Location Name $order for Responsive Validation',
      nameKorean: '반응형 검증용 긴 장소 이름 $order',
      description: '기본 설명 $order',
      thumbnailAsset: 'assets/images/locations/gungnaeseong_bg.png',
      backgroundAsset: 'assets/images/locations/gungnaeseong_bg.png',
      kingdom: 'goguryeo',
      displayYear: 'AD ${420 + order}',
      timelineOrder: order,
      position: const MapCoordinates(x: 0.5, y: 0.5),
      status: ContentStatus.available,
    );
  });

  UserProgress buildProgress() {
    return const UserProgress(
      userId: 'tester',
      hasCompletedTutorial: true,
      eraProgress: <String, double>{eraId: 0.13},
    );
  }

  Widget buildApp({
    required double width,
    required double textScale,
    required Locale locale,
  }) {
    return ProviderScope(
      overrides: [
        eraByIdProvider.overrideWith((ref, _) async => era),
        locationListByEraProvider.overrideWith((ref, _) async => locations),
        locationI18nContentProvider.overrideWith((ref, localeCode) async {
          return <String, dynamic>{
            for (final location in locations)
              location.id: <String, dynamic>{
                'description': localeCode == 'en'
                    ? 'Long localized description for responsive validation at '
                          '${location.id} and large text scale mode.'
                    : '큰 글꼴과 작은 화면에서도 잘림 없이 표시되는 반응형 검증용 긴 설명 문장 ${location.id}',
              },
          };
        }),
        userProgressRepositoryProvider.overrideWithValue(
          _FakeUserProgressRepository(buildProgress()),
        ),
        currentBgmTrackProvider.overrideWith(
          (ref) => AudioConstants.getBGMForEra(eraId),
        ),
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
          home: const EraExplorationScreen(eraId: eraId),
        ),
      ),
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    required double width,
    required double textScale,
    required Locale locale,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 900));
    await tester.pumpWidget(
      buildApp(width: width, textScale: textScale, locale: locale),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 200));
  }

  group('EraExplorationScreen responsive layout', () {
    testWidgets('keeps last card description fully visible above HUD', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final width in widths) {
        for (final textScale in textScales) {
          for (final locale in locales) {
            await pumpScreen(
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

            expect(find.byType(EraHudPanel), findsOneWidget);
            expect(find.byType(LocationStoryCard), findsWidgets);
            expect(
              find.byKey(const ValueKey<String>('location_story_bottom_scrim')),
              findsWidgets,
            );
            expect(
              find.byKey(const ValueKey<String>('location_story_text_overlay')),
              findsWidgets,
            );

            final listFinder = find.byType(ListView);
            expect(listFinder, findsOneWidget);

            for (var i = 0; i < 4; i++) {
              await tester.drag(listFinder, const Offset(0, -700));
              await tester.pump(const Duration(milliseconds: 120));
            }

            final descriptionFinder = find.byKey(
              const ValueKey<String>('location_story_description'),
            );
            expect(descriptionFinder, findsWidgets);

            final lastDescriptionRect = tester.getRect(descriptionFinder.last);
            final lastCardRect = tester.getRect(
              find.byType(LocationStoryCard).last,
            );
            final hudRect = tester.getRect(find.byType(EraHudPanel));

            expect(
              lastDescriptionRect.bottom <= lastCardRect.bottom,
              isTrue,
              reason:
                  'Description text escaped card bounds at width=$width, scale=$textScale, locale=${locale.languageCode}',
            );
            expect(
              lastDescriptionRect.bottom <= hudRect.top,
              isTrue,
              reason:
                  'Last description is hidden behind HUD at width=$width, scale=$textScale, locale=${locale.languageCode}',
            );

            final hudContext = tester.element(find.byType(EraHudPanel));
            final l10n = AppLocalizations.of(hudContext)!;
            final progressLabel = tester.widget<Text>(
              find.text(l10n.exploration_tab_progress),
            );
            final characterLabel = tester.widget<Text>(
              find.text(l10n.exploration_list_characters),
            );

            expect(progressLabel.maxLines, 1);
            expect(progressLabel.overflow, TextOverflow.ellipsis);
            expect(characterLabel.maxLines, 1);
            expect(characterLabel.overflow, TextOverflow.ellipsis);

            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Post-scroll exception at width=$width, scale=$textScale, locale=${locale.languageCode}',
            );

            await tester.pump(const Duration(milliseconds: 700));
          }
        }
      }

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 700));
    });
  });
}

class _FakeUserProgressRepository implements UserProgressRepository {
  UserProgress _current;

  _FakeUserProgressRepository(this._current);

  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    return _current;
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    _current = progress;
  }
}
