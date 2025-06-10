import 'package:flutter/material.dart';
import '../../utils/subject_utils.dart';

class SubjectSelector extends StatelessWidget {
  final List<String> subjects;
  final String selectedSubject;
  final ValueChanged<String> onSubjectSelected;

  const SubjectSelector({
    super.key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final isSelected = subject == selectedSubject;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSubjectSelected(subject);
                }
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: SubjectUtils.getSubjectColor(
                subject,
              ).withAlpha((0.2 * 255).round()),
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? SubjectUtils.getSubjectColor(subject)
                        : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color:
                    isSelected
                        ? SubjectUtils.getSubjectColor(subject)
                        : theme.colorScheme.outline.withAlpha(
                          (0.5 * 255).round(),
                        ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
