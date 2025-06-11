import 'package:flutter/material.dart';
import '../../models/exam_model.dart';

class ExamProgressIndicator extends StatelessWidget {
  final ExamModel exam;
  final int currentQuestionIndex;
  final List<int?> userAnswers;
  final Color subjectColor;

  const ExamProgressIndicator({
    super.key,
    required this.exam,
    required this.currentQuestionIndex,
    required this.userAnswers,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (currentQuestionIndex + 1) / exam.questions.length;
    final answeredQuestions = userAnswers.where((answer) => answer != null).length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} sur ${exam.questions.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '$answeredQuestions repondu',
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
            backgroundColor: subjectColor.withAlpha(50),
            valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}