import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import './subject_utils.dart';

class LessonInfo extends StatelessWidget {
  final LessonModel lesson;

  const LessonInfo({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = getSubjectColor(lesson.subject);

    Widget buildInfo(
      IconData icon,
      String label,
      String value,
      Color iconColor,
    ) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.2 * 255).toInt()),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildInfo(
                  Icons.access_time,
                  'Durée',
                  '${lesson.duration} min',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildInfo(
                  Icons.school,
                  'Matière',
                  lesson.subject,
                  color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildInfo(
            Icons.trending_up,
            'Difficulée',
            lesson.difficulty,
            getDifficultyColor(lesson.difficulty),
          ),
        ],
      ),
    );
  }
}
