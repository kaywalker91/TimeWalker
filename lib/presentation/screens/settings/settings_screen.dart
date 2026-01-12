import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: SettingsColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 테마 섹션 (APPEARANCE)
          const SettingsSectionHeader(title: 'APPEARANCE'),
          userProgressAsync.when(
            data: (userProgress) {
              final isUnlocked = userProgress.inventoryIds.contains('theme_dark_mode');
              return SettingsSwitchTile(
                icon: Icons.nightlight_round,
                title: 'Midnight Theme',
                subtitle: isUnlocked ? 'Apply the special midnight theme' : 'Locked (Purchase in Shop)',
                value: themeStyle == AppThemeStyle.midnight,
                onChanged: (value) {
                  if (isUnlocked) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Purchase "Midnight Theme" in the Shop to unlock!'),
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
          const SettingsSectionHeader(title: 'SOUND'),
          SettingsSwitchTile(
            icon: Icons.volume_up,
            title: 'Sound Effects',
            value: settings.soundEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSound(value);
            },
          ),
          SettingsSliderTile(
            icon: Icons.volume_down,
            title: 'Sound Volume',
            value: settings.soundVolume,
            enabled: settings.soundEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSoundVolume(value);
            },
          ),
          SettingsSwitchTile(
            icon: Icons.music_note,
            title: 'Background Music',
            value: settings.musicEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateMusic(value);
            },
          ),
          SettingsSliderTile(
            icon: Icons.music_off,
            title: 'Music Volume',
            value: settings.musicVolume,
            enabled: settings.musicEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateMusicVolume(value);
            },
          ),
          const SizedBox(height: 20),

          // 피드백 섹션
          const SettingsSectionHeader(title: 'FEEDBACK'),
          SettingsSwitchTile(
            icon: Icons.vibration,
            title: 'Vibration',
            value: settings.vibrationEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateVibration(value);
            },
          ),
          const SizedBox(height: 20),

          // 접근성 섹션
          const SettingsSectionHeader(title: 'ACCESSIBILITY'),
          SettingsSwitchTile(
            icon: Icons.remove_red_eye,
            title: 'Color Blind Mode',
            subtitle: 'Enhance visual distinction',
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
            title: 'High Contrast',
            subtitle: 'Increase background contrast',
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
            title: 'Subtitles',
            subtitle: 'Show sound effect text',
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
            title: 'One-Handed Mode',
            subtitle: 'Rearrange controls',
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
          const SettingsSectionHeader(title: 'LANGUAGE'),
          _buildLanguageTile(context, ref, settings.languageCode),
          const SizedBox(height: 30),

          // 기타 정보
          const SettingsSectionHeader(title: 'ABOUT'),
          const SettingsInfoTile(label: 'Version', value: '1.0.0'),
          SettingsActionTile(
            icon: Icons.policy,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: 개인정보처리방침 열기
            },
          ),
          SettingsActionTile(
            icon: Icons.description,
            title: 'Terms of Service',
            onTap: () {
              // TODO: 이용약관 열기
            },
          ),
          SettingsActionTile(
            icon: Icons.delete_forever,
            title: 'Delete All Data',
            isDestructive: true,
            onTap: () {
              _showDeleteDataDialog(context, ref);
            },
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
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.white70),
        title: const Text('Language', style: TextStyle(color: Colors.white)),
        trailing: DropdownButton<String>(
          value: currentLanguage,
          dropdownColor: SettingsColors.surface,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          items: languages.entries
              .map(
                (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(
                    e.value,
                    style: const TextStyle(color: Colors.white),
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
        backgroundColor: SettingsColors.surface,
        title: const Text(
          'Delete All Data?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will reset all your progress, high scores, and settings. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 데이터 삭제 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
