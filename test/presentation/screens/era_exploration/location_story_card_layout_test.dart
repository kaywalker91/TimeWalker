import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_exploration_layout_spec.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/location_story_card.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

void main() {
  const widths = <double>[320, 360, 390, 412, 600, 900];
  const textScales = <double>[1.0, 1.15, 1.3, 1.6];
  const locales = <Locale>[Locale('ko'), Locale('en')];

  Location buildLocation() {
    return const Location(
      id: 'test_location',
      eraId: 'korea_three_kingdoms',
      name: 'Cheomseongdae Observatory With Extra Long Name',
      nameKorean: '첨성대 천문 관측소 긴 이름 테스트',
      description: '기본 설명 텍스트',
      thumbnailAsset: 'assets/images/locations/cheomseongdae_bg.png',
      backgroundAsset: 'assets/images/locations/cheomseongdae_bg.png',
      kingdom: 'silla',
      displayYear: 'AD 632',
      position: MapCoordinates(x: 0.5, y: 0.5),
      status: ContentStatus.available,
    );
  }

  Widget buildTestApp({
    required double width,
    required double textScale,
    required Locale locale,
  }) {
    final location = buildLocation();
    final layoutSpec = EraExplorationLayoutSpec.fromValues(
      width: width,
      textScale: textScale,
    );
    return ProviderScope(
      overrides: [
        locationI18nContentProvider.overrideWith((ref, localeCode) async {
          final description = localeCode == 'en'
              ? 'A long English description for layout stability testing in'
                    ' compact card mode.'
              : '좁은 카드 폭에서 텍스트 겹침 없이 표시되는지 확인하기 위한 긴 설명 문장입니다.';
          return <String, dynamic>{
            location.id: <String, dynamic>{'description': description},
          };
        }),
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
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: width - 24,
                child: LocationStoryCard(
                  location: location,
                  accentColor: Colors.green,
                  kingdomLabel: '신라',
                  layoutSpec: layoutSpec,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('LocationStoryCard layout matrix', () {
    testWidgets('keeps text separated from year/status badges across matrix', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final width in widths) {
        for (final textScale in textScales) {
          for (final locale in locales) {
            await tester.binding.setSurfaceSize(Size(width, 900));
            await tester.pumpWidget(
              buildTestApp(width: width, textScale: textScale, locale: locale),
            );
            await tester.pumpAndSettle();

            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Unexpected exception at width=$width, scale=$textScale, locale=${locale.languageCode}',
            );

            final titleFinder = find.byKey(
              const ValueKey<String>('location_story_title'),
            );
            final descriptionFinder = find.byKey(
              const ValueKey<String>('location_story_description'),
            );
            final fullImageFinder = find.byKey(
              const ValueKey<String>('location_story_full_image'),
            );
            final bottomScrimFinder = find.byKey(
              const ValueKey<String>('location_story_bottom_scrim'),
            );
            final textOverlayFinder = find.byKey(
              const ValueKey<String>('location_story_text_overlay'),
            );
            final statusBadgeFinder = find.byKey(
              const ValueKey<String>('location_story_status_badge'),
            );
            final yearBadgeFinder = find.byKey(
              const ValueKey<String>('location_story_year_badge'),
            );

            expect(titleFinder, findsOneWidget);
            expect(descriptionFinder, findsOneWidget);
            expect(fullImageFinder, findsOneWidget);
            expect(bottomScrimFinder, findsOneWidget);
            expect(textOverlayFinder, findsOneWidget);
            expect(statusBadgeFinder, findsOneWidget);
            expect(yearBadgeFinder, findsOneWidget);

            final expectedMaxLines = EraExplorationLayoutSpec.fromValues(
              width: width,
              textScale: textScale,
            ).cardTitleMaxLines;
            final titleWidget = tester.widget<Text>(titleFinder);
            final descriptionWidget = tester.widget<Text>(descriptionFinder);

            expect(titleWidget.maxLines, expectedMaxLines);
            expect(titleWidget.overflow, TextOverflow.ellipsis);
            expect(descriptionWidget.maxLines, expectedMaxLines);
            expect(descriptionWidget.overflow, TextOverflow.ellipsis);

            final titleRect = tester.getRect(titleFinder);
            final descriptionRect = tester.getRect(descriptionFinder);
            final imageRect = tester.getRect(fullImageFinder);
            final statusRect = tester.getRect(statusBadgeFinder);
            final yearRect = tester.getRect(yearBadgeFinder);

            expect(
              titleRect.overlaps(statusRect),
              isFalse,
              reason: 'Title overlaps status badge',
            );
            expect(
              descriptionRect.overlaps(statusRect),
              isFalse,
              reason: 'Description overlaps status badge',
            );
            expect(
              titleRect.overlaps(yearRect),
              isFalse,
              reason: 'Title overlaps year badge',
            );
            expect(
              descriptionRect.overlaps(yearRect),
              isFalse,
              reason: 'Description overlaps year badge',
            );
            expect(
              titleRect.bottom <= imageRect.bottom,
              isTrue,
              reason: 'Title text escaped image/card bounds',
            );
            expect(
              descriptionRect.bottom <= imageRect.bottom,
              isTrue,
              reason: 'Description text escaped image/card bounds',
            );
          }
        }
      }
    });
  });
}
