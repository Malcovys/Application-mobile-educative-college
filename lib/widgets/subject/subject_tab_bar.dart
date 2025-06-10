import 'package:flutter/material.dart';

class SubjectTabBar extends StatelessWidget {
  final TabController tabController;
  final Color activeColor;

  const SubjectTabBar({
    super.key,
    required this.tabController,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: activeColor,
        unselectedLabelColor: theme.colorScheme.onSurface.withAlpha(
          (0.6 * 255).round(),
        ),
        indicatorColor: activeColor,
        indicatorWeight: 3,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        tabs: const [
          Tab(icon: Icon(Icons.book), text: 'Lessons'),
          Tab(icon: Icon(Icons.quiz), text: 'Exercises'),
          Tab(icon: Icon(Icons.assignment), text: 'Exams'),
        ],
      ),
    );
  }
}
