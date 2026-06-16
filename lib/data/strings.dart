/// Centralized Hebrew strings with male/female variants.
/// Usage: AppStrings.get('startButton', isFemale: false)
class AppStrings {
  AppStrings._();

  /// Returns the appropriate gendered string.
  static String get(String key, {bool isFemale = false}) {
    final entry = _strings[key];
    if (entry == null) return key;
    return isFemale ? entry.female : entry.male;
  }

  /// Returns a non-gendered string.
  static String neutral(String key) {
    return _neutralStrings[key] ?? key;
  }

  // ─── Gendered Strings ───
  static final Map<String, _GenderedString> _strings = {
    // Tab 1 — Home
    'startButton': _GenderedString(
      male: 'מתחילים לדבר',
      female: 'מתחילות לדבר',
    ),
    'completionMessage': _GenderedString(
      male: 'אשריך, קדשת את הזמן שלך.\nהשם שמע את הדיבורים שלך.',
      female: 'אשריך, קדשת את הזמן שלך.\nהשם שמע את הדיבורים שלך.',
    ),
    'streakMessage': _GenderedString(
      male: 'אתה מתמיד כבר',
      female: 'את מתמידה כבר',
    ),
    'monthlyMessage': _GenderedString(
      male: 'החודש דיברת עם השם',
      female: 'החודש דיברת עם השם',
    ),
    'yearlyMessage': _GenderedString(
      male: 'השנה צברת',
      female: 'השנה צברת',
    ),
    'settingsGenderMale': _GenderedString(
      male: 'מדבר',
      female: 'מדברת',
    ),
  };

  // ─── Neutral Strings (no gender difference) ───
  static final Map<String, String> _neutralStrings = {
    // Tab names
    'tab1': 'ההתבודדות שלי',
    'tab2': 'יחד',
    'tab3': 'הדרך שלי',
    'tab4': 'השראה',

    // Duration toggles
    'minutes5': '5 דקות',
    'minutes10': '10 דקות',
    'customTime': 'מותאם אישית',

    // Session
    'finish': 'סיום',
    'cancel': 'ביטול',
    'pause': 'השהיה',

    // Tab 2
    'togetherTitle': 'יחד',
    'globalCounterText': 'היום זכו',
    'globalCounterSuffix': 'יהודים להתבודד ולשפוך שיח',
    'infoModalVerse':
        'כִּי בֵיתִי בֵּית תְּפִלָּה יִקָּרֵא לְכָל הָעַמִּים\n(ישעיהו נו:ז)',
    'infoModalExplanation':
        'כל תפילה אישית שאנחנו מתפללים בונה לבנה נוספת '
        'בבית המקדש שבלב. כשכולנו מתחברים יחד בתפילה, '
        'אנחנו בונים את בית המקדש הרוחני של כלל ישראל.',

    // Tab 3
    'journeyTitle': 'הדרך שלי',
    'daysInRow': 'ימים ברצף!',
    'timesThisMonth': 'פעמים',
    'minutesThisYear': 'דקות של דיבורים',

    // Tab 4
    'inspirationTitle': 'השראה',
    'drawCard': 'משוך כרטיס',
    'noCardsYet': 'כרטיסי השראה יתווספו בקרוב...',
    'faqTitle': 'שאלות נפוצות',

    // Settings
    'settingsTitle': 'הגדרות',
    'genderLabel': 'לשון פנייה',
    'reminderLabel': 'תזכורת יומית',
    'reminderTime': 'שעת תזכורת',

    // Notification
    'reminderNotificationTitle': 'דיבורים',
    'reminderNotificationBody': 'יש לך 5 דקות פנויות? השם מחכה לדיבורים איתך.',
  };
}

class _GenderedString {
  final String male;
  final String female;
  const _GenderedString({required this.male, required this.female});
}
