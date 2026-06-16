/// FAQ entries for the Inspiration tab (Tab 4).
/// Currently empty — entries will be added later.
class FaqEntry {
  final String question;
  final String answer;
  const FaqEntry({required this.question, required this.answer});
}

/// The list of FAQ entries displayed in the accordion on Tab 4.
///
/// Example:
/// ```dart
/// FaqEntry(
///   question: 'מה לעשות כשמרגישים מנותקים?',
///   answer: 'פשוט תתחיל לדבר, אפילו אם זה "רבונו של עולם, אני לא יודע מה להגיד..."',
/// ),
/// ```
const List<FaqEntry> faqEntries = [
  // Add FAQ entries here in the future.
];
