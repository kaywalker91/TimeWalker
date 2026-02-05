import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';

/// 왕국 메타데이터 (탭용)
/// 
/// 삼국시대 4개 왕국의 역사적 정체성을 담은 메타데이터
class KingdomTabMeta {
  final String id;
  final String label;
  final Color color;
  final Color lightColor;
  final Color glowColor;
  final String? iconAsset; // 커스텀 이미지 에셋 경로
  final IconData? fallbackIcon; // 에셋 로드 실패 시 대체 아이콘

  const KingdomTabMeta({
    required this.id,
    required this.label,
    required this.color,
    required this.lightColor,
    required this.glowColor,
    this.iconAsset,
    this.fallbackIcon,
  });
}

/// 삼국시대 왕국 탭 메타데이터
/// 
/// 역사적 고증을 바탕으로 한 색상과 상징 아이콘 적용
class ThreeKingdomsTabs {
  static const List<KingdomTabMeta> kingdoms = [
    // 고구려: 삼족오 (주작, 태양 숭배), 붉은색 (전사 정신, 북방 기질)
    KingdomTabMeta(
      id: 'goguryeo',
      label: '고구려',
      color: AppColors.kingdomGoguryeo,
      lightColor: AppColors.kingdomGoguryeoLight,
      glowColor: AppColors.kingdomGoguryeoGlow,
      iconAsset: 'assets/icons/kingdoms/ic_goguryeo_samjoko.png',
      fallbackIcon: Icons.whatshot,
    ),
    // 백제: 연꽃 (불교 문화), 황토/금색 (금동대향로, 문화 예술)
    KingdomTabMeta(
      id: 'baekje',
      label: '백제',
      color: AppColors.kingdomBaekje,
      lightColor: AppColors.kingdomBaekjeLight,
      glowColor: AppColors.kingdomBaekjeGlow,
      iconAsset: 'assets/icons/kingdoms/ic_baekje_lotus.png',
      fallbackIcon: Icons.spa,
    ),
    // 신라: 금관 (왕권), 녹색/금색 (불국사, 황금 문화)
    KingdomTabMeta(
      id: 'silla',
      label: '신라',
      color: AppColors.kingdomSilla,
      lightColor: AppColors.kingdomSillaLight,
      glowColor: AppColors.kingdomSillaGlow,
      iconAsset: 'assets/icons/kingdoms/ic_silla_crown.png',
      fallbackIcon: Icons.star,
    ),
    // 가야: 철검 (철기 문화), 철색/은색 (무역 국가)
    KingdomTabMeta(
      id: 'gaya',
      label: '가야',
      color: AppColors.kingdomGaya,
      lightColor: AppColors.kingdomGayaLight,
      glowColor: AppColors.kingdomGayaGlow,
      iconAsset: 'assets/icons/kingdoms/ic_gaya_sword.png',
      fallbackIcon: Icons.shield,
    ),
  ];

  static KingdomTabMeta? getKingdom(String id) {
    try {
      return kingdoms.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// 강화된 왕국 탭 바
///
/// 그라데이션 배경, 엠블럼 아이콘, 카운트 배지를 포함한 시각적으로 풍부한 탭 바
class EnhancedKingdomTabs extends StatelessWidget {
  final TabController controller;
  final Color eraAccentColor;
  final Map<String, int> locationCounts;
  final ValueChanged<int>? onTabChanged;

  const EnhancedKingdomTabs({
    super.key,
    required this.controller,
    required this.eraAccentColor,
    this.locationCounts = const {},
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.padding(12),
        vertical: responsive.padding(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: AppColors.white.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                ThreeKingdomsTabs.kingdoms.length,
                (index) {
                  final kingdom = ThreeKingdomsTabs.kingdoms[index];
                  final isActive = controller.index == index;
                  final count = locationCounts[kingdom.id] ?? 0;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < ThreeKingdomsTabs.kingdoms.length - 1
                          ? responsive.spacing(8)
                          : 0,
                    ),
                    child: _EnhancedKingdomTab(
                      kingdom: kingdom,
                      isActive: isActive,
                      locationCount: count,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        controller.animateTo(index);
                        onTabChanged?.call(index);
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 개별 왕국 탭 위젯
class _EnhancedKingdomTab extends StatefulWidget {
  final KingdomTabMeta kingdom;
  final bool isActive;
  final int locationCount;
  final VoidCallback onTap;

  const _EnhancedKingdomTab({
    required this.kingdom,
    required this.isActive,
    required this.locationCount,
    required this.onTap,
  });

  @override
  State<_EnhancedKingdomTab> createState() => _EnhancedKingdomTabState();
}

class _EnhancedKingdomTabState extends State<_EnhancedKingdomTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _EnhancedKingdomTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final color = widget.kingdom.color;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.padding(14),
          vertical: responsive.padding(10),
        ),
        decoration: BoxDecoration(
          gradient: widget.isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.35),
                    color.withValues(alpha: 0.15),
                  ],
                )
              : null,
          color: widget.isActive ? null : AppColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isActive
                ? color.withValues(alpha: 0.8)
                : color.withValues(alpha: 0.3),
            width: widget.isActive ? 2 : 1,
          ),
          boxShadow: widget.isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 왕국 엠블럼 아이콘 (역사적 이미지 에셋 사용)
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: responsive.iconSize(32),
                  height: responsive.iconSize(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isActive
                        ? color.withValues(alpha: _glowAnimation.value)
                        : color.withValues(alpha: 0.2),
                    border: Border.all(
                      color: widget.isActive
                          ? AppColors.white.withValues(alpha: 0.6)
                          : color.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    // 선택된 탭에 글로우 효과 추가
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: widget.kingdom.glowColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: _buildKingdomIcon(responsive),
                  ),
                );
              },
            ),

            SizedBox(width: responsive.spacing(8)),

            // 왕국 이름
            Text(
              widget.kingdom.label,
              style: TextStyle(
                color: widget.isActive ? AppColors.white : AppColors.white70,
                fontSize: responsive.fontSize(14),
                fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),

            // 카운트 배지
            if (widget.locationCount > 0) ...[
              SizedBox(width: responsive.spacing(6)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(7),
                  vertical: responsive.padding(2),
                ),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? AppColors.white.withValues(alpha: 0.25)
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.isActive
                        ? AppColors.white.withValues(alpha: 0.4)
                        : color.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${widget.locationCount}',
                  style: TextStyle(
                    color: widget.isActive
                        ? AppColors.white
                        : color.withValues(alpha: 0.9),
                    fontSize: responsive.fontSize(11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 왕국별 아이콘 빌드 (이미지 에셋 또는 fallback 아이콘)
  Widget _buildKingdomIcon(ResponsiveUtils responsive) {
    final iconAsset = widget.kingdom.iconAsset;
    final color = widget.kingdom.color;
    
    if (iconAsset != null) {
      return Image.asset(
        iconAsset,
        width: responsive.iconSize(24),
        height: responsive.iconSize(24),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // 이미지 로드 실패 시 fallback 아이콘 사용
          return Icon(
            widget.kingdom.fallbackIcon ?? Icons.place,
            size: responsive.iconSize(16),
            color: widget.isActive
                ? AppColors.white
                : color.withValues(alpha: 0.8),
          );
        },
      );
    }
    
    // iconAsset이 없으면 fallback 아이콘 사용
    return Icon(
      widget.kingdom.fallbackIcon ?? Icons.place,
      size: responsive.iconSize(16),
      color: widget.isActive
          ? AppColors.white
          : color.withValues(alpha: 0.8),
    );
  }
}
