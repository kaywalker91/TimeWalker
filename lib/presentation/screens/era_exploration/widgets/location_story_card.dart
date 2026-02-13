import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/exploration_config.dart'
    show ContentStatus;
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/era_exploration_layout_spec.dart';

/// 장소 스토리 카드 위젯
///
/// 삼국시대 분위기의 족자 스타일 테두리, 역사적 색상 적용
/// 배경 이미지, 왕국 테마, 상태 배지를 포함한 시각적으로 풍부한 카드
class LocationStoryCard extends ConsumerStatefulWidget {
  final Location location;
  final Color accentColor;
  final bool isSelected;
  final bool isLocked;
  final String? kingdomLabel;
  final EraExplorationLayoutSpec layoutSpec;
  final VoidCallback? onTap;

  const LocationStoryCard({
    super.key,
    required this.location,
    required this.accentColor,
    required this.layoutSpec,
    this.isSelected = false,
    this.isLocked = false,
    this.kingdomLabel,
    this.onTap,
  });

  @override
  ConsumerState<LocationStoryCard> createState() => _LocationStoryCardState();
}

class _LocationStoryCardState extends ConsumerState<LocationStoryCard>
    with SingleTickerProviderStateMixin {
  static const Key _titleKey = ValueKey<String>('location_story_title');
  static const Key _descriptionKey = ValueKey<String>(
    'location_story_description',
  );
  static const Key _fullImageKey = ValueKey<String>(
    'location_story_full_image',
  );
  static const Key _bottomScrimKey = ValueKey<String>(
    'location_story_bottom_scrim',
  );
  static const Key _textOverlayKey = ValueKey<String>(
    'location_story_text_overlay',
  );
  static const Key _statusBadgeKey = ValueKey<String>(
    'location_story_status_badge',
  );
  static const Key _yearBadgeKey = ValueKey<String>(
    'location_story_year_badge',
  );

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
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
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
    final location = widget.location;
    final status = location.status;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final enableHoverFeedback = !widget.isLocked && !disableAnimations;
    final showGlow = widget.isSelected || _glowAnimation.value > 0;
    final glowFactor = disableAnimations ? 0.2 : _glowAnimation.value;

    final statusLabel = _getAccessibleStatusLabel(status);
    final semanticLabel =
        '${location.getNameForContext(context)}, ${widget.kingdomLabel ?? ''}, $statusLabel';
    final semanticHint = widget.isLocked ? '잠겨 있음. 이전 장소를 완료하세요.' : '탭하여 탐험하기';

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
        onTapDown: enableHoverFeedback
            ? (_) => _hoverController.forward()
            : null,
        onTapUp: enableHoverFeedback ? (_) => _hoverController.reverse() : null,
        onTapCancel: enableHoverFeedback
            ? () => _hoverController.reverse()
            : null,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: disableAnimations ? 1.0 : _scaleAnimation.value,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardHeight = _calculateCardHeight(
                    constraints.maxWidth,
                    widget.layoutSpec,
                  );

                  return SizedBox(
                    height: cardHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.6),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                          if (showGlow)
                            BoxShadow(
                              color: widget.accentColor.withValues(
                                alpha: 0.4 * glowFactor,
                              ),
                              blurRadius: disableAnimations ? 8 : 16,
                              spreadRadius: disableAnimations ? 1 : 2,
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _buildBackgroundImage(
                                location.backgroundAsset,
                              ),
                            ),
                            _buildBottomScrim(),
                            if (location.displayYear != null)
                              Positioned(
                                top: responsive.spacing(10),
                                left: responsive.spacing(10),
                                child: _buildYearBadge(
                                  location.displayYear!,
                                  responsive,
                                ),
                              ),
                            Positioned(
                              top: responsive.spacing(10),
                              right: responsive.spacing(10),
                              child: _buildStatusBadge(status, responsive),
                            ),
                            _buildContentOverlay(
                              context,
                              ref,
                              location,
                              responsive,
                              titleMaxLines:
                                  widget.layoutSpec.cardTitleMaxLines,
                              descriptionMaxLines:
                                  widget.layoutSpec.cardDescriptionMaxLines,
                            ),
                            if (widget.isLocked) _buildLockOverlay(responsive),
                            if (widget.isSelected) _buildSelectedOverlay(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String asset) {
    return Image.asset(
      key: _fullImageKey,
      asset,
      fit: BoxFit.cover,
      cacheWidth: 800,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: widget.accentColor.withValues(alpha: 0.3),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              color: AppColors.white38,
              size: 32,
            ),
          ),
        );
      },
    );
  }

  double _calculateCardHeight(
    double cardWidth,
    EraExplorationLayoutSpec layoutSpec,
  ) {
    final safeWidth = cardWidth.isFinite && cardWidth > 0 ? cardWidth : 320.0;
    final computed = safeWidth / layoutSpec.cardImageAspectRatio;
    return computed
        .clamp(layoutSpec.cardMinHeight, layoutSpec.cardMaxHeight)
        .toDouble();
  }

  Widget _buildBottomScrim() {
    final (middleAlpha, endAlpha) = _resolveScrimAlpha();
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          key: _bottomScrimKey,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.transparent,
                AppColors.black.withValues(alpha: 0.12),
                AppColors.black.withValues(alpha: middleAlpha),
                AppColors.black.withValues(alpha: endAlpha),
              ],
              stops: const [0.0, 0.48, 0.72, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  (double, double) _resolveScrimAlpha() {
    switch (widget.layoutSpec.textScaleClass) {
      case EraExplorationTextScaleClass.normal:
        return (0.52, 0.78);
      case EraExplorationTextScaleClass.large:
        return (0.56, 0.82);
      case EraExplorationTextScaleClass.xlarge:
        return (0.6, 0.86);
      case EraExplorationTextScaleClass.max:
        return (0.64, 0.9);
    }
  }

  Widget _buildContentOverlay(
    BuildContext context,
    WidgetRef ref,
    Location location,
    ResponsiveUtils responsive, {
    required int titleMaxLines,
    required int descriptionMaxLines,
  }) {
    final hasYear = location.displayYear != null;
    final topSafeInset = _resolveTopSafeInset(hasYear: hasYear);
    final bottomInset = _resolveBottomInset();

    return Positioned.fill(
      left: responsive.padding(14),
      right: responsive.padding(14),
      top: topSafeInset,
      bottom: bottomInset,
      child: Container(
        key: _textOverlayKey,
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              key: _titleKey,
              location.getNameForContext(context),
              maxLines: titleMaxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.white,
                fontSize: responsive.fontSize(18),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                shadows: const [
                  Shadow(
                    blurRadius: 4,
                    color: AppColors.black87,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.spacing(6)),
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
            _buildDescription(
              context,
              ref,
              location,
              responsive,
              maxLines: descriptionMaxLines,
            ),
          ],
        ),
      ),
    );
  }

  double _resolveTopSafeInset({required bool hasYear}) {
    switch (widget.layoutSpec.widthClass) {
      case EraExplorationWidthClass.compact:
        return hasYear ? 56 : 48;
      case EraExplorationWidthClass.phone:
        return hasYear ? 54 : 46;
      case EraExplorationWidthClass.phablet:
        return hasYear ? 52 : 44;
      case EraExplorationWidthClass.tablet:
        return hasYear ? 52 : 44;
    }
  }

  double _resolveBottomInset() {
    switch (widget.layoutSpec.widthClass) {
      case EraExplorationWidthClass.compact:
        return 10;
      case EraExplorationWidthClass.phone:
        return 12;
      case EraExplorationWidthClass.phablet:
        return 14;
      case EraExplorationWidthClass.tablet:
        return 16;
    }
  }

  Widget _buildYearBadge(String displayYear, ResponsiveUtils responsive) {
    return Container(
      key: _yearBadgeKey,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(8),
        vertical: responsive.padding(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        displayYear,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.white.withValues(alpha: 0.9),
          fontSize: responsive.fontSize(10),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoTag(String label, Color color, ResponsiveUtils responsive) {
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.white,
          fontSize: responsive.fontSize(10),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ContentStatus status, ResponsiveUtils responsive) {
    final (icon, color, label) = _getStatusConfig(status);

    return Container(
      key: _statusBadgeKey,
      constraints: BoxConstraints(maxWidth: responsive.wp(34)),
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
          Icon(icon, size: responsive.iconSize(12), color: AppColors.white),
          SizedBox(width: responsive.spacing(4)),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.white,
                fontSize: responsive.fontSize(10),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(
    BuildContext context,
    WidgetRef ref,
    Location location,
    ResponsiveUtils responsive, {
    required int maxLines,
  }) {
    final locale = Localizations.localeOf(context);
    final i18nContent = ref.watch(
      locationI18nContentProvider(locale.languageCode),
    );

    return i18nContent.when(
      data: (content) {
        final locationData = content[location.id] as Map<String, dynamic>?;
        final localizedDescription = locationData?['description'] as String?;
        final displayDescription = localizedDescription ?? location.description;
        return Text(
          key: _descriptionKey,
          displayDescription,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: _descriptionStyle(responsive),
        );
      },
      loading: () => Text(
        key: _descriptionKey,
        location.description,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: _descriptionStyle(responsive),
      ),
      error: (error, stackTrace) => Text(
        key: _descriptionKey,
        location.description,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: _descriptionStyle(responsive),
      ),
    );
  }

  TextStyle _descriptionStyle(ResponsiveUtils responsive) {
    return TextStyle(
      color: AppColors.white70,
      fontSize: responsive.fontSize(12),
      height: 1.25,
      shadows: const [
        Shadow(blurRadius: 3, color: AppColors.black87, offset: Offset(0, 1)),
      ],
    );
  }

  Widget _buildLockOverlay(ResponsiveUtils responsive) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(responsive.padding(14)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.black.withValues(alpha: 0.5),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.lock,
                  color: AppColors.white.withValues(alpha: 0.7),
                  size: responsive.iconSize(28),
                ),
              ),
              SizedBox(height: responsive.spacing(10)),
              Text(
                '잠겨 있음',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: responsive.fontSize(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: responsive.spacing(4)),
              Text(
                '이전 장소를 완료하세요',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.5),
                  fontSize: responsive.fontSize(11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.9),
            width: 2,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.accentColor.withValues(alpha: 0.1),
              AppColors.transparent,
              widget.accentColor.withValues(alpha: 0.05),
            ],
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

  (IconData, Color, String) _getStatusConfig(ContentStatus status) {
    switch (status) {
      case ContentStatus.locked:
        return (Icons.lock, AppColors.grey600, '잠김');
      case ContentStatus.available:
        return (Icons.explore, widget.accentColor, '탐험 가능');
      case ContentStatus.inProgress:
        return (Icons.play_circle_fill, AppColors.orange, '진행 중');
      case ContentStatus.completed:
        return (Icons.check_circle, AppColors.green, '완료');
    }
  }
}
