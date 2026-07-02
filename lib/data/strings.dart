/// Centralized Hebrew and English strings.
class AppStrings {
  AppStrings._();
  
  static String currentLanguage = 'he';

  /// Returns the appropriate gendered string.
  static String get(String key, {bool isFemale = false}) {
    final entry = _strings[key];
    if (entry == null) return key;
    if (currentLanguage == 'en') return entry.en;
    return isFemale ? entry.heFemale : entry.heMale;
  }

  /// Returns a non-gendered string.
  static String neutral(String key) {
    final entry = _neutralStrings[key];
    if (entry == null) return key;
    if (currentLanguage == 'en') return entry.en;
    return entry.he;
  }

  // ─── Gendered Strings ───
  static final Map<String, _LocalizedString> _strings = {
    // Tab 1 — Home
    'startButton': const _LocalizedString(
      heMale: 'מתחילים לדבר',
      heFemale: 'מתחילות לדבר',
      en: 'Start Talking',
    ),
    'completionMessage': const _LocalizedString(
      heMale: 'אשריך שהקדשת זמן לנשמה שלך.\nבורא עולם קרוב אליך, ושומע באהבה כל מילה.',
      heFemale: 'אשרייך שהקדשת זמן לנשמה שלך.\nבורא עולם קרוב אליך, ושומע באהבה כל מילה.',
      en: 'Blessed are you for dedicating time to your soul.\nThe Creator is close to you and listens to every word with love.',
    ),
    'streakMessage': const _LocalizedString(
      heMale: 'אתה מתמיד כבר',
      heFemale: 'את מתמידה כבר',
      en: 'You are on a streak of',
    ),
    'monthlyMessage': const _LocalizedString(
      heMale: 'החודש דיברת עם השם',
      heFemale: 'החודש דיברת עם השם',
      en: 'This month you spoke with Hashem',
    ),
    'yearlyMessage': const _LocalizedString(
      heMale: 'השנה צברת',
      heFemale: 'השנה צברת',
      en: 'This year you accumulated',
    ),
    'settingsGenderMale': const _LocalizedString(
      heMale: 'מדבר',
      heFemale: 'מדברת',
      en: 'Male', // Just a fallback for English settings UI if needed
    ),
    // Tips
    'tip1': const _LocalizedString(
      heMale: 'השם שומע אותך ומחכה לתפילה שלך בכל מקום ובכל מדרגה שבה אתה נמצא.',
      heFemale: 'השם שומע אותך ומחכה לתפילה שלך בכל מקום ובכל מדרגה שבה את נמצאת.',
      en: 'Hashem hears you and waits for your prayer wherever you are and whatever your spiritual level.',
    ),
    'tip2': const _LocalizedString(
      heMale: 'דבר אל השם כמו אל החבר הכי טוב שלך.',
      heFemale: 'דברי אל השם כמו אל החבר הכי טוב שלך.',
      en: 'Speak to Hashem as you would to your best friend.',
    ),
    'tip3': const _LocalizedString(
      heMale: 'בכל מקום אתה יכול לדבר עם השם, רצוי לדאוג למקום רגוע ושקט.',
      heFemale: 'בכל מקום את יכולה לדבר עם השם, רצוי לדאוג למקום רגוע ושקט.',
      en: 'You can speak to Hashem anywhere, but finding a quiet and calm place is recommended.',
    ),
    'tip5': const _LocalizedString(
      heMale: 'ספר להשם על ההצלחות, השמחות, הזיכרונות, הכישלונות, האכזבות, החרדות, הפחדים, ובקש עזרה מהבורא.',
      heFemale: 'ספרי להשם על ההצלחות, השמחות, הזיכרונות, הכישלונות, האכזבות, החרדות, הפחדים, ובקשי עזרה מהבורא.',
      en: 'Tell Hashem about your successes, joys, memories, failures, disappointments, anxieties, and fears, and ask for His help.',
    ),
    'tip6': const _LocalizedString(
      heMale: 'אמור תודה להשם על כל הטוב שסובב אותך, תעשה חשבון נפש מה עליך לתקן ולדייק בעצמך, תתפלל ותבקש בקשות.',
      heFemale: 'אמרי תודה להשם על כל הטוב שסובב אותך, תעשי חשבון נפש מה עלייך לתקן ולדייק בעצמך, תתפללי ותבקשי בקשות.',
      en: 'Thank Hashem for all the good around you, reflect on what you need to fix and refine within yourself, and pray for your needs.',
    ),
    'tip7': const _LocalizedString(
      heMale: 'זכור תמיד: השם אוהב אותך אהבה גדולה בכל מצב, אתה בן שלו.',
      heFemale: 'זכרי תמיד: השם אוהב אותך אהבה גדולה בכל מצב, את בת שלו.',
      en: 'Always remember: Hashem loves you with a great love in every situation, you are His child.',
    ),
  };

