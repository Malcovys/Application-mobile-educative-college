import 'package:flutter/material.dart';
import '../../../../models/progress_model.dart';
import 'stats_card.dart';

class QuickStats extends StatelessWidget {
  final UserProgress? userProgress;

  const QuickStats({super.key, required this.userProgress});

  double _getAverageScore() {
    if (userProgress == null || userProgress!.subjectProgress.isEmpty) {
      return 0.0;
    }
    return userProgress!.subjectProgress
            .map((p) => p.averageScore)
            .reduce((a, b) => a + b) /
        userProgress!.subjectProgress.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // récupère le thème directement ici

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatsCard(
          title: 'Study Time',
          value: '${userProgress?.totalStudyTime ?? 0}h',
          icon: Icons.access_time,
          color: theme.colorScheme.primary,
          subtitle: 'Total accumulated',
        ),
        StatsCard(
          title: 'Current Streak',
          value: '${userProgress?.streak ?? 0}',
          icon: Icons.local_fire_department,
          color: Colors.orange,
          subtitle: 'Consecutive days',
        ),
        StatsCard(
          title: 'Average Score',
          value: '${_getAverageScore().toInt()}%',
          icon: Icons.trending_up,
          color: theme.colorScheme.secondary,
          subtitle: 'All exercises',
        ),
        StatsCard(
          title: 'Achievements',
          value: '${userProgress?.achievements.length ?? 0}',
          icon: Icons.emoji_events,
          color: theme.colorScheme.tertiary,
          subtitle: 'Unlocked rewards',
        ),
      ],
    );
  }
}
