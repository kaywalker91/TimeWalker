import 'package:flutter/material.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/routes/app_router.dart';
import 'package:time_walker/core/utils/responsive_utils.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/widgets/tutorial_overlay.dart';

class EraExplorationScreen extends ConsumerWidget {
  final String eraId;

  const EraExplorationScreen({super.key, required this.eraId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eraAsync = ref.watch(eraByIdProvider(eraId));
    final locationsAsync = ref.watch(locationListByEraProvider(eraId));
    final userProgressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: eraAsync.when(
          data: (era) => Text(
            era?.nameKorean ?? AppLocalizations.of(context)!.exploration_title_default,
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
          if (era == null) return Center(child: Text(AppLocalizations.of(context)!.exploration_era_not_found));

          return locationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text(AppLocalizations.of(context)!.exploration_location_error(err.toString()))),
            data: (locations) {
              return userProgressAsync.when(
                data: (userProgress) {
                  final showTutorial = !userProgress.hasCompletedTutorial;
                  final content = _buildExplorationView(context, ref, era, locations);

                  if (showTutorial) {
                    return TutorialOverlay(
                      message: AppLocalizations.of(context)!.exploration_tutorial_msg,
                      onDismiss: () async {
                        final newProgress = userProgress.copyWith(hasCompletedTutorial: true);
                        await ref.read(userProgressRepositoryProvider).saveUserProgress(newProgress);
                        ref.invalidate(userProgressProvider);
                      },
                      child: content,
                    );
                  }
                  return content;
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Error loading progress')),
              );
            },
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
    final responsive = context.responsive;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final screenH = constraints.maxHeight;

        final mapWidth = screenW * 2.5;
        final mapHeight = screenH * 1.2;

        final double initialX = (screenW / 2) - (0.5 * mapWidth);
        final double initialY = (screenH / 2) - (0.6 * mapHeight);

        final TransformationController transformationController =
            TransformationController(
          Matrix4.identity()..setTranslationRaw(initialX, initialY, 0),
        );

        // Responsive marker size
        final markerSize = responsive.markerSize(50);
        final hudPadding = responsive.padding(20);
        final hudBottom = responsive.spacing(40);

        return Stack(
          children: [
            // 1. Scrollable Map Layer
            InteractiveViewer(
              transformationController: transformationController,
              minScale: 0.5,
              maxScale: 3.0,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(300),
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
                              Colors.black.withValues(alpha: 0.3),
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
                        markerSize: markerSize,
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
              left: hudPadding,
              right: hudPadding,
              bottom: hudBottom,
              child: _buildHudPanel(context, era, responsive),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHudPanel(BuildContext context, Era era, ResponsiveUtils responsive) {
    final horizontalPadding = responsive.padding(20);
    final verticalPadding = responsive.padding(16);
    final iconSize = responsive.iconSize(24);
    final fontSize = responsive.fontSize(12);
    final percentFontSize = responsive.fontSize(18);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: era.theme.accentColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(8)),
            decoration: BoxDecoration(
              color: era.theme.primaryColor.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_edu, color: Colors.white, size: iconSize),
          ),
          SizedBox(width: responsive.spacing(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final progressAsync = ref.watch(userProgressProvider);

                    return progressAsync.when(
                      data: (progress) {
                        final p = progress.getEraProgress(era.id);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.exploration_progress_label,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: fontSize,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: p,
                                backgroundColor: Colors.white24,
                                color: era.theme.accentColor,
                                minHeight: responsive.isSmallPhone ? 4 : 6,
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
          SizedBox(width: responsive.spacing(16)),
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
                      fontSize: percentFontSize,
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
  final double markerSize;
  final VoidCallback onTap;

  const _LocationMarker({
    required this.location,
    required this.eraTheme,
    required this.left,
    required this.top,
    required this.markerSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = !location.isAccessible;
    final iconSize = markerSize * 0.56; // proportional
    final labelFontSize = markerSize * 0.24;

    return Positioned(
      left: left - markerSize * 0.8,
      top: top - markerSize * 0.8,
      child: GestureDetector(
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.exploration_location_locked),
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
              width: markerSize,
              height: markerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLocked ? Colors.grey[800] : eraTheme.primaryColor,
                border: Border.all(
                  color: isLocked ? Colors.grey : eraTheme.accentColor,
                  width: markerSize * 0.06,
                ),
                boxShadow: isLocked
                    ? []
                    : [
                        BoxShadow(
                          color: eraTheme.accentColor.withValues(alpha: 0.6),
                          blurRadius: markerSize * 0.3,
                          spreadRadius: markerSize * 0.04,
                        ),
                      ],
              ),
              child: Icon(Icons.place, color: Colors.white, size: iconSize),
            ),
            SizedBox(height: markerSize * 0.16),
            // Label
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: markerSize * 0.16,
                vertical: markerSize * 0.08,
              ),
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
                  fontSize: labelFontSize,
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
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.exploration_no_characters,
                          style: const TextStyle(color: Colors.grey),
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
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLocked
              ? Colors.transparent
              : theme.primaryColor.withValues(alpha: 0.3),
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
          isLocked ? AppLocalizations.of(context)!.common_unknown_character : character.nameKorean,
          style: TextStyle(
            color: isLocked ? Colors.grey : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          isLocked ? AppLocalizations.of(context)!.common_locked_status : character.title,
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
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.exploration_no_dialogue,
                        ),
                      ),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.common_talk),
              ),
      ),
    );
  }
}
