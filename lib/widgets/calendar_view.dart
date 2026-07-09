import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kosher_dart/kosher_dart.dart';
import '../config/theme.dart';
import '../data/strings.dart';
import '../models/session.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../data/strings.dart';
/// Monthly calendar view with Hebrew dates, Shabbat Parashat Hashavua, and hitbodedut details.
class CalendarView extends StatefulWidget {
  final List<PrayerSession> sessions;

  const CalendarView({super.key, required this.sessions});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
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
    final targetDate = DateTime(_currentMonth.year, _currentMonth.month, day);
    return widget.sessions.any((s) =>
        s.date.year == targetDate.year &&
        s.date.month == targetDate.month &&
        s.date.day == targetDate.day);
  }

  int _getDurationForDate(DateTime date) {
    return widget.sessions
        .where((s) =>
            s.date.year == date.year &&
            s.date.month == date.month &&
            s.date.day == date.day)
        .fold<int>(0, (sum, s) => sum + s.durationMinutes);
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return day == now.day &&
        _currentMonth.month == now.month &&
        _currentMonth.year == now.year;
  }

  Future<void> _showAddSessionDialog(BuildContext context, DateTime date) async {
    final TextEditingController minutesController = TextEditingController();
    
    final minutes = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            AppStrings.neutral('calendarDidYouPray'),
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'כמה דקות הקדשת להתבודדות ביום זה?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'לדוגמה: 15',
                  suffixText: 'דקות',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ביטול'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final val = int.tryParse(minutesController.text) ?? 0;
                if (val > 0) {
                  Navigator.pop(context, val);
                }
              },
              child: const Text('עדכון'),
            ),
          ],
        );
      },
    );

    if (minutes != null && minutes > 0 && context.mounted) {
      context.read<SessionProvider>().recordSession(minutes, date: date);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('הזמן עודכן בהצלחה!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildSelectedDayDetails() {
    if (_selectedDay == null) return const SizedBox.shrink();

    final selectedDate = _selectedDay!;
    final jc = JewishCalendar()..setDate(selectedDate);
    
    // Format Hebrew date: e.g. "ד׳ תמוז תשפ״ו"
    final formatter = HebrewDateFormatter()
      ..hebrewFormat = true
      ..useGershGershayim = true;
    final hebrewDateStr = formatter.format(jc);

    // Full Gregorian date
    final gregorianDateStr = DateFormat('EEEE, d MMMM yyyy', 'he').format(selectedDate);

    // Shabbat Parasha
    final isShabbat = selectedDate.weekday == DateTime.saturday;
    String? parshaStr;
    if (isShabbat) {
      final rawParsha = formatter.formatWeeklyParsha(jc);
      if (rawParsha.isNotEmpty) {
        parshaStr = 'פרשת $rawParsha';
      }
    }

    // Session duration
    final duration = _getDurationForDate(selectedDate);
    final hasCompleted = duration > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.secondary.withAlpha(20),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hebrewDateStr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gregorianDateStr,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (parshaStr != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withAlpha(40)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        parshaStr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Icon(
                hasCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: hasCompleted ? AppColors.primary : AppColors.textSecondary.withAlpha(100),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasCompleted
                      ? '${AppStrings.neutral('calendarSessionCompleted')} $duration '
                      : AppStrings.neutral('calendarSessionNotCompleted'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: hasCompleted ? FontWeight.w600 : FontWeight.w400,
                    color: hasCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
              if (!hasCompleted && !selectedDate.isAfter(DateTime.now()))
                TextButton.icon(
                  onPressed: () => _showAddSessionDialog(context, selectedDate),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('השלמה'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
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

    // Formatter for individual grid cells (no Gersh/Gershayim for clean looks)
    final cellFormatter = HebrewDateFormatter()
      ..hebrewFormat = true
      ..useGershGershayim = false;

    return Column(
      children: [
        Container(
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
                children: const ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ש']
                    .map(
                      (day) => Expanded(
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
                  
                  final cellDate = DateTime(_currentMonth.year, _currentMonth.month, day);
                  final isSelected = _selectedDay != null &&
                      _selectedDay!.year == cellDate.year &&
                      _selectedDay!.month == cellDate.month &&
                      _selectedDay!.day == cellDate.day;

                  final cellJewishDate = JewishDate()..setDate(cellDate);
                  final hebrewDayStr = cellFormatter.formatHebrewNumber(cellJewishDate.getJewishDayOfMonth());

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = cellDate;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : completed
                                ? AppColors.primary.withAlpha(25)
                                : today
                                    ? AppColors.surfaceDim
                                    : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? null
                            : today
                                ? Border.all(color: AppColors.primary, width: 1.5)
                                : null,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected
                                    ? AppColors.textOnPrimary
                                    : today
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                fontWeight: isSelected || today
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hebrewDayStr,
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? AppColors.textOnPrimary.withAlpha(200)
                                    : AppColors.textSecondary.withAlpha(180),
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                height: 1.1,
                              ),
                            ),
                            if (completed) ...[
                              const SizedBox(height: 2),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 6),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSelectedDayDetails(),
      ],
    );
  }
}
