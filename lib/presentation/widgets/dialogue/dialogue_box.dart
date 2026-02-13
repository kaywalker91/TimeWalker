import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/dialogue/dialogue_choice.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/screens/dialogue/dialogue_view_model.dart';
import 'package:time_walker/presentation/widgets/dialogue/blinking_cursor.dart';
import 'package:time_walker/presentation/widgets/dialogue/dialogue_choices_panel.dart';

/// 대화 박스 위젯
///
/// 대화 화면 하단에 표시되는 대화 내용 박스입니다.
/// 화자 이름, 대화 텍스트, 진행 커서를 표시합니다.
class DialogueBox extends StatefulWidget {
  /// 대화 상태
  final DialogueState state;

  /// 화자 이름
  final String speakerName;

  /// 다음으로 진행 콜백
  final VoidCallback onNext;

  /// 선택지 선택 콜백 (선택지가 있을 경우)
  final void Function(DialogueChoice)? onChoiceSelected;

  /// 사용자 진행 상태 (선택지 해금 조건 확인용)
  final UserProgress? userProgress;

  /// 박스 높이 (기본: 반응형)
  final double? height;

  const DialogueBox({
    super.key,
    required this.state,
    required this.speakerName,
    required this.onNext,
    this.onChoiceSelected,
    this.userProgress,
    this.height,
  });

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  static const double _scrollTolerance = 0.5;
  static const Key _choiceHintSlotKey = Key('dialogue_choice_scroll_hint_slot');
  static const Key _choiceHintIconKey = Key('dialogue_choice_scroll_hint_icon');

  final ScrollController _textScrollController = ScrollController();
  final ScrollController _choiceScrollController = ScrollController();
  bool _isChoiceListOverflowing = false;
  bool _canScrollChoiceListDown = false;

  @override
  void initState() {
    super.initState();
    _choiceScrollController.addListener(_handleChoiceScroll);
    final initialNode = widget.state.currentNode;
    if ((initialNode?.hasChoices ?? false) && !widget.state.isTyping) {
      _syncChoiceScrollState(resetToTop: true);
    }
  }

  @override
  void didUpdateWidget(covariant DialogueBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentNode = widget.state.currentNode;
    final oldNode = oldWidget.state.currentNode;
    final hasChoices = currentNode?.hasChoices ?? false;
    final nodeChanged = currentNode?.id != oldNode?.id;
    final choiceCountChanged =
        currentNode?.choices.length != oldNode?.choices.length;
    final becameChoiceNode = hasChoices && !(oldNode?.hasChoices ?? false);
    final choicesBecameVisible =
        hasChoices && !widget.state.isTyping && oldWidget.state.isTyping;

    if (!hasChoices &&
        widget.state.displayedText != oldWidget.state.displayedText) {
      _scrollTextToBottom();
    }

    if (hasChoices &&
        !widget.state.isTyping &&
        (nodeChanged ||
            choiceCountChanged ||
            becameChoiceNode ||
            choicesBecameVisible)) {
      _syncChoiceScrollState(resetToTop: true);
      return;
    }

    if (!hasChoices || widget.state.isTyping) {
      _setChoiceScrollState(isOverflowing: false, canScrollDown: false);
    }
  }

  void _scrollTextToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_textScrollController.hasClients) {
        return;
      }
      _textScrollController.jumpTo(
        _textScrollController.position.maxScrollExtent,
      );
    });
  }

  void _syncChoiceScrollState({required bool resetToTop}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (!_choiceScrollController.hasClients) {
        _setChoiceScrollState(isOverflowing: false, canScrollDown: false);
        return;
      }

      if (resetToTop) {
        _choiceScrollController.jumpTo(0);
      }

      _updateChoiceScrollState();
    });
  }

  void _handleChoiceScroll() {
    _updateChoiceScrollState();
  }

  void _updateChoiceScrollState() {
    if (!_choiceScrollController.hasClients) {
      _setChoiceScrollState(isOverflowing: false, canScrollDown: false);
      return;
    }

    final position = _choiceScrollController.position;
    final hasOverflow = position.maxScrollExtent > 0;
    final canScrollDown =
        hasOverflow &&
        position.pixels < (position.maxScrollExtent - _scrollTolerance);

    _setChoiceScrollState(
      isOverflowing: hasOverflow,
      canScrollDown: canScrollDown,
    );
  }

  void _setChoiceScrollState({
    required bool isOverflowing,
    required bool canScrollDown,
  }) {
    if (!mounted) {
      return;
    }

    if (_isChoiceListOverflowing == isOverflowing &&
        _canScrollChoiceListDown == canScrollDown) {
      return;
    }

    setState(() {
      _isChoiceListOverflowing = isOverflowing;
      _canScrollChoiceListDown = canScrollDown;
    });
  }

  @override
  void dispose() {
    _choiceScrollController.removeListener(_handleChoiceScroll);
    _textScrollController.dispose();
    _choiceScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentNode = widget.state.currentNode!;
    final hasChoices = currentNode.hasChoices;
    final showChoiceList = hasChoices && !widget.state.isTyping;
    final showChoiceScrollHint =
        showChoiceList && _isChoiceListOverflowing && _canScrollChoiceListDown;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final responsive = context.responsive;

    // Responsive sizing
    final boxHeight =
        widget.height ?? (responsive.isSmallPhone ? 280.0 : 330.0);
    final speakerFontSize = responsive.fontSize(18);
    final textFontSize = responsive.fontSize(16);
    final horizontalPadding = responsive.padding(24);
    final hintColor = AppColors.dialogueTextSecondary.withValues(alpha: 0.78);

    return GestureDetector(
      onTap: widget.onNext,
      child: Container(
        height: boxHeight + bottomPadding,
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          24,
          horizontalPadding,
          16 + bottomPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.dialogueBackground.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.dialogueBorder)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker Name
            Text(
              widget.speakerName,
              style: TextStyle(
                color: AppColors.dialogueSpeakerName,
                fontSize: speakerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacing(16)),

            // Content Area (Text or Choices)
            Expanded(
              child: showChoiceList
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _choiceScrollController,
                            child: DialogueChoicesPanel(
                              choices: currentNode.choices,
                              userProgress: widget.userProgress,
                              onChoiceSelected: (choice) {
                                widget.onChoiceSelected?.call(choice);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          key: _choiceHintSlotKey,
                          height: 22,
                          child: IgnorePointer(
                            child: Center(
                              child: showChoiceScrollHint
                                  ? Semantics(
                                      label: l10n
                                          .dialogue_choices_scroll_hint_more,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        key: _choiceHintIconKey,
                                        color: hintColor,
                                        size: 18,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      controller: _textScrollController,
                      child: Text(
                        widget.state.displayedText,
                        style: TextStyle(
                          color: AppColors.dialogueText,
                          fontSize: textFontSize,
                          height: 1.6,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ),
            ),

            // Choices or Next Indicator
            if (!widget.state.isTyping && !hasChoices)
              const Align(
                alignment: Alignment.bottomRight,
                child: BlinkingCursor(),
              ),
          ],
        ),
      ),
    );
  }
}
