import 'package:flutter/material.dart';
import './subject_utils.dart';

class ActionButton extends StatelessWidget {
  final bool isCompleted;
  final String subject;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.isCompleted,
    required this.subject,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final subjectColor = getSubjectColor(subject);
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isCompleted ? null : onPressed,
        icon: Icon(
          isCompleted ? Icons.check_circle : Icons.check,
          color: Colors.white,
        ),
        label: Text(
          isCompleted ? 'Leçon términé' : 'Marquer comme terminé',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? Colors.green : subjectColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isCompleted ? 0 : 4,
        ),
      ),
    );
  }
}
