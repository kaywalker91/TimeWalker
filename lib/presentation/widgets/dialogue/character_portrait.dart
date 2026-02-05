import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/character.dart';

/// 캐릭터 초상화 위젯
/// 
/// 대화 화면에서 현재 화자의 초상화를 표시합니다.
/// 감정에 따라 다른 이미지를 표시할 수 있습니다.
class CharacterPortrait extends StatelessWidget {
  /// 표시할 캐릭터
  final Character character;
  
  /// 현재 감정 (default, happy, angry, sad 등)
  final String emotion;
  
  /// 초상화 높이 (기본: 반응형)
  final double? height;

  const CharacterPortrait({
    super.key,
    required this.character,
    required this.emotion,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    // Determine asset based on emotion
    String assetPath = character.portraitAsset;
    
    // Try to find matching emotion asset
    if (character.emotionAssets.isNotEmpty) {
      try {
        final match = character.emotionAssets.firstWhere(
            (path) => path.contains('_$emotion.') || path.contains(emotion));
        assetPath = match;
      } catch (_) {
        // No match found, use default portrait
      }
    }

    // Responsive portrait height
    final portraitHeight = height ?? (responsive.isSmallPhone 
        ? 400.0 
        : responsive.deviceType == DeviceType.tablet 
            ? 700.0 
            : 600.0);

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: portraitHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              // 글로우 효과 및 드롭 섀도우를 위한 컨테이너
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    // 드롭 섀도우 - 캐릭터 뒤 은은한 그림자로 깊이감 추가
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                    // 골든 글로우 - 캐릭터 강조 효과
                    BoxShadow(
                      color: AppColors.goldenGlow.withValues(alpha: 0.15),
                      blurRadius: 50,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('[CharacterPortrait] Image load error: $assetPath - $error');
                    return Icon(
                      Icons.person,
                      size: responsive.iconSize(200),
                      color: AppColors.textDisabled,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 플레이스홀더 초상화 위젯
/// 
/// 캐릭터 정보가 없을 때 표시되는 기본 초상화입니다.
class PlaceholderPortrait extends StatelessWidget {
  /// 표시할 레이블 (화자 이름)
  final String label;

  const PlaceholderPortrait({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.person_outline,
            color: AppColors.textDisabled.withValues(alpha: 0.3),
            size: responsive.iconSize(160),
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: responsive.fontSize(14),
            ),
          ),
        ],
      ),
    );
  }
}

/// 로딩 중 초상화 위젯
///
/// 캐릭터 정보를 로드하는 동안 표시되는 초상화입니다.
class LoadingPortrait extends StatefulWidget {
  /// 표시할 레이블 (화자 이름)
  final String label;

  const LoadingPortrait({
    super.key,
    required this.label,
  });

  @override
  State<LoadingPortrait> createState() => _LoadingPortraitState();
}

class _LoadingPortraitState extends State<LoadingPortrait>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Icon(
              Icons.person,
              color: AppColors.textDisabled.withValues(alpha: _pulseAnimation.value),
              size: responsive.iconSize(160),
            ),
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            widget.label,
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: responsive.fontSize(14),
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.goldenGlow.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
