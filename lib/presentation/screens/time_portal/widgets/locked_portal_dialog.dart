import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/civilization.dart';


/// 잠금된 포탈 알림 다이얼로그
/// 
/// 고대 봉인 스타일의 디자인을 적용하여 몰입감을 줍니다.
class LockedPortalDialog extends StatefulWidget {
  final Civilization civilization;
  final VoidCallback onConfirm;

  const LockedPortalDialog({
    super.key,
    required this.civilization,
    required this.onConfirm,
  });

  @override
  State<LockedPortalDialog> createState() => _LockedPortalDialogState();
}

class _LockedPortalDialogState extends State<LockedPortalDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
    
    // 처음에 살짝 흔들리는 효과
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.error.withValues(alpha: 0.5),
                    AppColors.textSecondary.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppColors.background.withValues(alpha: 0.85),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 잠금 아이콘
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error.withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: AppColors.error,
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 제목
                    Text(
                      '차원이 봉인되었습니다',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 설명 (이름 및 조건)
                    Text(
                      '${widget.civilization.name} 문명은 아직 접근할 수 없습니다.\n시간 여행자 레벨 ${widget.civilization.unlockLevel}에 도달해야 합니다.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 확인 버튼
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: widget.onConfirm,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '확인',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
