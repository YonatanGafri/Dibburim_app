/// Inspiration prompt model and data store.
/// Prompts are used in the Tab 4 card deck and during active
/// sessions (rotating every 60 seconds on screen).
///
/// Currently empty — prompts will be added later.
class InspirationPrompt {
  final String id;
  final String textMale;
  final String textFemale;
  final String category; // e.g., 'gratitude', 'honesty', 'struggle', 'guidance'

  const InspirationPrompt({
    required this.id,
    required this.textMale,
    required this.textFemale,
    required this.category,
  });

  /// Returns the gendered text.
  String getText({bool isFemale = false}) =>
      isFemale ? textFemale : textMale;
}

/// The master list of prompts. Add entries here to populate
/// the card deck (Tab 4) and session prompts (Tab 1).
///
/// Example:
/// ```dart
/// InspirationPrompt(
///   id: 'gratitude_01',
///   textMale: 'מה דבר טוב אחד שקרה לך היום? ספר לבורא תודה על כך.',
///   textFemale: 'מה דבר טוב אחד שקרה לך היום? ספרי לבורא תודה על כך.',
///   category: 'gratitude',
/// ),
/// ```
const List<InspirationPrompt> inspirationPrompts = [
  // Add prompts here in the future.
];
