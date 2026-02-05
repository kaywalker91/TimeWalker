import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/themes/themes.dart';
import 'package:time_walker/domain/entities/character.dart';
import 'package:time_walker/domain/entities/location.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/era_exploration/widgets/kingdom_label.dart';

/// 왕국별 장소 리스트 바텀시트
/// 
/// 왕국 라벨 탭 시 표시되는 해당 왕국의 장소 목록
class KingdomLocationSheet extends ConsumerWidget {
  final KingdomInfo kingdom;
  final String eraId;
  final Function(Location location) onLocationSelected;

  const KingdomLocationSheet({
    super.key,
    required this.kingdom,
    required this.eraId,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(locationListByEraProvider(eraId));

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceDeep,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: kingdom.color.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          _buildHeader(context),
          
          const Divider(color: AppColors.white12, height: 1),
          
          // 장소 리스트
          Flexible(
            child: locationsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    '장소를 불러올 수 없습니다',
                    style: TextStyle(color: AppColors.white54),
                  ),
                ),
              ),
              data: (locations) {
                // 현재 왕국의 장소만 필터링
                final kingdomLocations = locations
                    .where((loc) => loc.kingdom == kingdom.id)
                    .toList();
                
                if (kingdomLocations.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 48,
                            color: AppColors.white24,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '등록된 장소가 없습니다',
                            style: TextStyle(color: AppColors.white54),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: kingdomLocations.length,
                  separatorBuilder: (_, _) => const Divider(
                    color: AppColors.white12,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final location = kingdomLocations[index];
                    return _LocationListTile(
                      location: location,
                      kingdomColor: kingdom.color,
                      onTap: () {
                        Navigator.of(context).pop();
                        onLocationSelected(location);
                      },
                    );
                  },
                );
              },
            ),
          ),
          
          // 안전 영역
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 왕국 아이콘
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kingdom.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: kingdom.color,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                kingdom.name[0], // 첫 글자
                style: TextStyle(
                  color: kingdom.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 왕국 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kingdom.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: kingdom.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${kingdom.locationCount}개 장소',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 닫기 버튼
          IconButton(
            icon: Icon(Icons.close, color: AppColors.white54),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// 장소 리스트 타일
class _LocationListTile extends ConsumerWidget {
  final Location location;
  final Color kingdomColor;
  final VoidCallback onTap;

  const _LocationListTile({
    required this.location,
    required this.kingdomColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(
      characterListByLocationProvider(location.id),
    );

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        splashColor: kingdomColor.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 장소 썸네일
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kingdomColor.withValues(alpha: 0.5),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(
                    location.backgroundAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: kingdomColor.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.landscape,
                        color: kingdomColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // 장소 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.nameKorean,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    
                    // 캐릭터 아바타들
                    charactersAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (characters) => _buildCharacterAvatars(characters),
                    ),
                  ],
                ),
              ),
              
              // 화살표
              Icon(
                Icons.chevron_right,
                color: kingdomColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterAvatars(List<Character> characters) {
    if (characters.isEmpty) return const SizedBox.shrink();
    
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 캐릭터 아바타 (최대 3개)
          ...characters.take(3).map((char) {
            return Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white24, width: 1),
              ),
              child: ClipOval(
                child: Image.asset(
                  char.portraitAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.greyDark,
                    child: Icon(Icons.person, size: 14, color: AppColors.grey),
                  ),
                ),
              ),
            );
          }),
          
          // 더 많은 캐릭터가 있으면 표시
          if (characters.length > 3)
            Text(
              '+${characters.length - 3}',
              style: TextStyle(
                color: AppColors.white38,
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}
