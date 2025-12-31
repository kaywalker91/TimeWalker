import 'package:flutter/material.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/presentation/widgets/common/cards/base_time_card.dart';

/// 도감 항목 카드 위젯
/// 
/// 도감 화면에서 사용되는 그리드 카드입니다.
/// 해금/잠금 상태에 따라 다른 UI를 표시합니다.
class EncyclopediaEntryCard extends StatefulWidget {
  /// 표시할 도감 항목
  final EncyclopediaEntry entry;
  
  /// 해금 상태
  final bool isUnlocked;
  
  /// 반응형 유틸리티 (폰트, 패딩 크기 계산)
  final ResponsiveUtils responsive;
  
  /// 커스텀 탭 핸들러
  final VoidCallback? onTap;
  
  /// 잠금 상태 메시지
  final String? lockedMessage;

  const EncyclopediaEntryCard({
    super.key,
    required this.entry,
    required this.isUnlocked,
    required this.responsive,
    this.onTap,
    this.lockedMessage,
  });

  @override
  State<EncyclopediaEntryCard> createState() => _EncyclopediaEntryCardState();
}

class _EncyclopediaEntryCardState extends State<EncyclopediaEntryCard> 
    with TimeCardMixin {
  @override
  bool get isLocked => !widget.isUnlocked;
  
  @override
  Widget build(BuildContext context) {
    final titleFontSize = widget.responsive.fontSize(16);
    final badgeFontSize = widget.responsive.fontSize(10);
    final summaryFontSize = widget.responsive.fontSize(11);
    final iconSize = widget.responsive.iconSize(40);
    final cardPadding = widget.responsive.padding(12);
    
    return buildHoverRegion(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: isHovered && widget.isUnlocked
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            gradient: widget.isUnlocked 
                ? AppGradients.card 
                : null,
            color: widget.isUnlocked ? null : AppColors.surface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isUnlocked 
                  ? (isHovered ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3))
                  : AppColors.border.withValues(alpha: 0.3),
              width: widget.isUnlocked ? 2 : 1,
            ),
            boxShadow: widget.isUnlocked
                ? (isHovered ? AppShadows.goldenGlowMd : AppShadows.card)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image / Icon
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: AppColors.background.withValues(alpha: 0.5),
                  ),
                  child: widget.isUnlocked
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            widget.entry.thumbnailAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Center(
                              child: Icon(Icons.image_not_supported, color: AppColors.textDisabled, size: iconSize),
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock,
                              color: AppColors.textDisabled,
                              size: iconSize * 0.7,
                            ),
                          ),
                        ),
                ),
              ),
              // Text Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.responsive.padding(6),
                              vertical: widget.responsive.padding(2),
                            ),
                            decoration: BoxDecoration(
                              color: widget.isUnlocked 
                                  ? AppColors.primary.withValues(alpha: 0.15) 
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: widget.isUnlocked 
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : AppColors.border.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              widget.entry.type.displayName,
                              style: TextStyle(
                                color: widget.isUnlocked ? AppColors.primary : AppColors.textDisabled,
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: widget.responsive.spacing(6)),
                          Text(
                            widget.isUnlocked ? widget.entry.titleKorean : '???',
                            style: TextStyle(
                              color: widget.isUnlocked ? AppColors.textPrimary : AppColors.textDisabled,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      if (widget.isUnlocked)
                        Flexible(
                          child: Text(
                            widget.entry.summary,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: summaryFontSize,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    
    if (widget.isUnlocked) {
      AppRouter.goToEncyclopediaEntry(context, widget.entry.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.lockedMessage ?? '이 항목은 아직 발견되지 않았습니다! 더 탐험해보세요.'),
          backgroundColor: AppColors.warning.withValues(alpha: 0.9),
        ),
      );
    }
  }
}
