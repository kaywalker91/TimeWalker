import 'package:flutter/material.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/services/country_unlock_rules.dart';
import 'package:time_walker/presentation/widgets/common/cards/base_time_card.dart';

/// 국가 카드 위젯
/// 
/// 지역 상세 화면에서 사용되는 수직 스크롤 카드입니다.
/// 국가 정보와 잠금/해금 상태를 표시합니다.
class CountryCard extends StatefulWidget {
  /// 표시할 국가
  final Country country;
  
  /// 소속 지역 (네비게이션용)
  final Region region;
  
  /// 사용자 진행도 (해금 상태 확인용)
  final UserProgress? userProgress;
  
  /// 커스텀 탭 핸들러 (기본: 시대 타임라인으로 이동)
  final VoidCallback? onTap;
  
  /// 잠금 상태 메시지
  final String? lockedMessage;

  const CountryCard({
    super.key,
    required this.country,
    required this.region,
    this.userProgress,
    this.onTap,
    this.lockedMessage,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> with TimeCardMixin {
  @override
  bool get isLocked => !_isUnlocked;

  bool get _isUnlocked =>
      widget.userProgress?.unlockedCountryIds.contains(widget.country.id) ??
      false;

  @override
  Widget build(BuildContext context) {
    final lockHint = isLocked ? _lockedHint(context) : null;

    return buildHoverRegion(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        transform: hoverTransform,
        decoration: BoxDecoration(
          gradient: isLocked ? null : AppGradients.card,
          color: isLocked ? AppColors.surface.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked
                ? AppColors.border.withValues(alpha: 0.3)
                : (isHovered ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5)),
            width: isLocked ? 1 : 2,
          ),
          boxShadow: isLocked
              ? null
              : (isHovered ? AppShadows.goldenGlowMd : AppShadows.card),
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => _handleTap(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Thumbnail
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isLocked
                          ? AppColors.surface
                          : AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isLocked
                            ? AppColors.border.withValues(alpha: 0.3)
                            : AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      isLocked ? Icons.lock : Icons.flag,
                      size: 40,
                      color: isLocked ? AppColors.textDisabled : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.country.nameKorean,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isLocked ? AppColors.textDisabled : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.country.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isLocked ? AppColors.textDisabled : AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (lockHint != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            lockHint,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Arrow
                  if (!isLocked)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary.withValues(alpha: 0.7),
                      size: 16,
                    ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    
    if (isLocked) {
      final message = _lockedHint(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.warning.withValues(alpha: 0.9),
        ),
      );
    } else {
      AppRouter.goToEraTimeline(context, widget.region.id, widget.country.id);
    }
  }

  String _lockedHint(BuildContext context) {
    if (widget.lockedMessage != null) {
      return widget.lockedMessage!;
    }

    final hint = CountryUnlockRules.hintFor(
      country: widget.country,
      region: widget.region,
    );
    if (hint != null) {
      return hint;
    }

    if (widget.region.unlockLevel > 0) {
      return '탐험가 레벨 ${widget.region.unlockLevel} 필요';
    }

    return '아시아 문명 진행도에 따라 해금';
  }
}
