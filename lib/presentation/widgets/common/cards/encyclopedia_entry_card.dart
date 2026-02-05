import 'package:flutter/material.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/presentation/widgets/common/cards/base_time_card.dart';

/// 도감 항목 카드 위젯
/// 
/// "시간의 문" 테마 적용:
/// - Glassmorphism 효과
/// - 황금빛 그라데이션 테두리
/// - 신비로운 잠금 상태 표시
class EncyclopediaEntryCard extends StatefulWidget {
  final EncyclopediaEntry entry;
  final bool isUnlocked;
  final ResponsiveUtils responsive;
  final VoidCallback? onTap;
  final String? lockedMessage;
  final DateTime? discoveredAt;
  final String? characterPortraitAsset;

  const EncyclopediaEntryCard({
    super.key,
    required this.entry,
    required this.isUnlocked,
    required this.responsive,
    this.onTap,
    this.lockedMessage,
    this.discoveredAt,
    this.characterPortraitAsset,
  });

  @override
  State<EncyclopediaEntryCard> createState() => _EncyclopediaEntryCardState();
}

class _EncyclopediaEntryCardState extends State<EncyclopediaEntryCard> 
    with TimeCardMixin, SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  bool get isLocked => !widget.isUnlocked;

  @override
  void initState() {
    super.initState();
    // NEW 배지 펄스 애니메이션
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final titleFontSize = widget.responsive.fontSize(16);
    final summaryFontSize = widget.responsive.fontSize(11);
    final iconSize = widget.responsive.iconSize(40);
    final cardPadding = widget.responsive.padding(10);
    
    // 카드 전체 크기 효과 (Hover 시 Scale Up)
    return buildHoverRegion(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedScale(
          scale: isHovered && widget.isUnlocked ? 1.05 : 1.0,
          duration: AppAnimations.fast,
          curve: AppAnimations.spring,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.isUnlocked && isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : AppShadows.card,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // 1. 그라데이션 테두리 (Background Container)
                  // 해금된 경우: 황금빛 그라데이션 / 잠긴 경우: 어두운 단색
                  Container(
                    decoration: BoxDecoration(
                      gradient: widget.isUnlocked 
                          ? (isHovered ? AppGradients.goldenButton : AppGradients.goldenText)
                          : null,
                      color: widget.isUnlocked ? null : AppColors.border.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.all(1.5), // 테두리 두께
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface, // 내부 배경색 (이미지 뒤)
                        borderRadius: BorderRadius.circular(15), // 내부 radius (16 - 1)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 2. 이미지 영역 (상단)
                          Expanded(
                            flex: 4,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // 배경 (투명도 있는 어두운 색)
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.darkOverlay,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  ),
                                ),
                                
                                // 이미지
                                if (widget.isUnlocked)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Image.asset(
                                      _getImageAsset(),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Center(
                                        child: Icon(Icons.broken_image, 
                                          color: AppColors.textDisabled, 
                                          size: iconSize
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  // 잠금 상태 아이콘
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.lock_clock, // 시간의 문 테마에 맞춘 아이콘
                                          color: AppColors.textDisabled.withValues(alpha: 0.3),
                                          size: iconSize * 0.8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                // 이미지 하단 그라데이션 오버레이 (텍스트 가독성 + 자연스러운 연결)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  height: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.transparent,
                                          AppColors.surface.withValues(alpha: 0.8),
                                          AppColors.surface,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // 3. 텍스트 정보 영역 (하단)
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                              ),
                              padding: EdgeInsets.all(cardPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Type Label (Small & Sleek)
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: widget.isUnlocked 
                                                  ? AppColors.primary.withValues(alpha: 0.1)
                                                  : AppColors.surfaceLight,
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(
                                                color: widget.isUnlocked 
                                                    ? AppColors.primary.withValues(alpha: 0.3)
                                                    : AppColors.transparent,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Text(
                                              widget.entry.type.displayName,
                                              style: TextStyle(
                                                color: widget.isUnlocked ? AppColors.primary : AppColors.textDisabled,
                                                fontSize: widget.responsive.fontSize(9),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          // NEW Badge (Pulsing Dot)
                                          if (widget.isUnlocked && widget.discoveredAt != null && _isRecent(widget.discoveredAt!))
                                            AnimatedBuilder(
                                              animation: _pulseAnimation,
                                              builder: (context, child) {
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.success.withValues(alpha: 0.2 * _pulseAnimation.value),
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: AppColors.success.withValues(alpha: 0.6 * _pulseAnimation.value),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "NEW",
                                                    style: TextStyle(
                                                      fontSize: widget.responsive.fontSize(8),
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.success,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: widget.responsive.spacing(6)),
                                      
                                      // Title
                                      Text(
                                        widget.isUnlocked ? widget.entry.titleKorean : '???',
                                        style: TextStyle(
                                          color: widget.isUnlocked ? AppColors.textPrimary : AppColors.textDisabled,
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          shadows: widget.isUnlocked && isHovered ? [
                                            Shadow(
                                              color: AppColors.primary.withValues(alpha: 0.5),
                                              blurRadius: 8,
                                            )
                                          ] : null,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  
                                  // Summary / Date
                                  if (widget.isUnlocked)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.entry.summary,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: summaryFontSize,
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  else
                                    // Locked text
                                    Text(
                                      "기록이 봉인됨",
                                      style: TextStyle(
                                        color: AppColors.textDisabled.withValues(alpha: 0.5),
                                        fontSize: summaryFontSize,
                                        fontStyle: FontStyle.italic,
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
                  
                  // 4. Glassmorphism Shine Effect (Overlay)
                  // 카드가 반짝이는 느낌을 주는 대각선 그라데이션 (매우 옅게)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.white.withValues(alpha: 0.05),
                              AppColors.transparent,
                              AppColors.transparent,
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          content: Row(
            children: [
              const Icon(Icons.lock_clock, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.lockedMessage ?? '시간의 틈새에 숨겨진 기록입니다.')),
            ],
          ),
          backgroundColor: AppColors.surfaceLight.withValues(alpha: 0.95),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
  
  String _getImageAsset() {
    if (widget.characterPortraitAsset != null &&
        widget.characterPortraitAsset!.isNotEmpty) {
      return widget.characterPortraitAsset!;
    }
    final thumbnail = widget.entry.thumbnailAsset;
    if (thumbnail.isEmpty) {
      return 'assets/images/characters/placeholder.png';
    }
    return thumbnail;
  }
  
  bool _isRecent(DateTime discoveredAt) {
    final now = DateTime.now();
    final difference = now.difference(discoveredAt);
    return difference.inHours < 24;
  }
}
