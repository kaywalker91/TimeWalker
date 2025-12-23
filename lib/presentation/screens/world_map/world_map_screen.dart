import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/game/world_map_game.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(regionListProvider);
    final userProgressAsync = ref.watch(userProgressProvider);

    // BGM 시작 (월드맵 BGM)
    final currentTrack = ref.watch(currentBgmTrackProvider);
    if (currentTrack != AudioConstants.bgmWorldMap) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bgmControllerProvider.notifier).playWorldMapBgm();
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.world_map_title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1a1a2e), // Dark background for areas outside map
        ),
        child: regionsAsync.when(
          data: (regions) => userProgressAsync.when(
            data: (userProgress) => _buildMapLayout(context, regions, userProgress),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading progress: $err')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error loading regions: $err')),
        ),
      ),
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
          ),
        );
      },
      onRegionTapped: (region) {
        final isUnlocked = userProgress.isRegionUnlocked(region.id) ||
            region.status == ContentStatus.available;
        
        if (isUnlocked) {
          context.pushNamed(
            'regionDetail',
            pathParameters: {'regionId': region.id},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.world_map_locked_msg(region.nameKorean)),
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
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.world_map_current_location,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                AppLocalizations.of(context)!.world_map_location_test,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(Icons.map, color: Colors.amber),
        ],
      ),
    );
  }
}
