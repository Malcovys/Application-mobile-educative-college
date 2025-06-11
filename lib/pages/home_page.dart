import 'package:flutter/material.dart';

// import '../widgets/quick_stats.dart';
import '../widgets/subject/subjects_section.dart';
import '../widgets/header_sliver_appbar.dart';
import '../widgets/welcome_section.dart';
import '../widgets/progress/progress_overview.dart';

import '../services/auth_service.dart';
import '../../models/progress_model.dart';
import '../../services/data_service.dart';



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
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadData();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              const HeaderSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WelcomeSection(theme: theme, userProgress: userProgress!, userName: AuthService.utilisateur?.nom ?? "Utilisateur"),
                      const SizedBox(height: 24),
                      ProgressOverview(
                        theme: theme,
                        userProgress: userProgress!,
                        lessonProgress: userProgress!.lessonProgress,
                        exerciseProgress: userProgress!.exerciseProgress,
                        examProgress: userProgress!.examProgress,
                        completedLessons: userProgress!.completedLessons,
                        totalLessons: userProgress!.totalLessons,
                        completedExercises: userProgress!.completedExercises,
                        totalExercises: userProgress!.totalExercises,
                        completedExams: userProgress!.completedExams,
                        totalExams: userProgress!.totalExams,
                      ),
                      const SizedBox(height: 24),
                      // QuickStats(userProgress: userProgress!),
                      const SizedBox(height: 24),
                      SubjectsSection(
                        theme: theme,
                        userProgress: userProgress!,
                      ),
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
}
