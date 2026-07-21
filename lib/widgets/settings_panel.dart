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
      child: SingleChildScrollView(
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
  
            // ─── Language Toggle ───
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
                    AppStrings.neutral('languageLabel'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // Toggle chips
                  Row(
                    children: [
                      _GenderChip(
                        label: 'עברית',
                        isSelected: settings.language == 'he',
                        onTap: () => settings.setLanguage('he'),
                      ),
                      const SizedBox(width: 8),
                      _GenderChip(
                        label: 'English',
                        isSelected: settings.language == 'en',
                        onTap: () => settings.setLanguage('en'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
  
            // ─── Theme Toggle ───
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
                    'צבע רקע',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // Toggle chips
                  Row(
                    children: [
                      _GenderChip(
                        label: 'חום',
                        isSelected: !settings.isBlueTheme,
                        activeColor: const Color(0xFFC9A96E),
                        onTap: () => settings.setTheme(false),
                      ),
                      const SizedBox(width: 8),
                      _GenderChip(
                        label: 'תכלת',
                        isSelected: settings.isBlueTheme,
                        activeColor: const Color(0xFF4A90E2),
                        onTap: () => settings.setTheme(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
  
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
                        label: 'זכר',
                        isSelected: !settings.isFemale,
                        onTap: () => settings.setGender(false),
                      ),
                      const SizedBox(width: 8),
                      _GenderChip(
                        label: 'נקבה',
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
                        onChanged: (val) async {
                          final errorMsg = await settings.setReminderEnabled(val);
                          if (errorMsg != null && val && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('שגיאה: $errorMsg'),
                                duration: const Duration(seconds: 8),
                              ),
                            );
                          }
                        },
                        activeThumbColor: AppColors.surface,
                        activeTrackColor: AppColors.primary,
                        inactiveThumbColor: AppColors.surface,
                        inactiveTrackColor: AppColors.divider,
                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DaySelection(settings: settings),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
            textDirection: settings.language == 'en' ? TextDirection.ltr : TextDirection.rtl,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
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
  final Color? activeColor;

  const _GenderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withAlpha(80),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.textOnPrimary : color,
          ),
        ),
      ),
    );
  }
}

class _DaySelection extends StatelessWidget {
  final SettingsProvider settings;

  const _DaySelection({required this.settings});

  @override
  Widget build(BuildContext context) {
    // Days representation: 1=Monday, ..., 7=Sunday.
    // Israeli week starts on Sunday (7), then Monday (1), etc.
    final days = [
      {'id': 7, 'label': 'א'},
      {'id': 1, 'label': 'ב'},
      {'id': 2, 'label': 'ג'},
      {'id': 3, 'label': 'ד'},
      {'id': 4, 'label': 'ה'},
      {'id': 5, 'label': 'ו'},
      {'id': 6, 'label': 'ש'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: days.map((dayData) {
        final dayId = dayData['id'] as int;
        final label = dayData['label'] as String;
        final isSelected = settings.reminderDays.contains(dayId);

        return GestureDetector(
          onTap: () {
            final newDays = List<int>.from(settings.reminderDays);
            if (isSelected) {
              newDays.remove(dayId);
            } else {
              newDays.add(dayId);
            }
            settings.setReminderDays(newDays);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.primary.withAlpha(30),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.primary.withAlpha(80),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

