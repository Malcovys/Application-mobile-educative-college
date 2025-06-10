import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import './subject_utils.dart';

class LessonObjectives extends StatelessWidget {
  final LessonModel lesson;

  const LessonObjectives({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjectColor = getSubjectColor(lesson.subject);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: subjectColor.withAlpha((0.05 * 255).toInt()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: subjectColor.withAlpha((0.2 * 255).toInt())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: subjectColor),
              const SizedBox(width: 8),
              Text(
                'Lesson Objectives',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...lesson.objectives.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: subjectColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(e.value, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
