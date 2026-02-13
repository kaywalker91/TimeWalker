import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/character_sprite.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/location_background.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/character_interaction_popup.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/floating_particles.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/atmosphere_overlay.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/character_entrance.dart';

/// 장소 탐험 화면
/// 
/// 역사적 장소에서 캐릭터들이 살아 숨쉬듯 표시되고,
/// 사용자가 캐릭터를 탭하여 대화를 시작할 수 있는 몰입형 화면
class LocationExplorationScreen extends ConsumerStatefulWidget {
  final String eraId;
  final String locationId;

  const LocationExplorationScreen({
    super.key,
    required this.eraId,
    required this.locationId,
  });

  @override
  ConsumerState<LocationExplorationScreen> createState() =>
      _LocationExplorationScreenState();
}

class _LocationExplorationScreenState
    extends ConsumerState<LocationExplorationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Character? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationByIdProvider(widget.locationId));
    final eraAsync = ref.watch(eraByIdProvider(widget.eraId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.black,
      body: locationAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                '장소를 불러올 수 없습니다',
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
        data: (location) {
          if (location == null) {
            return const Center(child: Text('장소를 찾을 수 없습니다'));
          }
          return eraAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (era) => _buildContent(context, location, era),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Location location, dynamic era) {
    final charactersAsync = ref.watch(
      characterListByLocationProvider(location.id),
    );

    // 왕국별 분위기 설정 가져오기
    final atmosphere = KingdomAtmosphere.fromKingdom(location.kingdom);

    return Stack(
      children: [
        // 배경 이미지
        FadeTransition(
          opacity: _fadeAnimation,
          child: LocationBackground(
            backgroundAsset: location.backgroundAsset,
            fallbackAsset: 'assets/images/locations/three_kingdoms_bg_2.png',
          ),
        ),

        // 분위기 오버레이 (왕국별 색상)
        FadeTransition(
          opacity: _fadeAnimation,
          child: AtmosphereOverlay(
            kingdom: location.kingdom,
            opacity: 0.12,
          ),
        ),

        // 파티클 효과 (빛 입자)
        FadeTransition(
          opacity: _fadeAnimation,
          child: FloatingParticles(
            particleCount: atmosphere?.particleCount ?? 25,
            particleColor: atmosphere?.particleColor ?? AppColors.white70,
            maxParticleSize: 3.5,
            speedMultiplier: 0.8,
          ),
        ),

        // 상단 앱바
        _buildAppBar(context, location),

        // 캐릭터 스프라이트들 (등장 애니메이션 포함)
        charactersAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (characters) => _buildCharacterSprites(context, characters),
        ),

        // 하단 장소 정보 패널
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildLocationInfoPanel(context, location),
        ),

        // 캐릭터 인터랙션 팝업
        if (_selectedCharacter != null)
          CharacterInteractionPopup(
            character: _selectedCharacter!,
            eraId: widget.eraId,
            onClose: () => setState(() => _selectedCharacter = null),
            onTalk: () => _startDialogue(_selectedCharacter!),
          ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, Location location) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.black.withValues(alpha: 0.7),
                AppColors.transparent,
              ],
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      location.getNameForContext(context),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48), // 균형을 위한 공간
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterSprites(
    BuildContext context,
    List<Character> characters,
  ) {
    // 디버그: 로드된 캐릭터 정보 출력
    for (final c in characters) {
      debugPrint('[LocationExploration] Character: ${c.id}, status: ${c.status}, isAccessible: ${c.isAccessible}');
    }

    if (characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 64,
              color: AppColors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '아직 아무도 없습니다',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 캐릭터 위치 계산 (하단 중앙에 균등 배치)
    final characterCount = characters.length;
    final spacing = screenWidth / (characterCount + 1);

    return Stack(
      children: List.generate(characters.length, (index) {
        final character = characters[index];
        final xPosition = spacing * (index + 1) - 60; // 캐릭터 너비의 절반
        final yPosition = screenHeight * 0.45; // 화면 중앙보다 약간 아래

        // 각 캐릭터에 순차적 등장 애니메이션 적용
        return Positioned(
          left: xPosition,
          top: yPosition,
          child: CharacterEntrance(
            delay: Duration(milliseconds: 200 + (index * 150)),
            child: CharacterSprite(
              character: character,
              isSelected: _selectedCharacter?.id == character.id,
              onTap: () => _onCharacterTap(character),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLocationInfoPanel(BuildContext context, Location location) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.black.withValues(alpha: 0.9),
            AppColors.black.withValues(alpha: 0.7),
            AppColors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 왕국 태그 (삼국시대)
            if (location.kingdom != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: _getKingdomColor(location.kingdom!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getKingdomName(location.kingdom!),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            _buildDescription(context, location),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 6),
                Text(
                  '만날 수 있는 인물: ${location.characterIds.length}명',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getKingdomColor(String kingdom) {
    switch (kingdom) {
      case 'goguryeo':
        return AppColors.kingdomGoguryeo;
      case 'baekje':
        return AppColors.kingdomBaekje;
      case 'silla':
        return AppColors.kingdomSilla;
      case 'gaya':
        return AppColors.kingdomGaya;
      default:
        return AppColors.primary;
    }
  }

  String _getKingdomName(String kingdom) {
    switch (kingdom) {
      case 'goguryeo':
        return '고구려';
      case 'baekje':
        return '백제';
      case 'silla':
        return '신라';
      case 'gaya':
        return '가야';
      default:
        return kingdom;
    }
  }

  void _onCharacterTap(Character character) {
    debugPrint('[LocationExploration] _onCharacterTap called for ${character.id}');
    HapticFeedback.mediumImpact();
    setState(() {
      if (_selectedCharacter?.id == character.id) {
        _selectedCharacter = null;
      } else {
        _selectedCharacter = character;
      }
    });
  }

  Future<void> _startDialogue(Character character) async {
    debugPrint('[_startDialogue] START - characterId: ${character.id}, dialogueIds: ${character.dialogueIds}');
    setState(() => _selectedCharacter = null);

    try {
      final dialogues = await ref.read(
        dialogueListByCharacterProvider(character.id).future,
      );

      debugPrint('[_startDialogue] Loaded ${dialogues.length} dialogues');

      if (!mounted) return;

      if (dialogues.isNotEmpty) {
        debugPrint('[_startDialogue] Navigating to: ${dialogues.first.id}');
        final location = ref.read(locationByIdProvider(widget.locationId)).valueOrNull;
        AppRouter.goToDialogue(
          context,
          widget.eraId,
          dialogues.first.id,
          backgroundAsset: location?.backgroundAsset,
        );
      } else {
        debugPrint('[_startDialogue] NO DIALOGUES FOUND');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${character.getNameForContext(context)}와의 대화가 아직 준비 중입니다'),
            backgroundColor: AppColors.orange,
          ),
        );
      }
    } catch (e, stack) {
      debugPrint('[_startDialogue] ERROR: $e');
      debugPrint('[_startDialogue] STACK: $stack');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('대화를 불러오는 중 오류가 발생했습니다'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  /// Description with i18n support
  Widget _buildDescription(BuildContext context, Location location) {
    final locale = Localizations.localeOf(context);
    final i18nContent = ref.watch(locationI18nContentProvider(locale.languageCode));
    
    return i18nContent.when(
      data: (content) {
        final locationData = content[location.id] as Map<String, dynamic>?;
        final localizedDescription = locationData?['description'] as String?;
        final displayDescription = localizedDescription ?? location.description;
        
        return Text(
          displayDescription,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        );
      },
      loading: () => Text(
        location.description,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white.withValues(alpha: 0.9),
          height: 1.5,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      error: (_, stackTrace) => Text(
        location.description,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white.withValues(alpha: 0.9),
          height: 1.5,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
