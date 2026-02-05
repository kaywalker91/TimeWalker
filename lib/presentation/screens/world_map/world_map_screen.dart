import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/game/world_map_game.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/common/widgets.dart';

/// 세계 지도 화면
/// 
/// "시간의 문" 컨셉 - 고풍스러운 세계 지도
class WorldMapScreen extends ConsumerStatefulWidget {
  const WorldMapScreen({super.key});

  @override
  ConsumerState<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends ConsumerState<WorldMapScreen> {
  /// 화면 초기화 완료 여부 (BGM 중복 재생 방지)
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('[WorldMapScreen] initState');
    
    // BGM 초기화 (build가 아닌 initState에서 한 번만 실행)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isInitialized) return;
      _isInitialized = true;
      
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != AudioConstants.bgmWorldMap) {
        ref.read(bgmControllerProvider.notifier).playWorldMapBgm();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('[WorldMapScreen] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionsAsync = ref.watch(regionListProvider);
    final userProgressAsync = ref.watch(userProgressProvider);

    // BGM은 initState에서 처리됨 (build에서 중복 실행 방지)

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.world_map_title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.mainMenu);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.iconPrimary),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: regionsAsync.when(
          data: (regions) => userProgressAsync.when(
            data: (userProgress) => _buildMapLayout(context, regions, userProgress),
            loading: () => _buildLoadingState(),
            error: (err, stack) => _buildErrorState('Error loading progress: $err'),
          ),
          loading: () => _buildLoadingState(),
          error: (err, stack) => _buildErrorState('Error loading regions: $err'),
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const CommonLoadingState(
      message: '지도를 불러오는 중...',
    );
  }
  
  Widget _buildErrorState(String message) {
    return CommonErrorState(
      message: message,
      showRetryButton: false,
    );
  }

  Widget _buildMapLayout(
    BuildContext context,
    List<Region> regions,
    UserProgress userProgress,
  ) {
    // Flame Game 인스턴스 생성
    final game = WorldMapGame(
      regions: regions,
      userProgress: userProgress,
      onRegionPreview: (region) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${region.nameKorean}: ${region.description}'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.surfaceLight,
          ),
        );
      },
      onRegionTapped: (region) {
        final isUnlocked = userProgress.isRegionUnlocked(region.id);
        
        if (isUnlocked) {
          context.pushNamed(
            'regionDetail',
            pathParameters: {'regionId': region.id},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.world_map_locked_msg(region.nameKorean),
              ),
              backgroundColor: AppColors.warning.withValues(alpha: 0.9),
            ),
          );
        }
      },
    );

    return Stack(
      children: [
        // Flame Game 위젯
        GameWidget<WorldMapGame>.controlled(
          gameFactory: () => game,
        ),

        // HUD Layer (Fixed on Screen)
        Positioned(
          left: 20,
          right: 20,
          bottom: 40,
          child: _buildStatusPanel(context),
        ),
      ],
    );
  }

  Widget _buildStatusPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: AppShadows.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.world_map_current_location,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.world_map_location_test,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppGradients.goldenButton,
              shape: BoxShape.circle,
              boxShadow: AppShadows.goldenGlowSm,
            ),
            child: const Icon(
              Icons.map,
              color: AppColors.background,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
