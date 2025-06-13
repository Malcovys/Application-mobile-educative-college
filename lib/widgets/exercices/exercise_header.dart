import 'package:flutter/material.dart';
import '../../models/exercice_model.dart';

class ExerciseHeader extends StatelessWidget {
  final ExerciceModel exercise;
  final Color subjectColor;
  final VoidCallback onBackPressed;

  const ExerciseHeader({
    super.key,
    required this.exercise,
    required this.subjectColor,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [subjectColor, subjectColor.withAlpha((0.8 * 255).round())],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackPressed,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  exercise.nom,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
