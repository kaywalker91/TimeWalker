import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';

/// 왕국 메타데이터 (탭용)
class KingdomTabMeta {
  final String id;
  final String label;
  final Color color;
  final IconData icon;

  const KingdomTabMeta({
    required this.id,
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// 삼국시대 왕국 탭 메타데이터
class ThreeKingdomsTabs {
  static const List<KingdomTabMeta> kingdoms = [
    KingdomTabMeta(
      id: 'goguryeo',
      label: '고구려',
      color: Color(0xFF5B6EFF),
      icon: Icons.flight, // 삼족오 (비상하는 새)
    ),
    KingdomTabMeta(
      id: 'baekje',
      label: '백제',
      color: Color(0xFFD17B2C),
      icon: Icons.local_florist, // 연꽃
    ),
    KingdomTabMeta(
      id: 'silla',
      label: '신라',
      color: Color(0xFF2DBE7D),
      icon: Icons.diamond, // 금관
    ),
    KingdomTabMeta(
      id: 'gaya',
      label: '가야',
      color: Color(0xFF8D5DE8),
      icon: Icons.shield, // 철갑
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
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
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
          color: widget.isActive ? null : Colors.white.withValues(alpha: 0.05),
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
            // 왕국 엠블럼 아이콘
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: responsive.iconSize(28),
                  height: responsive.iconSize(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isActive
                        ? color.withValues(alpha: _glowAnimation.value)
                        : color.withValues(alpha: 0.2),
                    border: Border.all(
                      color: widget.isActive
                          ? Colors.white.withValues(alpha: 0.6)
                          : color.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    widget.kingdom.icon,
                    size: responsive.iconSize(14),
                    color: widget.isActive
                        ? Colors.white
                        : color.withValues(alpha: 0.8),
                  ),
                );
              },
            ),

            SizedBox(width: responsive.spacing(8)),

            // 왕국 이름
            Text(
              widget.kingdom.label,
              style: TextStyle(
                color: widget.isActive ? Colors.white : Colors.white70,
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
                      ? Colors.white.withValues(alpha: 0.25)
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.isActive
                        ? Colors.white.withValues(alpha: 0.4)
                        : color.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${widget.locationCount}',
                  style: TextStyle(
                    color: widget.isActive
                        ? Colors.white
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
}
