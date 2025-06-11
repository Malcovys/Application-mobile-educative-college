import 'package:flutter/material.dart';
import '../../models/exam_model.dart';

class ExamInfoCard extends StatelessWidget {
  final ExamModel exam;
  final Color subjectColor;

  const ExamInfoCard({
    super.key,
    required this.exam,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(50),
        ),
      ),
      child: Column(
        children: [
          _buildExamInfoRow(
            theme,
            'Questions',
            '${exam.questions.length}',
            Icons.help_outline,
          ),
          const SizedBox(height: 16),
          _buildExamInfoRow(
            theme,
            'Duré',
            '${exam.timeLimit} minutes',
            Icons.timer,
          ),
          const SizedBox(height: 16),
          _buildExamInfoRow(
            theme,
            'Score requis',
            '${exam.passingScore}%',
            Icons.grade,
          ),
          const SizedBox(height: 16),
          _buildExamInfoRow(
            theme,
            'Difficulté',
            exam.difficulty,
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildExamInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: subjectColor, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(180),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}