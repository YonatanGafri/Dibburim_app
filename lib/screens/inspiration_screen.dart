import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../providers/settings_provider.dart';
import '../widgets/card_deck.dart';
import '../widgets/faq_accordion.dart';

/// Tab 4: השראה (Inspiration) — Guidance & Card Deck
/// Interactive card deck and FAQ accordion.
class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.neutral('inspirationTitle'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 24),

            // Card deck
            CardDeck(isFemale: settingsProvider.isFemale),
            const SizedBox(height: 32),

            // FAQ accordion
            const FaqAccordion(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
