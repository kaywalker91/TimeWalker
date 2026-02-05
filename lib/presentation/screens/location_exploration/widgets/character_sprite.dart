import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/character.dart';

/// 캐릭터 스프라이트 위젯
/// 
/// 역사적 인물을 화면에 살아있는 듯 표시합니다.
/// - Breathing 애니메이션 (미세한 움직임)
/// - Glow 효과 (신비로운 아우라)
/// - 탭 반응 애니메이션
class CharacterSprite extends StatefulWidget {
  /// 표시할 캐릭터
  final Character character;
  
  /// 선택 상태
  final bool isSelected;
  
  /// 탭 콜백
  final VoidCallback onTap;

  const CharacterSprite({
    super.key,
    required this.character,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CharacterSprite> createState() => _CharacterSpriteState();
}

class _CharacterSpriteState extends State<CharacterSprite>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  
  @override
  void initState() {
    super.initState();
    // Breathing 애니메이션 설정
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _breathingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = !widget.character.isAccessible;
    debugPrint('[CharacterSprite] ${widget.character.id}: isLocked=$isLocked, status=${widget.character.status}');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLocked ? null : () {
        debugPrint('[CharacterSprite] TAP DETECTED for ${widget.character.id}');
        widget.onTap();
      },
      child: AnimatedBuilder(
        listenable: _breathingAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected 
                ? 1.1 
                : _breathingAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 탭 힌트 아이콘 (선택되지 않았을 때)
              if (!isLocked && !widget.isSelected)
                _buildTapHint(),
              
              // 캐릭터 이미지 + 글로우
              _buildCharacterImage(isLocked),
              
              const SizedBox(height: 8),
              
              // 이름 태그
              _buildNameTag(isLocked),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTapHint() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 0.5 + (math.sin(value * math.pi * 2) * 0.5),
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: const Icon(
              Icons.touch_app,
              color: AppColors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCharacterImage(bool isLocked) {
    final size = 120.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          // 글로우 효과
          if (!isLocked) ...[
            BoxShadow(
              color: widget.isSelected
                  ? AppColors.primary.withValues(alpha: 0.8)
                  : AppColors.primary.withValues(alpha: 0.4),
              blurRadius: widget.isSelected ? 30 : 20,
              spreadRadius: widget.isSelected ? 5 : 2,
            ),
            // 내부 그림자
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ],
      ),
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : AppColors.white.withValues(alpha: 0.5),
              width: widget.isSelected ? 3 : 2,
            ),
          ),
          child: ClipOval(
            child: isLocked
                ? _buildLockedCharacter()
                : Image.asset(
                    widget.character.portraitAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderCharacter();
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockedCharacter() {
    return Container(
      color: AppColors.grey800,
      child: Center(
        child: Icon(
          Icons.lock,
          color: AppColors.grey600,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildPlaceholderCharacter() {
    return Container(
      color: AppColors.grey700,
      child: Center(
        child: Icon(
          Icons.person,
          color: AppColors.grey500,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildNameTag(bool isLocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? AppColors.primary.withValues(alpha: 0.9)
            : AppColors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isSelected
              ? AppColors.primary
              : AppColors.white.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        isLocked ? '???' : widget.character.nameKorean,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.white,
          fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

/// AnimatedBuilder와 같은 역할을 하는 위젯
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  }) : super();

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
