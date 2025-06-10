import 'package:flutter/material.dart';
import '../../models/exercise_model.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentQuestionIndex;
  final ExerciseModel exercise;
  final Color subjectColor;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentQuestionIndex,
    required this.exercise,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (currentQuestionIndex + 1) / exercise.questions.length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} sur ${exercise.questions.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: subjectColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: subjectColor.withAlpha((0.2 * 255).round()),
            valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}