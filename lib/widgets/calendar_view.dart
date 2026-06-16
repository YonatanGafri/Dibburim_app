import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

/// Monthly calendar view with golden checkmarks on completed days.
class CalendarView extends StatefulWidget {
  final Set<DateTime> completedDates;

  const CalendarView({super.key, required this.completedDates});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isCompleted(int day) {
    final date = DateTime(_currentMonth.year, _currentMonth.month, day);
    return widget.completedDates.contains(date);
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return day == now.day &&
        _currentMonth.month == now.month &&
        _currentMonth.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    // Hebrew calendar starts on Sunday (weekday 7 in Dart)
    final startOffset = firstWeekday % 7;

    final monthName = DateFormat.yMMMM('he').format(_currentMonth);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _nextMonth, // RTL: right arrow = next
                icon: const Icon(Icons.chevron_right_rounded),
                color: AppColors.primary,
              ),
              Text(
                monthName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: _previousMonth, // RTL: left arrow = previous
                icon: const Icon(Icons.chevron_left_rounded),
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Weekday headers (Sunday-Saturday in Hebrew)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ש']
                .map(
                  (day) => SizedBox(
                    width: 36,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) {
                return const SizedBox.shrink();
              }

              final day = index - startOffset + 1;
              final completed = _isCompleted(day);
              final today = _isToday(day);

              return Container(
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.primary.withAlpha(20)
                      : today
                          ? AppColors.surfaceDim
                          : Colors.transparent,
                  shape: BoxShape.circle,
                  border: today
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: completed
                      ? Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                          size: 18,
                        )
                      : Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 13,
                            color: today
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight:
                                today ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
