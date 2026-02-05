import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';

/// Search bar for exploration content filtering
class ExplorationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ExplorationSearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: l10n?.exploration_search_placeholder ?? '장소 검색...',
          hintStyle: TextStyle(color: AppColors.grey500),
          prefixIcon: Icon(Icons.search, color: AppColors.grey500, size: 20),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.grey500, size: 20),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: AppColors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
