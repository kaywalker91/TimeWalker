import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/civilization.dart';
import 'package:time_walker/presentation/themes/color_value_extensions.dart';

/// 문명 포탈 위젯
/// 
/// 각 문명을 나타내는 고대 유물(Relic) 형태의 포탈입니다.
/// 룬 문자가 새겨진 링과 상태에 따른 에너지 효과를 포함합니다.
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
    
    // 외곽 링 회전 (잠금 상태는 정지)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );
    
    if (widget.civilization.isUnlocked) {
      _rotationController.repeat();
    }
    
    // 에너지 펄스 (해금된 포탈만)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    if (widget.civilization.isUnlocked) {
      _pulseController.repeat(reverse: true);
    }
    
    // 탭 스케일 애니메이션
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CivilizationPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.civilization.isUnlocked != oldWidget.civilization.isUnlocked) {
      if (widget.civilization.isUnlocked) {
        _rotationController.repeat();
        _pulseController.repeat(reverse: true);
      } else {
        _rotationController.stop();
        _pulseController.stop();
      }
    }
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
    final portalColor = civ.portalColor.toColor();
    final glowColor = civ.glowColor.toColor();
    
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
          final scaleValue = _scaleAnimation.value;
          
          return Transform.scale(
            scale: scaleValue,
            child: SizedBox(
              width: widget.size * 1.4, // 글로우 효과 등을 위해 여유 공간 확보
              height: widget.size * 1.4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. 에너지 글로우 (배경)
                  if (isUnlocked)
                    Container(
                      width: widget.size * 0.8,
                      height: widget.size * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: glowColor.withValues(alpha: 0.4 + (pulseValue * 0.2)),
                            blurRadius: 30 + (pulseValue * 10),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),

                  // 2. 룬 링 (회전하는 외곽 프레임)
                  Transform.rotate(
                    angle: _rotationController.value * math.pi * 2,
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: _RuneRingPainter(
                        color: isUnlocked ? portalColor : AppColors.textDisabled,
                        isUnlocked: isUnlocked,
                      ),
                    ),
                  ),

                  // 3. 내부 코어 (고정된 문명 심볼 배경)
                  Container(
                    width: widget.size * 0.65,
                    height: widget.size * 0.65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface.withValues(alpha: 0.9), // 내부 배경 불투명
                      border: Border.all(
                        color: isUnlocked 
                            ? AppColors.premiumGold.withValues(alpha: 0.6) 
                            : AppColors.border,
                        width: 1.5,
                      ),
                      gradient: isUnlocked 
                          ? RunGradient(portalColor) 
                          : null,
                    ),
                    child: Center(
                      child: isUnlocked
                          ? _buildIcon(glowColor)
                          : _buildLockedIcon(),
                    ),
                  ),

                  // 4. 진행률 표시 (고리 형태)
                  if (civ.status == CivilizationStatus.inProgress)
                    SizedBox(
                      width: widget.size * 0.92,
                      height: widget.size * 0.92,
                      child: CircularProgressIndicator(
                        value: civ.progress,
                        strokeWidth: 3,
                        backgroundColor: AppColors.transparent,
                        valueColor: AlwaysStoppedAnimation(glowColor),
                      ),
                    ),
                    
                  // 5. 문명 이름 라벨 (하단)
                  Positioned(
                    bottom: 0,
                    child: _buildLabel(civ, isUnlocked, glowColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(Civilization civ, bool isUnlocked, Color glowColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? glowColor.withValues(alpha: 0.3) : AppColors.transparent,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (civ.status == CivilizationStatus.locked)
             Padding(
               padding: const EdgeInsets.only(right: 4),
               child: Icon(Icons.lock, size: 10, color: AppColors.textDisabled),
             ),
          Text(
            civ.name,
            style: AppTextStyles.labelMedium.copyWith(
              color: isUnlocked ? AppColors.textPrimary : AppColors.textDisabled,
              fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
              shadows: isUnlocked ? [
                Shadow(color: glowColor.withValues(alpha: 0.5), blurRadius: 4),
              ] : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Color glowColor) {
    IconData iconData;
    switch (widget.civilization.id) {
      case 'asia': iconData = Icons.temple_buddhist; break;
      case 'europe': iconData = Icons.fort; break;
      case 'americas': iconData = Icons.wb_sunny; break;
      case 'middle_east': iconData = Icons.mosque; break;
      case 'africa': iconData = Icons.change_history; break; // 피라미드 유사
      default: iconData = Icons.public;
    }
    
    return Icon(
      iconData,
      size: widget.size * 0.32,
      color: AppColors.textPrimary, // 아이콘은 밝게
      shadows: [
        Shadow(color: glowColor, blurRadius: 8),
      ],
    );
  }

  Widget _buildLockedIcon() {
    return Icon(
      Icons.lock_outline,
      size: widget.size * 0.25,
      color: AppColors.textDisabled,
    );
  }
  
  // ignore: non_constant_identifier_names
  LinearGradient RunGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
         color.withValues(alpha: 0.2),
         color.withValues(alpha: 0.05),
      ],
    );
  }
}

/// 룬 문자가 새겨진 링 페인터
class _RuneRingPainter extends CustomPainter {
  final Color color;
  final bool isUnlocked;

  _RuneRingPainter({required this.color, required this.isUnlocked});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 1. 메인 링 (두 개의 얇은 선)
    canvas.drawCircle(center, radius, paint..strokeWidth = 1.0..color = color.withValues(alpha: isUnlocked ? 0.6 : 0.3));
    canvas.drawCircle(center, radius * 0.85, paint..strokeWidth = 1.0..color = color.withValues(alpha: isUnlocked ? 0.4 : 0.2));

    // 2. 룬 문자 장식 (단순화된 기하학적 패턴)
    final runePaint = Paint()
      ..color = color.withValues(alpha: isUnlocked ? 0.8 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final int segments = 8;
    for (int i = 0; i < segments; i++) {
      final angle = (2 * math.pi / segments) * i;
      
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      
      // 룬 문자 위치 (링 사이)
      final rStart = radius * 0.88;
      final rEnd = radius * 0.97;
      
      // 간단한 룬 모양 (랜덤한 느낌을 주기 위해 인덱스별로 다르게)
      final path = Path();
      if (i % 3 == 0) {
        // 'F' 모양
        path.moveTo(0, -rStart);
        path.lineTo(0, -rEnd);
        path.moveTo(0, -rStart - (rEnd-rStart)*0.5);
        path.lineTo(4, -rStart - (rEnd-rStart)*0.7);
      } else if (i % 3 == 1) {
        // 'X' 모양
        path.moveTo(-3, -rStart);
        path.lineTo(3, -rEnd);
        path.moveTo(3, -rStart);
        path.lineTo(-3, -rEnd);
      } else {
        // '|' 모양
        path.moveTo(0, -rStart);
        path.lineTo(0, -rEnd);
      }
      
      canvas.drawPath(path, runePaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_RuneRingPainter oldDelegate) => 
      color != oldDelegate.color || isUnlocked != oldDelegate.isUnlocked;
}
