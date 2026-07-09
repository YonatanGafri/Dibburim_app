/// Represents a single completed prayer/meditation session.
class PrayerSession {
  final DateTime date;
  final int durationMinutes;
  final bool isSynced;

  const PrayerSession({
    required this.date,
    required this.durationMinutes,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'isSynced': isSynced,
      };

  factory PrayerSession.fromJson(Map<String, dynamic> json) {
    return PrayerSession(
      date: DateTime.parse(json['date'] as String),
      durationMinutes: json['durationMinutes'] as int,
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  PrayerSession copyWith({
    DateTime? date,
    int? durationMinutes,
    bool? isSynced,
  }) {
    return PrayerSession(
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  String toString() => 'PrayerSession(${date.toIso8601String()}, ${durationMinutes}m, synced: $isSynced)';
}
