import 'package:flutter/material.dart';
import '../../models/progress_model.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SubjectCard extends StatelessWidget {
  final String subject;
  final SubjectProgress? progress;
  final VoidCallback onTap;
  final int index;

  const SubjectCard({
    super.key,
    required this.subject,
    this.progress,
    required this.onTap,
    required this.index,
  });

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Mathematique':
        return const Color(0xFF6F61EF);
      case 'Science':
        return const Color(0xFF39D2C0);
      case 'Literature':
        return const Color(0xFFEE8B60);
      case 'Histoire':
        return const Color(0xFFFF6B95);
      case 'Geographie':
        return const Color(0xFF4ECDC4);
      default:
        return const Color(0xFF6F61EF);
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Mathematique':
        return Icons.calculate;
      case 'Science':
        return Icons.science;
      case 'Literature':
        return Icons.menu_book;
      case 'Histoire':
        return Icons.account_balance;
      case 'Geographie':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjectColor = _getSubjectColor(subject);
    final progressValue = progress?.overallProgress ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [subjectColor, subjectColor.withAlpha((0.8 * 255).round())],
        ),
        boxShadow: [
          BoxShadow(
            color: subjectColor.withAlpha((0.3 * 255).round()),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getSubjectIcon(subject),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(progressValue * 100).toInt()}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subject,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (progress != null) ...[
                  Text(
                    '${progress!.completedLessons}/${progress!.totalLessons} leçons',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha((0.9 * 255).round()),
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 6,
                    percent: progressValue,
                    progressColor: Colors.white,
                    backgroundColor: Colors.white.withAlpha(
                      (0.3 * 255).round(),
                    ),
                    barRadius: const Radius.circular(3),
                    animation: true,
                    animationDuration: 800,
                  ),
                ] else ...[
                  Text(
                    'Commencer à apprendre',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha((0.9 * 255).round()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 6,
                    percent: 0.0,
                    progressColor: Colors.white,
                    backgroundColor: Colors.white.withAlpha(
                      (0.3 * 255).round(),
                    ),
                    barRadius: const Radius.circular(3),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.white.withAlpha((0.8 * 255).round()),
                      size: 16,
                    ),
                    Text(
                      progress != null
                          ? 'Dernière activité: ${_formatDate(progress!.lastActivity)}'
                          : 'Nouveau',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha((0.8 * 255).round()),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Actuelle';
    } else if (difference == 1) {
      return 'Hier';
    } else {
      return '$difference jours';
    }
  }
}