  // ─── Neutral Strings (no gender difference) ───
  static final Map<String, _NeutralLocalizedString> _neutralStrings = {
    // Tab names
    'tab1': const _NeutralLocalizedString(he: 'ההתבודדות שלי', en: 'My Hitbodedut'),
    'tab2': const _NeutralLocalizedString(he: 'יחד', en: 'Together'),
    'tab3': const _NeutralLocalizedString(he: 'הדרך שלי', en: 'My Journey'),
    'tab4': const _NeutralLocalizedString(he: 'השראה', en: 'Inspiration'),

    // Together Screen
    'tabGeneral': const _NeutralLocalizedString(he: 'כללי', en: 'General'),
    'tabTemple': const _NeutralLocalizedString(he: 'בית המקדש', en: 'The Temple'),
    'templePrayer': const _NeutralLocalizedString(he: '"וְתֶחֱזֶינָה עֵינֵינוּ בְּשׁוּבְךָ לְצִיּוֹן בְּרַחֲמִים"', en: '"May our eyes behold Your return to Zion in mercy"'),
    'templeButton': const _NeutralLocalizedString(he: 'התפללתי עכשיו', en: 'I prayed just now'),
    'templeSubtitle': const _NeutralLocalizedString(he: 'יחד בתפילה משותפת לבניין בית המקדש.', en: 'Together in shared prayer for the building of the Temple.'),

    // Tips
    'tip4': const _NeutralLocalizedString(he: 'אפשר להיעזר במחברת ולכתוב בה את אשר על ליבך.', en: 'You can use a notebook to write whatever is on your heart.'),

    // Duration toggles
    'minutes5': const _NeutralLocalizedString(he: '5 דקות', en: '5 Minutes'),
    'minutes10': const _NeutralLocalizedString(he: '10 דקות', en: '10 Minutes'),
    'customTime': const _NeutralLocalizedString(he: 'מותאם אישית', en: 'Custom'),

    // Session
    'finish': const _NeutralLocalizedString(he: 'סיום', en: 'Done'),
    'cancel': const _NeutralLocalizedString(he: 'ביטול', en: 'Cancel'),
    'pause': const _NeutralLocalizedString(he: 'השהיה', en: 'Pause'),
    'continueTalking': const _NeutralLocalizedString(he: 'להמשיך לדבר', en: 'Keep Talking'),

    // Tab 2
    'togetherTitle': const _NeutralLocalizedString(he: 'יחד', en: 'Together'),
    'globalCounterText': const _NeutralLocalizedString(he: 'היום זכו', en: 'Today,'),
    'globalCounterSuffix': const _NeutralLocalizedString(he: 'יהודים להתבודד ולשפוך שיח', en: 'Jews took time to speak with Hashem'),
    'infoModalVerse': const _NeutralLocalizedString(he: 'מה אנחנו עושים כאן?', en: 'What are we doing here?'),
    'infoModalExplanation': const _NeutralLocalizedString(
      he: 'זהו רגע של חיבור. המטרה כאן פשוטה: לעצור ולהתפלל אפילו משפט אחד על בית המקדש.\n\n'
        '• מקדש מעט פרטי: בהיעדר המקדש, העצירה לתפילה נחשבת כקורבן. התפילה אינה רק מבטאת רגש קיים, אלא היא כלי שבונה רגש חדש וכמיהה.\n'
        '• להתחבר ל"ביחד": בית המקדש הוא מוקד האחדות שלנו. כשאנחנו מתפללים עליו, אנו מתחברים לאהבת חינם.\n'
        '• תיקון עולם: בית המקדש הוא "בית תפילה לכל העמים" ונועד להקרין שפע, צדק ומוסר לכל האנושות.\n\n'
        'ואם הלב מרגיש קצת אטום, אפשר פשוט לומר:\n'
        '"ריבונו של עולם, תן לי רצון וגעגוע לבית המקדש."\n\n'
        'שיבנה בית המקדש במהרה בימינו, ותן חלקנו בתורתך.',
      en: 'This is a moment of connection. The goal here is simple: pause and pray even one sentence for the Temple.\n\n'
        '• A private miniature Temple: In the absence of the Temple, pausing to pray is considered a sacrifice. Prayer doesn\'t just express an existing emotion, it is a tool that builds new emotion and yearning.\n'
        '• Connecting to "Togetherness": The Temple is our center of unity. When we pray for it, we connect to unconditional love.\n'
        '• Tikun Olam (Repairing the world): The Temple is a "House of prayer for all nations" meant to project abundance, justice, and morality to all of humanity.\n\n'
        'And if the heart feels a bit blocked, you can simply say:\n'
        '"Master of the Universe, give me a desire and longing for the Temple."\n\n'
        'May the Temple be rebuilt speedily in our days, and grant us our portion in Your Torah.'
    ),

    // Tab 3
    'journeyTitle': const _NeutralLocalizedString(he: 'הדרך שלי', en: 'My Journey'),
    'daysInRow': const _NeutralLocalizedString(he: 'ימים ברצף!', en: 'Days in a row!'),
    'timesThisMonth': const _NeutralLocalizedString(he: 'פעמים', en: 'times'),
    'minutesThisYear': const _NeutralLocalizedString(he: 'דקות של דיבורים', en: 'minutes of talking'),

    // Tab 4
    'inspirationTitle': const _NeutralLocalizedString(he: 'השראה', en: 'Inspiration'),
    'drawCard': const _NeutralLocalizedString(he: 'משוך כרטיס', en: 'Draw a Card'),
    'noCardsYet': const _NeutralLocalizedString(he: 'כרטיסי השראה יתווספו בקרוב...', en: 'Inspiration cards will be added soon...'),
    'faqTitle': const _NeutralLocalizedString(he: 'שאלות נפוצות', en: 'FAQ'),

    // Settings
    'settingsTitle': const _NeutralLocalizedString(he: 'הגדרות', en: 'Settings'),
    'genderLabel': const _NeutralLocalizedString(he: 'לשון פנייה', en: 'Form of Address'),
    'reminderLabel': const _NeutralLocalizedString(he: 'תזכורת יומית', en: 'Daily Reminder'),
    'reminderTime': const _NeutralLocalizedString(he: 'שעת תזכורת', en: 'Reminder Time'),
    'languageLabel': const _NeutralLocalizedString(he: 'שפה', en: 'Language'),

    // Notification
    'reminderNotificationTitle': const _NeutralLocalizedString(he: 'דיבורים', en: 'Dibburim'),
    'reminderNotificationBody': const _NeutralLocalizedString(he: 'יש לך 5 דקות פנויות? השם מחכה לדיבורים איתך.', en: 'Have 5 free minutes? Hashem is waiting to speak with you.'),

    // Calendar
    'calendarSessionCompleted': const _NeutralLocalizedString(he: 'בוצעה התבודדות:', en: 'Hitbodedut completed:'),
    'calendarSessionNotCompleted': const _NeutralLocalizedString(he: 'לא בוצעה התבודדות ביום זה', en: 'No Hitbodedut on this day'),
    'calendarDidYouPray': const _NeutralLocalizedString(he: 'האם זכית להתפלל?', en: 'Did you pray?'),

    // Together Screen specific
    'togetherPrayedSuccess': const _NeutralLocalizedString(he: 'זכית להתפלל על בית המקדש!', en: 'You merited to pray for the Temple!'),

    // Profile Screen
    'profileTitle': const _NeutralLocalizedString(he: 'פרופיל אישי', en: 'Personal Profile'),
    'profileGuest': const _NeutralLocalizedString(he: 'אורח', en: 'Guest'),
    'profileLogout': const _NeutralLocalizedString(he: 'התנתק', en: 'Log Out'),
    'profileDeleteAccount': const _NeutralLocalizedString(he: 'מחק חשבון לצמיתות', en: 'Delete Account Permanently'),
    'profileDeletePolicy': const _NeutralLocalizedString(he: 'מחיקת חשבון נדרשת כחלק ממדיניות גוגל פליי להגנה על פרטיות המשתמש.', en: 'Account deletion is required as part of Google Play policy to protect user privacy.'),
    'profileDeleteDialogTitle': const _NeutralLocalizedString(he: 'מחיקת חשבון לצמיתות', en: 'Permanently Delete Account'),
    'profileDeleteDialogContent': const _NeutralLocalizedString(he: 'האם אתה בטוח שברצונך למחוק את החשבון? פעולה זו תמחק לצמיתות את כל המידע השמור שלך ולא ניתנת לביטול.', en: 'Are you sure you want to delete your account? This action will permanently delete all your saved data and cannot be undone.'),
    'profileDeleteDialogInstructions': const _NeutralLocalizedString(he: 'כדי לאשר, אנא הקלד את המילה "מחק" בתיבה למטה:', en: 'To confirm, please type the word "DELETE" in the box below:'),
    'profileDeleteDialogHint': const _NeutralLocalizedString(he: 'מחק', en: 'DELETE'),
    'profileDeleteDialogCancel': const _NeutralLocalizedString(he: 'ביטול', en: 'Cancel'),
    'profileDeleteDialogConfirm': const _NeutralLocalizedString(he: 'מחק חשבון', en: 'Delete Account'),
    'profileDeleteSuccess': const _NeutralLocalizedString(he: 'החשבון נמחק בהצלחה.', en: 'Account deleted successfully.'),
    'profileDeleteError': const _NeutralLocalizedString(he: 'שגיאה במחיקת החשבון:', en: 'Error deleting account:'),
  };
}

class _LocalizedString {
  final String heMale;
  final String heFemale;
  final String en;
  const _LocalizedString({required this.heMale, required this.heFemale, required this.en});
}

class _NeutralLocalizedString {
  final String he;
  final String en;
  const _NeutralLocalizedString({required this.he, required this.en});
}
