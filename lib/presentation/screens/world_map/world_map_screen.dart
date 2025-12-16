import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(regionListProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('TimeWalker World Map'),
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
          color: Color(0xFF2C1B18), // Dark parchment color
          // TODO: Add actual world map background image
          // image: DecorationImage(
          //   image: AssetImage('assets/images/map/world_map_bg.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: regionsAsync.when(
          data: (regions) => _buildMapLayout(context, regions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildMapLayout(BuildContext context, List<Region> regions) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            // Background Elements (Grid, Decor)
            Positioned.fill(child: CustomPaint(painter: GridPainter())),

            // Region Markers
            ...regions.map(
              (region) => Positioned(
                left: region.center.x * width - 40, // Center based on icon size
                top: region.center.y * height - 40,
                child: _RegionMarker(region: region),
              ),
            ),

            // Current Status UI (Bottom)
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Location',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                'Asia - Korea',
                style: TextStyle(
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

  const _RegionMarker({required this.region});

  @override
  Widget build(BuildContext context) {
    final isLocked = !region.isAccessible;

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${region.nameKorean} is currently locked.'),
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
