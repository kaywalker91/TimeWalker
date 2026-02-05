import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/character.dart';

/// 캐릭터 인터랙션 팝업
/// 
/// 캐릭터를 탭했을 때 표시되는 팝업으로,
/// 캐릭터 정보와 대화하기 버튼을 제공합니다.
class CharacterInteractionPopup extends StatefulWidget {
  /// 표시할 캐릭터
  final Character character;
  
  /// 시대 ID
  final String eraId;
  
  /// 닫기 콜백
  final VoidCallback onClose;
  
  /// 대화하기 콜백
  final VoidCallback onTalk;

  const CharacterInteractionPopup({
    super.key,
    required this.character,
    required this.eraId,
    required this.onClose,
    required this.onTalk,
  });

  @override
  State<CharacterInteractionPopup> createState() =>
      _CharacterInteractionPopupState();
}

class _CharacterInteractionPopupState extends State<CharacterInteractionPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _close() async {
    await _animationController.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 (탭하면 닫힘)
        GestureDetector(
          onTap: _close,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              color: AppColors.black.withValues(alpha: 0.6),
            ),
          ),
        ),
        
        // 팝업 카드
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildPopupCard(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: AppColors.darkSheet,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: AppColors.black54,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 캐릭터 초상화
          _buildPortrait(),
          
          // 캐릭터 정보
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  widget.character.nameKorean,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.character.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.character.biography,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                
                // 대화하기 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      widget.onTalk();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '대화하기',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 닫기 버튼
                TextButton(
                  onPressed: _close,
                  child: Text(
                    '닫기',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.transparent,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 캐릭터 이미지
          Container(
            width: 140,
            height: 140,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                widget.character.portraitAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.grey,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // 닫기 버튼 (우상단)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: _close,
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.white70,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
