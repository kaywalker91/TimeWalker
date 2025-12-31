import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/presentation/screens/dialogue/dialogue_view_model.dart';
import 'package:time_walker/presentation/widgets/dialogue/blinking_cursor.dart';

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
  
  /// 박스 높이 (기본: 반응형)
  final double? height;

  const DialogueBox({
    super.key,
    required this.state,
    required this.speakerName,
    required this.onNext,
    this.height,
  });

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant DialogueBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.displayedText != oldWidget.state.displayedText) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentNode = widget.state.currentNode!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final responsive = context.responsive;
    
    // Responsive sizing
    final boxHeight = widget.height ?? (responsive.isSmallPhone ? 200.0 : 250.0);
    final speakerFontSize = responsive.fontSize(18);
    final textFontSize = responsive.fontSize(16);
    final horizontalPadding = responsive.padding(24);

    return GestureDetector(
      onTap: widget.onNext,
      child: Container(
        height: boxHeight + bottomPadding,
        padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 16 + bottomPadding),
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

            // Text Content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
            if (!widget.state.isTyping && !currentNode.hasChoices)
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
