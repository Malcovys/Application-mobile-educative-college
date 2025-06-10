import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import './subject_utils.dart';

class LessonSliverAppBar extends StatelessWidget {
  final LessonModel lesson;
  final bool isCompleted;

  const LessonSliverAppBar({
    super.key,
    required this.lesson,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final subjectColor = getSubjectColor(lesson.subject);
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: subjectColor,
      leading: BackButton(color: Colors.white),
      actions: [
        if (isCompleted)
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.check_circle, color: Colors.white),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          lesson.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                subjectColor,
                subjectColor.withAlpha((0.8 * 255).toInt()),
              ],
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                getSubjectIcon(lesson.subject),
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
