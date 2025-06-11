import 'package:flutter/material.dart';
import '../../models/exam_model.dart';

class NavigationButtons extends StatelessWidget {
  final ExamModel exam;
  final int currentQuestionIndex;
  final List<int?> userAnswers;
  final Color subjectColor;
  final VoidCallback onNextQuestion;
  final VoidCallback onPreviousQuestion;
  final VoidCallback onFinishExam;

  const NavigationButtons({
    super.key,
    required this.exam,
    required this.currentQuestionIndex,
    required this.userAnswers,
    required this.subjectColor,
    required this.onNextQuestion,
    required this.onPreviousQuestion,
    required this.onFinishExam,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastQuestion = currentQuestionIndex == exam.questions.length - 1;
    final answeredQuestions = userAnswers.where((answer) => answer != null).length;
    final allAnswered = answeredQuestions == exam.questions.length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (!allAnswered && isLastQuestion)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${exam.questions.length - answeredQuestions} question(s) remaining unanswered',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              if (currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPreviousQuestion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: subjectColor,
                      side: BorderSide(color: subjectColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: subjectColor),
                        const SizedBox(width: 8),
                        Text(
                          'Precedent',
                          style: TextStyle(
                            color: subjectColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (currentQuestionIndex > 0 && !isLastQuestion)
                const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLastQuestion ? onFinishExam : onNextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: subjectColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastQuestion ? 'Finire' : 'Suivant',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isLastQuestion ? Icons.check : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}