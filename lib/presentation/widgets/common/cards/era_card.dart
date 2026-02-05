import 'package:flutter/material.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';
import 'package:time_walker/presentation/widgets/common/cards/base_time_card.dart';

/// 타임라인 시대 카드 위젯
/// 
/// 시대 타임라인 화면에서 사용되는 수평 스크롤 카드입니다.
/// 시대별 테마 색상이 적용되며, 잠금/해금 상태를 표시합니다.
class TimelineEraCard extends StatefulWidget {
  /// 표시할 시대
  final Era era;
  
  /// 사용자 진행도 (해금 상태 확인용)
  final UserProgress? userProgress;
  
  /// 전체 시대 목록 (잠금 해제 조건 표시용)
  final List<Era> allEras;
  
  /// 카드 너비 (기본: 280)
  final double width;
  
  /// 카드 높이 (기본: null - 자동)
  final double? height;

  const TimelineEraCard({
    super.key,
    required this.era,
    this.userProgress,
    required this.allEras,
    this.width = 280,
    this.height,
  });

  @override
  State<TimelineEraCard> createState() => _TimelineEraCardState();
}

class _TimelineEraCardState extends State<TimelineEraCard> with TimeCardMixin, ThemedCardMixin {
  @override
  bool get isLocked => !_isUnlocked;
  
  bool get _isUnlocked =>
      widget.userProgress?.unlockedEraIds.contains(widget.era.id) ?? false;
  
  @override
  Color get themeColor => widget.era.theme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return buildHoverRegion(
      child: buildPressDetector(
        onTap: () => _handleTap(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          margin: const EdgeInsets.only(right: 24),
          transform: pressTransform,
          decoration: isLocked
              ? _buildLockedDecoration()
              : _buildUnlockedDecoration(),
          child: Stack(
            children: [
              // 카드 내용
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Era Title
                    Text(
                      widget.era.nameKorean,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: isLocked ? AppColors.textDisabled : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Period
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLocked 
                            ? AppColors.surface 
                            : themeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isLocked 
                              ? AppColors.border 
                              : themeColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.era.period,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isLocked ? AppColors.textDisabled : themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Description
                    Text(
                      widget.era.description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isLocked ? AppColors.textDisabled : AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),

                    // Action Button
                    _buildActionButton(context),
                  ],
                ),
              ),
              
              // 잠금 오버레이
              if (isLocked) _buildLockOverlay(),
            ],
          ),
        ),
      ),
    );
  }
  
  BoxDecoration _buildUnlockedDecoration() {
    return BoxDecoration(
      gradient: AppGradients.card,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isHovered 
            ? themeColor 
            : themeColor.withValues(alpha: 0.7),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: themeColor.withValues(alpha: isHovered ? 0.4 : 0.3),
          blurRadius: isHovered ? 24 : 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
  
  BoxDecoration _buildLockedDecoration() {
    return BoxDecoration(
      color: AppColors.surface.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: AppColors.border.withValues(alpha: 0.3),
        width: 2,
      ),
    );
  }
  
  Widget _buildLockOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.lock_outline,
              color: AppColors.textDisabled,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        height: 48,
        decoration: isLocked
            ? BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              )
            : BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeColor,
                    themeColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
        child: Center(
          child: Text(
            isLocked
                ? AppLocalizations.of(context)!.common_locked
                : AppLocalizations.of(context)!.common_explore,
            style: AppTextStyles.labelLarge.copyWith(
              color: isLocked ? AppColors.textDisabled : AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  
  void _handleTap(BuildContext context) {
    if (isLocked) {
      String msg = AppLocalizations.of(context)!.era_timeline_locked_msg;
      final condition = widget.era.unlockCondition;
      
      if (condition.previousEraId != null) {
        final prev = widget.allEras.where((e) => e.id == condition.previousEraId).firstOrNull;
        if (prev != null) {
          final pct = (condition.requiredProgress * 100).toInt();
          msg = '${prev.nameKorean} 진행도 $pct% 달성 시 해금';
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.warning.withValues(alpha: 0.9),
        ),
      );
    } else {
      AppRouter.goToEraExploration(context, widget.era.id);
    }
  }
}
