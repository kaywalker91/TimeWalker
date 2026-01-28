import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

import 'exploration_character_card.dart';

/// 위치 상세 바텀시트
///
/// 시대 탐험 화면에서 특정 위치를 선택했을 때 표시되는 상세 정보 시트입니다.
/// 위치 정보와 해당 위치의 캐릭터 목록을 표시합니다.
class LocationDetailSheet extends ConsumerWidget {
  /// 표시할 위치
  final Location location;

  /// 시대 테마
  final EraTheme theme;

  const LocationDetailSheet({
    super.key,
    required this.location,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            color: AppColors.darkSheet,
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
                    // Location visual placeholder
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.white10,
                      child: Icon(
                        Icons.travel_explore,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white10),

              // Content Section
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
                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...characters.map(
                          (char) => ExplorationCharacterCard(
                            character: char,
                            theme: theme,
                          ),
                        ),
                      ],
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
