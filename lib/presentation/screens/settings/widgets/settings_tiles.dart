import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 설정 섹션 헤더
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.info,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

/// 설정 스위치 타일
class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.white70),
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.5)),
              )
            : null,
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.info,
        trackOutlineColor: WidgetStateProperty.all(AppColors.transparent),
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.white70;
        }),
      ),
    );
  }
}

/// 설정 슬라이더 타일
class SettingsSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const SettingsSliderTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: enabled ? AppColors.white70 : AppColors.white38),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: enabled ? AppColors.white : AppColors.white38,
                  ),
                ),
                Slider(
                  value: value,
                  onChanged: enabled ? onChanged : null,
                  activeColor: AppColors.info,
                  inactiveColor: AppColors.white24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 설정 액션 타일
class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? AppColors.red : AppColors.white70),
        title: Text(
          title,
          style: TextStyle(color: isDestructive ? AppColors.red : AppColors.white),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive
              ? AppColors.red.withValues(alpha: 0.5)
              : AppColors.white38,
        ),
        onTap: onTap,
      ),
    );
  }
}

/// 설정 정보 타일
class SettingsInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const SettingsInfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.white)),
          Text(value, style: const TextStyle(color: AppColors.white54)),
        ],
      ),
    );
  }
}
