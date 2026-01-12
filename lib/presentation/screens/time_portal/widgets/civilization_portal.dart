import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/civilization.dart';

/// 문명 포탈 위젯
/// 
/// 각 문명을 나타내는 회전하는 포탈을 표시합니다.
class CivilizationPortal extends StatefulWidget {
  final Civilization civilization;
  final VoidCallback? onTap;
  final double size;

  const CivilizationPortal({
    super.key,
    required this.civilization,
    this.onTap,
    this.size = 100,
  });

  @override
  State<CivilizationPortal> createState() => _CivilizationPortalState();
}

class _CivilizationPortalState extends State<CivilizationPortal>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 회전 애니메이션 (잠금된 포탈은 느리게)
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.civilization.isUnlocked ? 20 : 40,
      ),
    )..repeat();
    
    // 펄스 애니메이션 (해금된 포탈만)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    if (widget.civilization.isUnlocked) {
      _pulseController.repeat(reverse: true);
    }
    
    // 탭 스케일 애니메이션
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _scaleController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final civ = widget.civilization;
    final isUnlocked = civ.isUnlocked;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _pulseController,
          _scaleAnimation,
        ]),
        builder: (context, child) {
          final pulseValue = _pulseController.value;
          final glowIntensity = isUnlocked ? 0.5 + pulseValue * 0.5 : 0.2;
          
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 포탈
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: civ.glowColor.withValues(alpha: glowIntensity * 0.6),
                        blurRadius: 20 + pulseValue * 10,
                        spreadRadius: 5 + pulseValue * 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 외부 링 (회전)
                      Transform.rotate(
                        angle: _rotationController.value * math.pi * 2,
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: civ.portalColor.withValues(
                                alpha: isUnlocked ? 0.8 : 0.3,
                              ),
                              width: 3,
                            ),
                            gradient: RadialGradient(
                              colors: [
                                civ.portalColor.withValues(alpha: isUnlocked ? 0.3 : 0.1),
                                civ.portalColor.withValues(alpha: isUnlocked ? 0.1 : 0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // 내부 원
                      Container(
                        width: widget.size * 0.7,
                        height: widget.size * 0.7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.background.withValues(alpha: 0.8),
                          border: Border.all(
                            color: civ.glowColor.withValues(
                              alpha: isUnlocked ? 0.5 : 0.2,
                            ),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isUnlocked
                              ? _buildIcon()
                              : _buildLockedIcon(),
                        ),
                      ),
                      
                      // 진행률 표시 (진행 중인 경우)
                      if (civ.status == CivilizationStatus.inProgress)
                        Positioned(
                          bottom: 0,
                          child: _buildProgressIndicator(),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 문명 이름
                Text(
                  civ.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isUnlocked 
                        ? AppColors.textPrimary 
                        : AppColors.textDisabled,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // 상태 또는 진행률
                if (civ.status == CivilizationStatus.inProgress)
                  Text(
                    '${civ.progressPercent}%',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: civ.glowColor,
                    ),
                  )
                else if (civ.status == CivilizationStatus.locked)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 12,
                        color: AppColors.textDisabled,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lv.${civ.unlockLevel}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    // 문명별 아이콘
    IconData iconData;
    switch (widget.civilization.id) {
      case 'asia':
        iconData = Icons.temple_buddhist;
        break;
      case 'europe':
        iconData = Icons.account_balance;
        break;
      case 'americas':
        iconData = Icons.wb_sunny;
        break;
      case 'middle_east':
        iconData = Icons.mosque;
        break;
      case 'africa':
        iconData = Icons.change_history;  // 피라미드
        break;
      default:
        iconData = Icons.public;
    }
    
    return Icon(
      iconData,
      size: widget.size * 0.3,
      color: widget.civilization.glowColor,
    );
  }

  Widget _buildLockedIcon() {
    return Icon(
      Icons.lock_outline,
      size: widget.size * 0.25,
      color: AppColors.textDisabled,
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: widget.size * 0.8,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widget.civilization.progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.civilization.portalColor,
                widget.civilization.glowColor,
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
