import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../data/strings.dart';
import '../providers/timer_provider.dart';

/// Quick-toggle buttons for selecting 5 min, 10 min, or custom duration.
class DurationToggle extends StatelessWidget {
  const DurationToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final selected = timerProvider.selectedDurationMinutes;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        _TogglePill(
          label: AppStrings.neutral('minutes5'),
          isSelected: selected == 5,
          onTap: () => timerProvider.setDuration(5),
        ),
        _TogglePill(
          label: AppStrings.neutral('minutes10'),
          isSelected: selected == 10,
          onTap: () => timerProvider.setDuration(10),
        ),
        _TogglePill(
          label: AppStrings.neutral('customTime'),
          isSelected: selected != 5 && selected != 10,
          onTap: () => _showCustomTimePicker(context, timerProvider),
        ),
      ],
    );
  }

  void _showCustomTimePicker(BuildContext context, TimerProvider provider) {
    int customMinutes = provider.selectedDurationMinutes;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppStrings.neutral('customTime'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$customMinutes דקות',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.divider,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withAlpha(30),
                ),
                child: Slider(
                  value: customMinutes.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 59,
                  onChanged: (val) {
                    setState(() => customMinutes = val.round());
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppStrings.neutral('cancel'),
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.setDuration(customMinutes);
                Navigator.pop(ctx);
              },
              child: const Text('אישור'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TogglePill({
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
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceDim.withAlpha(200),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10), // Subtle inner shadow effect alternative
                    blurRadius: 4,
                    offset: const Offset(1, 1),
                  )
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
