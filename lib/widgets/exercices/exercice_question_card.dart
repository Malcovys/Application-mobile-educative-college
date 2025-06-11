import 'package:flutter/material.dart';
import '../../models/exercise_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int? userAnswer;
  final Color subjectColor;
  final Function(int) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.userAnswer,
    required this.subjectColor,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: subjectColor.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              question.question,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = userAnswer == index;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onAnswerSelected(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? subjectColor.withAlpha((0.1 * 255).round())
                              : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? subjectColor
                                : theme.colorScheme.outline.withAlpha(
                                  (0.3 * 255).round(),
                                ),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? subjectColor
                                    : theme.colorScheme.outline.withAlpha(
                                      (0.2 * 255).round(),
                                    ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: subjectColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
