import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(regionListProvider);
    final userProgressAsync = ref.watch(userProgressProvider);

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final screenH = constraints.maxHeight;

        // Virtual map is larger than screen for panning
        final mapWidth = screenW * 2.5;
        final mapHeight = screenH * 2.0;

        // Initial position: center on Eurasia (approximately x=0.55, y=0.35)
        // Offset calculation: screenCenter - (targetMapCoord * mapSize)
        final double initialX = (screenW / 2) - (0.55 * mapWidth);
        final double initialY = (screenH / 2) - (0.35 * mapHeight);

        final TransformationController transformationController =
            TransformationController(
          Matrix4.identity()..setTranslationRaw(initialX, initialY, 0),
        );

        return Stack(
          children: [
            // Scrollable/Pannable Map Layer
            InteractiveViewer(
              transformationController: transformationController,
              minScale: 0.5,
              maxScale: 3.0,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: SizedBox(
                width: mapWidth,
                height: mapHeight,
                child: Stack(
                  children: [
                    // Map Background
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/map/world_map.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Grid Overlay
                    Positioned.fill(child: CustomPaint(painter: GridPainter())),

                    // Region Markers on the virtual map
                    ...regions.map((region) {
                      final isUnlocked = userProgress.isRegionUnlocked(region.id) ||
                          region.status == ContentStatus.available;

                      final left = region.center.x * mapWidth;
                      final top = region.center.y * mapHeight;

                      return Positioned(
                        left: left - 40, // Center the 80px widget
                        top: top - 40,
                        child: _RegionMarker(
                          region: region,
                          isLocked: !isUnlocked,
                        ),
                      );
                    }),
                  ],
                ),
              ),
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
      },
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

class _RegionMarker extends StatelessWidget {
  final Region region;
  final bool isLocked;

  const _RegionMarker({
    required this.region,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.world_map_locked_msg(region.nameKorean)),
            ),
          );
        } else {
          context.pushNamed(
            'regionDetail',
            pathParameters: {'regionId': region.id},
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked
                  ? Colors.grey[800]
                  : Colors.amber.withValues(alpha: 0.2),
              border: Border.all(
                color: isLocked ? Colors.grey : Colors.amber,
                width: 2,
              ),
              boxShadow: isLocked
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.4),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
            ),
            child: Icon(
              isLocked ? Icons.lock : Icons.public,
              color: isLocked ? Colors.grey : Colors.amber,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              region.nameKorean,
              style: TextStyle(
                color: isLocked ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    // Draw latitude/longitude lines
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
