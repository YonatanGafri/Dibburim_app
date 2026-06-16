import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/prompts.dart';
import '../data/strings.dart';

/// Interactive card deck for drawing inspiration prompts.
/// Currently shows an empty-state message since no cards are loaded.
class CardDeck extends StatefulWidget {
  final bool isFemale;

  const CardDeck({super.key, required this.isFemale});

  @override
  State<CardDeck> createState() => _CardDeckState();
}

class _CardDeckState extends State<CardDeck>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRevealed = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _drawCard() {
    if (inspirationPrompts.isEmpty) return;

    if (_isRevealed) {
      // Go to next card
      _flipController.reverse().then((_) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % inspirationPrompts.length;
          _isRevealed = false;
        });
      });
    } else {
      // Reveal current card
      _flipController.forward();
      setState(() => _isRevealed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (inspirationPrompts.isEmpty) {
      return _buildEmptyState(context);
    }

    final prompt = inspirationPrompts[_currentIndex];

    return Column(
      children: [
        GestureDetector(
          onTap: _drawCard,
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              return Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(60),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: _isRevealed
                      ? FadeTransition(
                          opacity: _flipAnimation,
                          child: Text(
                            prompt.getText(isFemale: widget.isFemale),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(height: 1.8),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: AppColors.primary.withAlpha(150),
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppStrings.neutral('drawCard'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
        if (inspirationPrompts.length > 1) ...[
          const SizedBox(height: 12),
          Text(
            '${_currentIndex + 1} / ${inspirationPrompts.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim.withAlpha(120),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.style_rounded,
              color: AppColors.secondary.withAlpha(120),
              size: 44,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.neutral('noCardsYet'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget — AnimatedBuilder is a renamed AnimatedWidget for clarity.
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
