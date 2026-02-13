import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_exploration_layout_spec.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/enhanced_kingdom_tabs.dart';

void main() {
  const widths = <double>[320, 360, 390, 412, 600, 900];
  const textScales = <double>[1.0, 1.15, 1.3, 1.6];
  const locales = <Locale>[Locale('ko'), Locale('en')];

  Widget buildTestApp({
    required double width,
    required double textScale,
    required Locale locale,
  }) {
    final locationCounts = <String, int>{
      for (final kingdom in ThreeKingdomsTabs.kingdoms) kingdom.id: 3,
    };
    final layoutSpec = EraExplorationLayoutSpec.fromValues(
      width: width,
      textScale: textScale,
    );

    return MediaQuery(
      data: MediaQueryData(
        size: Size(width, 900),
        textScaler: TextScaler.linear(textScale),
      ),
      child: MaterialApp(
        locale: locale,
        home: Scaffold(
          body: _KingdomTabsHarness(
            locationCounts: locationCounts,
            layoutSpec: layoutSpec,
          ),
        ),
      ),
    );
  }

  group('EnhancedKingdomTabs layout matrix', () {
    testWidgets('keeps tab labels single-line and stable across matrix', (
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
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 80));

            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Unexpected exception at width=$width, scale=$textScale, locale=${locale.languageCode}',
            );

            for (final kingdom in ThreeKingdomsTabs.kingdoms) {
              final labelFinder = find.text(kingdom.label);
              expect(labelFinder, findsOneWidget);

              final labelText = tester.widget<Text>(labelFinder);
              expect(labelText.maxLines, 1);
              expect(labelText.overflow, TextOverflow.ellipsis);
            }

            final minHeightTabs = find.descendant(
              of: find.byType(EnhancedKingdomTabs),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is AnimatedContainer &&
                    widget.constraints != null &&
                    widget.constraints!.minHeight >= 48,
              ),
            );
            expect(
              minHeightTabs,
              findsNWidgets(ThreeKingdomsTabs.kingdoms.length),
            );
          }
        }
      }
    });
  });
}

class _KingdomTabsHarness extends StatefulWidget {
  final Map<String, int> locationCounts;
  final EraExplorationLayoutSpec layoutSpec;

  const _KingdomTabsHarness({
    required this.locationCounts,
    required this.layoutSpec,
  });

  @override
  State<_KingdomTabsHarness> createState() => _KingdomTabsHarnessState();
}

class _KingdomTabsHarnessState extends State<_KingdomTabsHarness>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: ThreeKingdomsTabs.kingdoms.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedKingdomTabs(
      controller: _controller,
      eraAccentColor: AppColors.primary,
      locationCounts: widget.locationCounts,
      layoutSpec: widget.layoutSpec,
    );
  }
}
