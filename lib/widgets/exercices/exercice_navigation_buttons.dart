import 'package:flutter/material.dart';
import '../../models/exercise_model.dart';

class NavigationButtons extends StatelessWidget {
  final int currentQuestionIndex;
  final ExerciseModel exercise;
  final Color subjectColor;
  final bool hasAnswered;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onFinishPressed;

  const NavigationButtons({
    super.key,
    required this.currentQuestionIndex,
    required this.exercise,
    required this.subjectColor,
    required this.hasAnswered,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onFinishPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = currentQuestionIndex == exercise.questions.length - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onPreviousPressed,
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
              onPressed: hasAnswered
                  ? (isLastQuestion ? onFinishPressed : onNextPressed)
                  : null,
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
                    isLastQuestion ? 'Finir' : 'Suivant',
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
    );
  }
}