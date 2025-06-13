import 'package:flutter/material.dart';
import '../../models/progress_model.dart' as models;

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({
    super.key,
    required this.userProgress,
    required this.theme,
    required this.userName,
  });

  final models.UserProgress? userProgress;
  final ThemeData theme;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👋 Hello, $userName!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Prêt à poursuivre votre apprentissage aujourd’hui?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha((0.9 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }
}
