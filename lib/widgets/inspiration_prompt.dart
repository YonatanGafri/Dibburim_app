import 'package:flutter/material.dart';
import '../data/prompts.dart' as prompts_data;
import '../config/theme.dart';

/// Displays the current inspiration prompt during an active session.
/// Fades between prompts smoothly.
class InspirationPromptWidget extends StatelessWidget {
  final prompts_data.InspirationPrompt? prompt;
  final bool isFemale;

  const InspirationPromptWidget({
    super.key,
    required this.prompt,
    required this.isFemale,
  });

  @override
  Widget build(BuildContext context) {
    if (prompt == null) {
      return const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(prompt!.id),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Text(
          prompt!.getText(isFemale: isFemale),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
                height: 1.8,
              ),
        ),
      ),
    );
  }
}
