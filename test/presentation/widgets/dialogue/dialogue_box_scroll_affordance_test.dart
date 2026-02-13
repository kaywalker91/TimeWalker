import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/dialogue.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/screens/dialogue/dialogue_view_model.dart';
import 'package:time_walker/presentation/widgets/dialogue/dialogue_box.dart';

void main() {
  const hintSlotKey = Key('dialogue_choice_scroll_hint_slot');
  const hintIconKey = Key('dialogue_choice_scroll_hint_icon');

  DialogueNode buildNarrationNode() {
    return const DialogueNode(
      id: 'narration_node',
      speakerId: 'npc',
      text: '긴 대사',
    );
  }

  DialogueNode buildChoiceNode({required int choiceCount}) {
    return DialogueNode(
      id: 'choice_node',
      speakerId: 'npc',
      text: '어떤 선택을 하시겠습니까?',
      choices: List<DialogueChoice>.generate(
        choiceCount,
        (index) => DialogueChoice(
          id: 'choice_$index',
          text: '선택지 ${index + 1}: 매우 긴 문장으로 구성된 테스트 선택지입니다.',
          nextNodeId: 'next_$index',
        ),
      ),
    );
  }

  DialogueState buildNarrationState() {
    return DialogueState(
      currentNode: buildNarrationNode(),
      displayedText: List<String>.generate(
        48,
        (index) => '긴 대사 라인 ${index + 1}',
      ).join('\n'),
      isTyping: false,
    );
  }

  Widget buildTestApp({
    required DialogueState state,
    required double width,
    double textScale = 1.0,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: Size(width, 800),
        textScaler: TextScaler.linear(textScale),
      ),
      child: MaterialApp(
        locale: const Locale('ko'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: DialogueBox(
              state: state,
              speakerName: '테스트 화자',
              onNext: () {},
              onChoiceSelected: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  group('DialogueBox scroll affordance', () {
    testWidgets(
      'keeps first choice visible when switching from long narration',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(360, 800));

        var state = buildNarrationState();
        await tester.pumpWidget(buildTestApp(state: state, width: 360));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));

        final scrollableFinder = find.descendant(
          of: find.byType(DialogueBox),
          matching: find.byType(SingleChildScrollView),
        );
        await tester.drag(scrollableFinder.first, const Offset(0, -500));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));

        state = DialogueState(
          currentNode: buildChoiceNode(choiceCount: 8),
          displayedText: '',
          isTyping: false,
        );
        await tester.pumpWidget(buildTestApp(state: state, width: 360));
        await tester.pump();
        await tester.pump();

        final firstChoiceText = find.text('선택지 1: 매우 긴 문장으로 구성된 테스트 선택지입니다.');
        expect(firstChoiceText, findsOneWidget);

        final firstChoiceTop = tester.getTopLeft(firstChoiceText).dy;
        final boxTop = tester.getTopLeft(find.byType(DialogueBox)).dy;
        expect(firstChoiceTop, greaterThan(boxTop + 40));
      },
    );

    testWidgets('shows choices only after typing is completed', (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(360, 800));

      var state = DialogueState(
        currentNode: buildChoiceNode(choiceCount: 5),
        displayedText: '어떤 선택을 하시겠습니까',
        isTyping: true,
      );
      await tester.pumpWidget(buildTestApp(state: state, width: 360));
      await tester.pump();

      expect(find.text('선택지 1: 매우 긴 문장으로 구성된 테스트 선택지입니다.'), findsNothing);

      state = state.copyWith(displayedText: '어떤 선택을 하시겠습니까?', isTyping: false);
      await tester.pumpWidget(buildTestApp(state: state, width: 360));
      await tester.pump();
      await tester.pump();

      expect(find.text('선택지 1: 매우 긴 문장으로 구성된 테스트 선택지입니다.'), findsOneWidget);
    });

    testWidgets(
      'shows and hides scroll hint based on overflow and scroll position',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(360, 800));

        final state = DialogueState(
          currentNode: buildChoiceNode(choiceCount: 8),
          displayedText: '',
          isTyping: false,
        );
        await tester.pumpWidget(buildTestApp(state: state, width: 360));
        await tester.pump();
        await tester.pump();

        expect(find.byKey(hintSlotKey), findsOneWidget);
        expect(find.byKey(hintIconKey), findsOneWidget);

        final icon = tester.widget<Icon>(find.byKey(hintIconKey));
        expect(
          icon.color?.toARGB32(),
          AppColors.dialogueTextSecondary.withValues(alpha: 0.78).toARGB32(),
        );

        final hintInsideScrollable = find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byKey(hintIconKey),
        );
        expect(hintInsideScrollable, findsNothing);

        final scrollableFinder = find.descendant(
          of: find.byType(DialogueBox),
          matching: find.byType(SingleChildScrollView),
        );
        await tester.drag(scrollableFinder.first, const Offset(0, -1200));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 160));

        expect(find.byKey(hintSlotKey), findsOneWidget);
        expect(find.byKey(hintIconKey), findsNothing);
      },
    );

    testWidgets('does not show scroll hint when choices do not overflow', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(360, 800));

      final state = DialogueState(
        currentNode: buildChoiceNode(choiceCount: 2),
        displayedText: '',
        isTyping: false,
      );
      await tester.pumpWidget(buildTestApp(state: state, width: 360));
      await tester.pump();
      await tester.pump();

      expect(find.byKey(hintSlotKey), findsOneWidget);
      expect(find.byKey(hintIconKey), findsNothing);
    });

    testWidgets('remains stable on small widths and text scale 1.3', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const widths = <double>[320, 360, 412];

      for (final width in widths) {
        await tester.binding.setSurfaceSize(Size(width, 800));
        final state = DialogueState(
          currentNode: buildChoiceNode(choiceCount: 8),
          displayedText: '',
          isTyping: false,
        );
        await tester.pumpWidget(
          buildTestApp(state: state, width: width, textScale: 1.3),
        );
        await tester.pump();
        await tester.pump();

        expect(
          tester.takeException(),
          isNull,
          reason: 'Unexpected exception at width=$width and textScale=1.3',
        );
      }
    });
  });
}
