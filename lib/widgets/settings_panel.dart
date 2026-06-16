import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../data/strings.dart';
import '../providers/settings_provider.dart';

/// Settings panel bottom sheet for gender toggle and reminder configuration.
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<SettingsProvider>(),
        child: const SettingsPanel(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            AppStrings.neutral('settingsTitle'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),

          // ─── Gender Toggle ───
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim.withAlpha(100),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.neutral('genderLabel'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // Toggle chips
                Row(
                  children: [
                    _GenderChip(
                      label: 'מדבר',
                      isSelected: !settings.isFemale,
                      onTap: () => settings.setGender(false),
                    ),
                    const SizedBox(width: 8),
                    _GenderChip(
                      label: 'מדברת',
                      isSelected: settings.isFemale,
                      onTap: () => settings.setGender(true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Daily Reminder Toggle ───
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim.withAlpha(100),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.neutral('reminderLabel'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: settings.reminderEnabled,
                      onChanged: (val) => settings.setReminderEnabled(val),
                      activeColor: AppColors.primary,
                      inactiveTrackColor: AppColors.divider,
                    ),
                  ],
                ),

                // Time picker (visible when reminder is enabled)
                if (settings.reminderEnabled) ...[
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _pickTime(context, settings),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.neutral('reminderTime'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            settings.reminderTimeDisplay,
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.primary,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _pickTime(BuildContext context, SettingsProvider settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: AppColors.textOnPrimary,
                  surface: AppColors.surface,
                ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      settings.setReminderTime(picked.hour, picked.minute);
    }
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
