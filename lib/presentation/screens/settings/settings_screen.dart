import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/presentation/providers/settings_provider.dart';
import 'package:time_walker/presentation/screens/settings/widgets/settings_tiles.dart';
import 'package:time_walker/presentation/providers/theme_provider.dart';
import 'package:time_walker/presentation/providers/user_progress_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeStyle = ref.watch(themeProvider);
    final userProgressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.darkSurfaceDeep,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '설정',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.of(context).padding.bottom,
          ),
        children: [
          // 테마 섹션 (외관)
          const SettingsSectionHeader(title: '외관'),
          userProgressAsync.when(
            data: (userProgress) {
              final isUnlocked = userProgress.inventoryIds.contains('theme_dark_mode');
              return SettingsSwitchTile(
                icon: Icons.nightlight_round,
                title: '미드나잇 테마',
                subtitle: isUnlocked ? '특별한 미드나잇 테마 적용' : '잠금 (상점에서 구매)',
                value: themeStyle == AppThemeStyle.midnight,
                onChanged: (value) {
                  if (isUnlocked) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('상점에서 "미드나잇 테마"를 구매하여 잠금 해제하세요!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),

          // 사운드 섹션
          const SettingsSectionHeader(title: '소리'),
          SettingsSwitchTile(
            icon: Icons.volume_up,
            title: '효과음',
            value: settings.soundEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSound(value);
            },
          ),
          SettingsSliderTile(
            icon: Icons.volume_down,
            title: '효과음 볼륨',
            value: settings.soundVolume,
            enabled: settings.soundEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSoundVolume(value);
            },
          ),
          SettingsSwitchTile(
            icon: Icons.music_note,
            title: '배경 음악',
            value: settings.musicEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateMusic(value);
            },
          ),
          SettingsSliderTile(
            icon: Icons.music_off,
            title: '음악 볼륨',
            value: settings.musicVolume,
            enabled: settings.musicEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateMusicVolume(value);
            },
          ),
          const SizedBox(height: 20),

          // 피드백 섹션
          const SettingsSectionHeader(title: '피드백'),
          SettingsSwitchTile(
            icon: Icons.vibration,
            title: '진동',
            value: settings.vibrationEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateVibration(value);
            },
          ),
          const SizedBox(height: 20),

          // 접근성 섹션
          const SettingsSectionHeader(title: '접근성'),
          SettingsSwitchTile(
            icon: Icons.remove_red_eye,
            title: '색맹 모드',
            subtitle: '색상 구분 강화',
            value: settings.accessibility.colorBlindMode,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .updateAccessibility(
                    settings.accessibility.copyWith(colorBlindMode: value),
                  );
            },
          ),
          SettingsSwitchTile(
            icon: Icons.contrast,
            title: '고대비 모드',
            subtitle: '배경 대비 증가',
            value: settings.accessibility.highContrastMode,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .updateAccessibility(
                    settings.accessibility.copyWith(highContrastMode: value),
                  );
            },
          ),
          SettingsSwitchTile(
            icon: Icons.subtitles,
            title: '자막',
            subtitle: '효과음 텍스트 표시',
            value: settings.accessibility.subtitlesEnabled,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .updateAccessibility(
                    settings.accessibility.copyWith(subtitlesEnabled: value),
                  );
            },
          ),
          SettingsSwitchTile(
            icon: Icons.pan_tool,
            title: '한손 모드',
            subtitle: '컨트롤 재배치',
            value: settings.accessibility.oneHandedMode,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .updateAccessibility(
                    settings.accessibility.copyWith(oneHandedMode: value),
                  );
            },
          ),
          const SizedBox(height: 20),

          // 언어 섹션
          const SettingsSectionHeader(title: '언어'),
          _buildLanguageTile(context, ref, settings.languageCode),
          const SizedBox(height: 30),

          // 기타 정보
          const SettingsSectionHeader(title: '앱 정보'),
          const SettingsInfoTile(label: '버전', value: '1.0.0'),
          SettingsActionTile(
            icon: Icons.policy,
            title: '개인정보 처리방침',
            onTap: () {
              // TODO: 개인정보처리방침 열기
            },
          ),
          SettingsActionTile(
            icon: Icons.description,
            title: '이용약관',
            onTap: () {
              // TODO: 이용약관 열기
            },
          ),
          SettingsActionTile(
            icon: Icons.delete_forever,
            title: '모든 데이터 삭제',
            isDestructive: true,
            onTap: () {
              _showDeleteDataDialog(context, ref);
            },
          ),
          const SizedBox(height: 30),

          // 관리자 모드
          const SettingsSectionHeader(title: '관리자'),
          SettingsActionTile(
            icon: Icons.admin_panel_settings,
            title: '관리자 모드',
            onTap: () {
              _showAdminModeDialog(context, ref);
            },
          ),
        ],
        ),
      ),
    );
  }

  void _showAdminModeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text(
          '관리자 모드 활성화',
          style: TextStyle(color: AppColors.white),
        ),
        content: const Text(
          '모든 콘텐츠(지역, 시대, 국가, 인물)가 잠금 해제되고 무제한 리소스가 제공됩니다.\n\n테스트 목적으로만 사용하세요. 현재 진행 상황이 덮어씌워집니다.',
          style: TextStyle(color: AppColors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(userProgressProvider.notifier).unlockAllContent();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('관리자 모드 활성화: 모든 콘텐츠 잠금 해제!'),
                    backgroundColor: AppColors.green,
                  ),
                );
              }
            },
            child: const Text('활성화', style: TextStyle(color: AppColors.amber)),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    WidgetRef ref,
    String currentLanguage,
  ) {
    final languages = {'ko': '한국어', 'en': 'English', 'ja': '日本語'};

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.language, color: AppColors.white70),
        title: const Text('언어 설정', style: TextStyle(color: AppColors.white)),
        trailing: DropdownButton<String>(
          value: currentLanguage,
          dropdownColor: AppColors.darkCard,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.white70),
          items: languages.entries
              .map(
                (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(
                    e.value,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              ref.read(settingsProvider.notifier).updateLanguage(value);
            }
          },
        ),
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text(
          '모든 데이터 삭제',
          style: TextStyle(color: AppColors.white),
        ),
        content: const Text(
          '모든 진행 상황, 최고 점수, 설정이 초기화됩니다. 이 작업은 되돌릴 수 없습니다.',
          style: TextStyle(color: AppColors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 데이터 삭제 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('모든 데이터가 삭제되었습니다')),
              );
            },
            child: const Text('삭제', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}
