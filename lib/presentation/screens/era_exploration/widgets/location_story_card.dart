import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/core/constants/exploration_config.dart' show ContentStatus;
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/location.dart';

/// 장소 스토리 카드 위젯
///
/// 삼국시대 분위기의 족자 스타일 테두리, 역사적 색상 적용
/// 배경 이미지, 왕국 테마, 상태 배지를 포함한 시각적으로 풍부한 카드
class LocationStoryCard extends StatefulWidget {
  final Location location;
  final Color accentColor;
  final bool isSelected;
  final bool isLocked;
  final String? kingdomLabel;
  final VoidCallback? onTap;

  const LocationStoryCard({
    super.key,
    required this.location,
    required this.accentColor,
    this.isSelected = false,
    this.isLocked = false,
    this.kingdomLabel,
    this.onTap,
  });

  @override
  State<LocationStoryCard> createState() => _LocationStoryCardState();
}

class _LocationStoryCardState extends State<LocationStoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant LocationStoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _hoverController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _hoverController.reverse();
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final cardHeight = responsive.spacing(140);
    final location = widget.location;
    final status = location.status;

    // 접근성을 위한 상태 라벨
    final statusLabel = _getAccessibleStatusLabel(status);
    final semanticLabel =
        '${location.nameKorean}, ${widget.kingdomLabel ?? ''}, $statusLabel';
    final semanticHint =
        widget.isLocked ? '잠겨 있음. 이전 장소를 완료하세요.' : '탭하여 탐험하기';

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: !widget.isLocked,
      child: GestureDetector(
        onTap: widget.isLocked
            ? null
            : () {
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              },
        onTapDown: widget.isLocked ? null : (_) => _hoverController.forward(),
        onTapUp: widget.isLocked ? null : (_) => _hoverController.reverse(),
        onTapCancel: widget.isLocked ? null : () => _hoverController.reverse(),
        child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: cardHeight,
              // === 족자 스타일 테두리 적용 ===
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // 약간 각진 모서리 (족자 느낌)
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  // 기본 그림자
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  // 선택/호버 시 글로우 효과
                  if (widget.isSelected || _glowAnimation.value > 0)
                    BoxShadow(
                      color: widget.accentColor.withValues(
                        alpha: 0.4 * _glowAnimation.value,
                      ),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6), // 내부는 살짝 더 둥글게
                child: Stack(
                  children: [
                    // === 배경 이미지 + 다크 오버레이 ===
                    _buildBackgroundImage(location.backgroundAsset),

                    // === 연도 배지 (상단 좌측) ===
                    if (location.displayYear != null)
                      _buildYearBadge(location.displayYear!, responsive),

                    // === 콘텐츠 오버레이 (하단) ===
                    _buildContentOverlay(location, responsive),

                    // === 상태 배지 (우상단) ===
                    Positioned(
                      top: responsive.spacing(10),
                      right: responsive.spacing(10),
                      child: _buildStatusBadge(status, responsive),
                    ),

                    // === 잠금 오버레이 ===
                    if (widget.isLocked) _buildLockOverlay(responsive),

                    // === 선택 강조 (내부 글로우) ===
                    if (widget.isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: widget.accentColor.withValues(alpha: 0.9),
                              width: 2,
                            ),
                            // 내부 글로우 효과
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                widget.accentColor.withValues(alpha: 0.1),
                                Colors.transparent,
                                widget.accentColor.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }

  /// 상단 좌측 연도 배지 (미니멀 스타일)
  Widget _buildYearBadge(String displayYear, ResponsiveUtils responsive) {
    return Positioned(
      top: responsive.spacing(10),
      left: responsive.spacing(10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.padding(8),
          vertical: responsive.padding(4),
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          displayYear,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: responsive.fontSize(10),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// 접근성용 상태 라벨
  String _getAccessibleStatusLabel(ContentStatus status) {
    switch (status) {
      case ContentStatus.locked:
        return '잠김';
      case ContentStatus.available:
        return '탐험 가능';
      case ContentStatus.inProgress:
        return '진행 중';
      case ContentStatus.completed:
        return '완료됨';
    }
  }

  Widget _buildBackgroundImage(String asset) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover,
            cacheWidth: 400,
            cacheHeight: 200,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: widget.accentColor.withValues(alpha: 0.3),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white38,
                    size: 32,
                  ),
                ),
              );
            },
          ),
          // 다크 그라데이션 오버레이
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _buildKingdomAccentBar 제거됨 - 족자 스타일 테두리로 대체

  Widget _buildContentOverlay(Location location, ResponsiveUtils responsive) {
    return Positioned(
      left: responsive.spacing(14),
      right: responsive.spacing(14),
      bottom: responsive.spacing(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 장소 이름 (더 크고 강조된 텍스트)
          Text(
            location.nameKorean,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3, // 약간의 자간으로 가독성 향상
              shadows: const [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black87,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacing(6)),

          // 태그 행 (왕국 레이블만 - 미니멀화)
          // 연도는 상단 좌측으로 이동, 가상 태그는 제거
          if (widget.kingdomLabel != null)
            Wrap(
              spacing: responsive.spacing(6),
              runSpacing: responsive.spacing(4),
              children: [
                _buildInfoTag(
                  widget.kingdomLabel!,
                  widget.accentColor,
                  responsive,
                ),
              ],
            ),
          SizedBox(height: responsive.spacing(8)),

          // 설명
          Text(
            location.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white70,
              fontSize: responsive.fontSize(12),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(
    String label,
    Color color,
    ResponsiveUtils responsive,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(8),
        vertical: responsive.padding(3),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: responsive.fontSize(10),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ContentStatus status, ResponsiveUtils responsive) {
    final (icon, color, label) = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(10),
        vertical: responsive.padding(5),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: responsive.iconSize(12), color: Colors.white),
          SizedBox(width: responsive.spacing(4)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.fontSize(10),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color, String) _getStatusConfig(ContentStatus status) {
    switch (status) {
      case ContentStatus.locked:
        return (Icons.lock, Colors.grey.shade600, '잠김');
      case ContentStatus.available:
        return (Icons.explore, widget.accentColor, '탐험 가능');
      case ContentStatus.inProgress:
        return (Icons.play_circle_fill, Colors.orange, '진행 중');
      case ContentStatus.completed:
        return (Icons.check_circle, Colors.green, '완료');
    }
  }

  Widget _buildLockOverlay(ResponsiveUtils responsive) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(responsive.padding(14)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.lock,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: responsive.iconSize(28),
                ),
              ),
              SizedBox(height: responsive.spacing(10)),
              Text(
                '잠겨 있음',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: responsive.fontSize(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: responsive.spacing(4)),
              Text(
                '이전 장소를 완료하세요',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: responsive.fontSize(11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
