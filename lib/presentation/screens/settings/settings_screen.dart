import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_walker/presentation/providers/settings_provider.dart';

/// 설정 화면
/// - 사운드/음악 설정
/// - 진동 설정
/// - 접근성 설정
/// - 언어 설정
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
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
          // 사운드 섹션
          _buildSectionHeader(context, 'SOUND'),
          _buildSwitchTile(
            context,
            icon: Icons.volume_up,
            title: 'Sound Effects',
            value: settings.soundEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSound(value);
            },
          ),
          _buildSliderTile(
            context,
            icon: Icons.volume_down,
            title: 'Sound Volume',
            value: settings.soundVolume,
            enabled: settings.soundEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSoundVolume(value);
            },
          ),
          _buildSwitchTile(
            context,
            icon: Icons.music_note,
            title: 'Background Music',
            value: settings.musicEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateMusic(value);
            },
          ),
          _buildSliderTile(
            context,
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
          _buildSectionHeader(context, 'FEEDBACK'),
          _buildSwitchTile(
            context,
            icon: Icons.vibration,
            title: 'Vibration',
            value: settings.vibrationEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateVibration(value);
            },
          ),
          const SizedBox(height: 20),

          // 접근성 섹션
          _buildSectionHeader(context, 'ACCESSIBILITY'),
          _buildSwitchTile(
            context,
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
          _buildSwitchTile(
            context,
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
          _buildSwitchTile(
            context,
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
          _buildSwitchTile(
            context,
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
          _buildSectionHeader(context, 'LANGUAGE'),
          _buildLanguageTile(context, ref, settings.languageCode),
          const SizedBox(height: 30),

          // 기타 정보
          _buildSectionHeader(context, 'ABOUT'),
          _buildInfoTile(context, 'Version', '1.0.0'),
          _buildActionTile(
            context,
            icon: Icons.policy,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: 개인정보처리방침 열기
            },
          ),
          _buildActionTile(
            context,
            icon: Icons.description,
            title: 'Terms of Service',
            onTap: () {
              // TODO: 이용약관 열기
            },
          ),
          _buildActionTile(
            context,
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF00FFFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              )
            : null,
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF00FFFF),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.white70;
        }),
      ),
    );
  }

  Widget _buildSliderTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required double value,
    required bool enabled,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: enabled ? Colors.white70 : Colors.white30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: enabled ? Colors.white : Colors.white30,
                  ),
                ),
                Slider(
                  value: value,
                  onChanged: enabled ? onChanged : null,
                  activeColor: const Color(0xFF00FFFF),
                  inactiveColor: Colors.white24,
                ),
              ],
            ),
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
          dropdownColor: const Color(0xFF16213E),
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

  Widget _buildInfoTile(BuildContext context, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : Colors.white70),
        title: Text(
          title,
          style: TextStyle(color: isDestructive ? Colors.red : Colors.white),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.5)
              : Colors.white30,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('All data deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
