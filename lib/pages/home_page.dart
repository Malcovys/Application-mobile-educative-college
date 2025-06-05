import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/progress_model.dart';
import '../../services/data_service.dart';
import '../../widgets/subject_card.dart';
import '../../widgets/progress_indicator.dart';
import 'subjects_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  UserProgress? userProgress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await DataService.initialize();
    setState(() {
      userProgress = DataService.userProgress;
      isLoading = false;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: theme.colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'EduLearn',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(theme),
                      const SizedBox(height: 24),
                      _buildProgressOverview(theme),
                      const SizedBox(height: 24),
                      _buildQuickStats(theme),
                      const SizedBox(height: 24),
                      _buildSubjectsSection(theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👋 Hello, Student!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to continue your learning today?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${userProgress?.streak ?? 0} days streak!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(ThemeData theme) {
    final overallProgress = userProgress?.overallProgress ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomProgressIndicator(
                  progress: overallProgress,
                  title: 'Overall Progress',
                  subtitle: 'All subjects combined',
                  color: theme.colorScheme.primary,
                  size: 100,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    ProgressRow(
                      label: 'Lessons Completed',
                      progress: _getLessonProgress(),
                      color: theme.colorScheme.secondary,
                      trailing: '${_getCompletedLessons()}/${_getTotalLessons()}',
                    ),
                    ProgressRow(
                      label: 'Exercises Passed',
                      progress: _getExerciseProgress(),
                      color: theme.colorScheme.tertiary,
                      trailing: '${_getCompletedExercises()}/${_getTotalExercises()}',
                    ),
                    ProgressRow(
                      label: 'Exams Taken',
                      progress: _getExamProgress(),
                      color: theme.colorScheme.primary,
                      trailing: '${_getCompletedExams()}/${_getTotalExams()}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
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

  Widget _buildSubjectsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subjects',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubjectsPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_forward,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              label: Text(
                'See all',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: DataService.subjects.length,
            itemBuilder: (context, index) {
              final subject = DataService.subjects[index];
              final subjectProgress = userProgress?.subjectProgress
                  .where((p) => p.subject == subject)
                  .firstOrNull;
              
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.only(
                        right: index < DataService.subjects.length - 1 ? 16 : 0,
                      ),
                      child: SubjectCard(
                        subject: subject,
                        progress: subjectProgress,
                        index: index,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectsPage(
                                initialSubject: subject,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double _getLessonProgress() {
    if (userProgress == null) return 0.0;
    final completed = _getCompletedLessons();
    final total = _getTotalLessons();
    return total > 0 ? completed / total : 0.0;
  }

  double _getExerciseProgress() {
    if (userProgress == null) return 0.0;
    final completed = _getCompletedExercises();
    final total = _getTotalExercises();
    return total > 0 ? completed / total : 0.0;
  }

  double _getExamProgress() {
    if (userProgress == null) return 0.0;
    final completed = _getCompletedExams();
    final total = _getTotalExams();
    return total > 0 ? completed / total : 0.0;
  }

  int _getCompletedLessons() {
    return userProgress?.subjectProgress
        .fold<int>(0, (sum, p) => sum + p.completedLessons) ?? 0;
  }

  int _getTotalLessons() {
    return userProgress?.subjectProgress
        .fold<int>(0, (sum, p) => sum + p.totalLessons) ?? 1;
  }

  int _getCompletedExercises() {
    return userProgress?.subjectProgress
        .fold<int>(0, (sum, p) => sum + p.completedExercises) ?? 0;
  }

  int _getTotalExercises() {
    return userProgress?.subjectProgress
        .fold<int>(0, (sum, p) => sum + p.totalExercises) ?? 1;
  }

  int _getCompletedExams() {
    return userProgress?.subjectProgress
        .fold<int>(0, (sum, p) => sum + p.completedExams) ?? 0;
  }

  int _getTotalExams() {
    return userProgress?.subjectProgress
        .fold<int>(0, (sum, p) => sum + p.totalExams) ?? 1;
  }

  double _getAverageScore() {
    if (userProgress == null || userProgress!.subjectProgress.isEmpty) return 0.0;
    return userProgress!.subjectProgress
        .map((p) => p.averageScore)
        .reduce((a, b) => a + b) / userProgress!.subjectProgress.length;
  }
}