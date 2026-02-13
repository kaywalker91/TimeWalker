import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/constants/era_theme_ids.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_exploration_layout_spec.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_hud_panel.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

void main() {
  const widths = <double>[320, 360, 390, 412, 600, 900];
  const textScales = <double>[1.0, 1.15, 1.3, 1.6];
  const locales = <Locale>[Locale('ko'), Locale('en')];

  Era buildEra() {
    return const Era(
      id: 'korea_three_kingdoms',
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
  }

  Location buildLocation() {
    return const Location(
      id: 'test_location',
      eraId: 'korea_three_kingdoms',
      name: 'Cheomseongdae',
      nameKorean: '첨성대',
      description: '설명',
      thumbnailAsset: 'assets/images/locations/cheomseongdae_bg.png',
      backgroundAsset: 'assets/images/locations/cheomseongdae_bg.png',
      position: MapCoordinates(x: 0.5, y: 0.5),
      status: ContentStatus.available,
    );
  }

  Widget buildTestApp({
    required double width,
    required double textScale,
    required Locale locale,
    required bool disableAnimations,
  }) {
    final layoutSpec = EraExplorationLayoutSpec.fromValues(
      width: width,
      textScale: textScale,
    );
    return ProviderScope(
      child: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 900),
          textScaler: TextScaler.linear(textScale),
          disableAnimations: disableAnimations,
        ),
        child: MaterialApp(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: width - 24,
                  child: EraHudPanel(
                    era: buildEra(),
                    locations: <Location>[buildLocation()],
                    layoutSpec: layoutSpec,
                    onShowLocations: () {},
                    onShowCharacters: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('EraHudPanel layout matrix', () {
    testWidgets('keeps one-line labels and no overflow exceptions', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final width in widths) {
        for (final textScale in textScales) {
          for (final locale in locales) {
            await tester.binding.setSurfaceSize(Size(width, 900));
            await tester.pumpWidget(
              buildTestApp(
                width: width,
                textScale: textScale,
                locale: locale,
                disableAnimations: false,
              ),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 50));

            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Unexpected exception at width=$width, scale=$textScale, locale=${locale.languageCode}',
            );

            final panelContext = tester.element(find.byType(EraHudPanel));
            final l10n = AppLocalizations.of(panelContext)!;

            final progressLabel = find.text(l10n.exploration_tab_progress);
            final charactersLabel = find.text(l10n.exploration_list_characters);

            expect(progressLabel, findsOneWidget);
            expect(charactersLabel, findsOneWidget);

            final progressText = tester.widget<Text>(progressLabel);
            final charactersText = tester.widget<Text>(charactersLabel);

            expect(progressText.maxLines, 1);
            expect(progressText.overflow, TextOverflow.ellipsis);
            expect(charactersText.maxLines, 1);
            expect(charactersText.overflow, TextOverflow.ellipsis);

            final minTouchContainers = find.descendant(
              of: find.byType(EraHudPanel),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container &&
                    widget.constraints != null &&
                    widget.constraints!.minHeight >= 48,
              ),
            );
            expect(minTouchContainers, findsAtLeastNWidgets(2));
          }
        }
      }
    });

    testWidgets('disables ink splash when reduce motion is on', (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        buildTestApp(
          width: 360,
          textScale: 1.0,
          locale: const Locale('ko'),
          disableAnimations: true,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final inkWells = tester
          .widgetList<InkWell>(
            find.descendant(
              of: find.byType(EraHudPanel),
              matching: find.byType(InkWell),
            ),
          )
          .toList();

      expect(inkWells.length, 2);
      for (final inkWell in inkWells) {
        expect(inkWell.splashFactory, NoSplash.splashFactory);
      }
    });
  });
}
