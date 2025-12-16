import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

class EraExplorationScreen extends ConsumerWidget {
  final String eraId;

  const EraExplorationScreen({super.key, required this.eraId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eraAsync = ref.watch(eraByIdProvider(eraId));
    final locationsAsync = ref.watch(locationListByEraProvider(eraId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: eraAsync.when(
          data: (era) => Text(
            era?.nameKorean ?? 'Exploration',
            style: const TextStyle(
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const Text('Error'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              // Fallback if deep linked or weird state
              context.go(AppRouter.worldMap);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map), // Map/Legend toggle
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline), // Tutorial/Help
            onPressed: () {},
          ),
        ],
      ),
      body: eraAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (era) {
          if (era == null) return const Center(child: Text('Era not found'));

          return locationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text('Error loading locations: $err')),
            data: (locations) =>
                _buildExplorationView(context, ref, era, locations),
          );
        },
      ),
    );
  }

  Widget _buildExplorationView(
    BuildContext context,
    WidgetRef ref,
    Era era,
    List<Location> locations,
  ) {
    return LayoutBuilder(

      builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final screenH = constraints.maxHeight;

        final mapWidth = screenW * 2.5;
        final mapHeight = screenH * 1.2;

        // Center calculation:
        // Target map coordinate: x=0.5 (center), y=0.6 (slightly lower for peninsula)
        // Screen center: screenW/2, screenH/2
        // Offset X = screenW/2 - (0.5 * mapWidth)
        // Offset Y = screenH/2 - (0.6 * mapHeight)
        
        final double initialX = (screenW / 2) - (0.5 * mapWidth);
        final double initialY = (screenH / 2) - (0.6 * mapHeight);

        final TransformationController transformationController =
            TransformationController(
          Matrix4.identity()..translate(initialX, initialY),
        );

        return Stack(
          children: [
            // 1. Scrollable Map Layer
            InteractiveViewer(
              transformationController: transformationController,
              minScale: 0.5,
              maxScale: 3.0,
              constrained: false,
              boundaryMargin:
                  const EdgeInsets.all(300), 
              child: SizedBox(
                width: mapWidth,
                height: mapHeight,
                child: Stack(
                  children: [
                    // Map Background
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: era.theme.backgroundColor,
                          image: DecorationImage(
                            image: AssetImage(era.backgroundAsset),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Location Markers on the virtual map
                    ...locations.map((location) {
                      final left = location.position.x * mapWidth;
                      final top = location.position.y * mapHeight;

                      return _LocationMarker(
                        location: location,
                        eraTheme: era.theme,
                        left: left,
                        top: top,
                        onTap: () => _showLocationDetails(
                            context, ref, location, era.theme),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // 2. HUD Layer (Bottom - Fixed on Screen)
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: _buildHudPanel(context, era),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHudPanel(BuildContext context, Era era) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: era.theme.accentColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: era.theme.primaryColor.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_edu, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Real data connection
                Consumer(
                  builder: (context, ref, child) {
                    final progressAsync = ref.watch(userProgressProvider);

                    return progressAsync.when(
                      data: (progress) {
                        // Get progress for this era
                        final p = progress.getEraProgress(era.id);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Era Progress',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: p,
                                backgroundColor: Colors.white24,
                                color: era.theme.accentColor,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Consumer(
            builder: (context, ref, child) {
              final progressAsync = ref.watch(userProgressProvider);
              return progressAsync.when(
                data: (progress) {
                  final p = progress.getEraProgress(era.id);
                  return Text(
                    '${(p * 100).toInt()}%',
                    style: TextStyle(
                      color: era.theme.accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLocationDetails(
    BuildContext context,
    WidgetRef ref,
    Location location,
    EraTheme theme,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          _LocationDetailSheet(location: location, theme: theme),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  final Location location;
  final EraTheme eraTheme;
  final double left;
  final double top;
  final VoidCallback onTap;

  const _LocationMarker({
    required this.location,
    required this.eraTheme,
    required this.left,
    required this.top,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = !location.isAccessible;

    return Positioned(
      left: left - 40, // Center the 80px width widget
      top: top - 40,
      child: GestureDetector(
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This location is not yet accessible.'),
              ),
            );
          } else {
            onTap();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Marker Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLocked ? Colors.grey[800] : eraTheme.primaryColor,
                border: Border.all(
                  color: isLocked ? Colors.grey : eraTheme.accentColor,
                  width: 3,
                ),
                boxShadow: isLocked
                    ? []
                    : [
                        BoxShadow(
                          color: eraTheme.accentColor.withOpacity(0.6),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: Icon(Icons.place, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            // Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                location.nameKorean,
                style: TextStyle(
                  color: isLocked ? Colors.grey : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationDetailSheet extends ConsumerWidget {
  final Location location;
  final EraTheme theme;

  const _LocationDetailSheet({required this.location, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, you might want to fetch additional details here,
    // but the location object usually has what we need or we fetch characters.
    final charactersAsync = ref.watch(
      characterListByLocationProvider(location.id),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E2C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.nameKorean,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            location.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Large visual for location?
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.white10, // Placeholder
                      child: Icon(
                        Icons.travel_explore,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white10),

              // Characters Section
              Expanded(
                child: charactersAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  data: (characters) {
                    if (characters.isEmpty) {
                      return const Center(
                        child: Text(
                          '이 장소에는 현재 만날 수 있는 인물이 없습니다.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final char = characters[index];
                        return _CharacterCard(character: char, theme: theme);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final EraTheme theme;

  const _CharacterCard({required this.character, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isLocked = !character.isAccessible;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLocked
              ? Colors.transparent
              : theme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: isLocked ? Colors.grey[700] : theme.primaryColor,
          backgroundImage: 
              isLocked ? null : AssetImage(character.portraitAsset),
          child: isLocked
              ? const Icon(Icons.lock, color: Colors.white30)
              : null, // Don't show text if image is loaded
        ),
        title: Text(
          isLocked ? '???' : character.nameKorean,
          style: TextStyle(
            color: isLocked ? Colors.grey : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          isLocked ? '잠겨있음' : character.title,
          style: TextStyle(
            color: isLocked ? Colors.grey[700] : theme.accentColor,
            fontSize: 12,
          ),
        ),
        trailing: isLocked
            ? null
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  // Navigate to Dialogue Screen
                  // For now, assume just the first dialogue ID is valid to start
                  if (character.dialogueIds.isNotEmpty) {
                    AppRouter.goToDialogue(
                      context,
                      character.eraId,
                      character.dialogueIds.first,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No dialogue available for this character yet.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('대화하기'),
              ),
      ),
    );
  }
}
