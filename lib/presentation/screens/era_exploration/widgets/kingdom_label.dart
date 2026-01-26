import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 왕국 메타데이터
class KingdomInfo {
  final String id;
  final String name;
  final Color color;
  final int locationCount;
  
  /// 지도 위 라벨 위치 (0.0~1.0 비율)
  final Offset position;

  const KingdomInfo({
    required this.id,
    required this.name,
    required this.color,
    required this.locationCount,
    required this.position,
  });
}

/// 삼국시대 왕국 정보
class ThreeKingdomsData {
  static const List<KingdomInfo> kingdoms = [
    KingdomInfo(
      id: 'goguryeo',
      name: '고구려',
      color: AppColors.kingdomGoguryeoLight,
      locationCount: 3,
      position: Offset(0.48, 0.25), // 북부 (상단 중앙)
    ),
    KingdomInfo(
      id: 'baekje',
      name: '백제',
      color: AppColors.kingdomSillaLight,
      locationCount: 3,
      position: Offset(0.36, 0.65), // 동쪽으로 이동 (내륙 위치)
    ),
    KingdomInfo(
      id: 'silla',
      name: '신라',
      color: AppColors.eraThreeKingdoms,
      locationCount: 2,
      position: Offset(0.68, 0.60), // 위치 유지
    ),
    KingdomInfo(
      id: 'gaya',
      name: '가야',
      color: AppColors.kingdomBaekjeLight,
      locationCount: 3,
      position: Offset(0.60, 0.82), // 동쪽으로 이동 (낙동강 하류/김해)
    ),
  ];

  static KingdomInfo? getKingdom(String id) {
    try {
      return kingdoms.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// 왕국 라벨 위젯
/// 
/// 지도 위에 표시되는 탭 가능한 왕국 라벨
class KingdomLabel extends StatefulWidget {
  final KingdomInfo kingdom;
  final VoidCallback onTap;
  final bool isSelected;

  const KingdomLabel({
    super.key,
    required this.kingdom,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<KingdomLabel> createState() => _KingdomLabelState();
}

class _KingdomLabelState extends State<KingdomLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? 1.1 : _pulseAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.kingdom.color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: widget.isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.kingdom.color.withValues(alpha: 0.5),
                blurRadius: widget.isSelected ? 20 : 12,
                spreadRadius: widget.isSelected ? 4 : 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.kingdom.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.kingdom.locationCount}개 장소',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
