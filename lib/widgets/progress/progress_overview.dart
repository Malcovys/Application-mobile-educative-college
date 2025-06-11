import 'package:flutter/material.dart';
import '../../../../models/progress_model.dart';
import 'progress_indicator.dart';

class ProgressOverview extends StatelessWidget {
  final ThemeData theme;
  final UserProgress? userProgress;
  final double lessonProgress;
  final double exerciseProgress;
  final double examProgress;
  final int completedLessons;
  final int totalLessons;
  final int completedExercises;
  final int totalExercises;
  final int completedExams;
  final int totalExams;

  const ProgressOverview({
    super.key,
    required this.theme,
    required this.userProgress,
    required this.lessonProgress,
    required this.exerciseProgress,
    required this.examProgress,
    required this.completedLessons,
    required this.totalLessons,
    required this.completedExercises,
    required this.totalExercises,
    required this.completedExams,
    required this.totalExams,
  });

  @override
  Widget build(BuildContext context) {
    final overallProgress = userProgress?.overallProgress ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Votre Progrès',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomProgressIndicator(
                  progress: overallProgress,
                  title: 'Progression Globale',
                  subtitle: 'Toutes matières confondues',
                  color: theme.colorScheme.primary,
                  size: 100,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    ProgressRow(
                      label: 'Leçons Terminées',
                      progress: lessonProgress,
                      color: theme.colorScheme.secondary,
                      trailing: '$completedLessons/$totalLessons',
                    ),
                    ProgressRow(
                      label: 'Exercices réussis',
                      progress: exerciseProgress,
                      color: theme.colorScheme.tertiary,
                      trailing: '$completedExercises/$totalExercises',
                    ),
                    ProgressRow(
                      label: 'Examen réussis',
                      progress: examProgress,
                      color: theme.colorScheme.primary,
                      trailing: '$completedExams/$totalExams',
                    ),
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
