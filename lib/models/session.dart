/// Represents a single completed prayer/meditation session.
class PrayerSession {
  final DateTime date;
  final int durationMinutes;

  const PrayerSession({
    required this.date,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
      };

  factory PrayerSession.fromJson(Map<String, dynamic> json) {
    return PrayerSession(
      date: DateTime.parse(json['date'] as String),
      durationMinutes: json['durationMinutes'] as int,
    );
  }

  @override
  String toString() => 'PrayerSession(${date.toIso8601String()}, ${durationMinutes}m)';
}
