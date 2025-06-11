import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../services/data_service.dart';
import '../../models/lesson_model.dart';
import '../../models/exercise_model.dart';
import '../../models/exam_model.dart';
import 'lesson_page.dart';
import 'exercise_page.dart';
import 'exam_page.dart';

class SubjectsPage extends StatefulWidget {
  final String? initialSubject;

  const SubjectsPage({super.key, this.initialSubject});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedSubject = '';
  List<LessonModel> lessons = [];
  List<ExerciseModel> exercises = [];
  List<ExamModel> exams = [];

  @override
  void initState() {
    super.initState();
    selectedSubject = widget.initialSubject ?? DataService.subjects.first;
    _tabController = TabController(length: 3, vsync: this);
    _loadSubjectData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadSubjectData() {
    setState(() {
      lessons = DataService.getLessonsBySubject(selectedSubject);
      exercises = DataService.getExercisesBySubject(selectedSubject);
      exams = DataService.getExamsBySubject(selectedSubject);
    });
  }

  Color _getSubjectColor() {
    switch (selectedSubject) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjectColor = _getSubjectColor();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme, subjectColor),
            _buildSubjectSelector(theme),
            _buildTabBar(theme, subjectColor),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLessonsTab(),
                  _buildExercisesTab(),
                  _buildExamsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color subjectColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [subjectColor, subjectColor.withAlpha((0.8 * 255).round())],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedSubject,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getSubjectIcon(selectedSubject),
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip('${lessons.length} Leçons', Icons.book),
              const SizedBox(width: 12),
              _buildStatChip('${exercises.length} Exercises', Icons.quiz),
              const SizedBox(width: 12),
              _buildStatChip('${exams.length} Examens', Icons.assignment),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelector(ThemeData theme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: DataService.subjects.length,
        itemBuilder: (context, index) {
          final subject = DataService.subjects[index];
          final isSelected = subject == selectedSubject;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedSubject = subject;
                  });
                  _loadSubjectData();
                }
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: _getSubjectColor().withAlpha((0.2 * 255).round()),
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? _getSubjectColor()
                        : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color:
                    isSelected
                        ? _getSubjectColor()
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

  Widget _buildTabBar(ThemeData theme, Color subjectColor) {
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
        controller: _tabController,
        labelColor: subjectColor,
        unselectedLabelColor: theme.colorScheme.onSurface.withAlpha(
          (0.6 * 255).round(),
        ),
        indicatorColor: subjectColor,
        indicatorWeight: 3,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        tabs: const [
          Tab(icon: Icon(Icons.book), text: 'Leçons'),
          Tab(icon: Icon(Icons.quiz), text: 'Exercises'),
          Tab(icon: Icon(Icons.assignment), text: 'Examens'),
        ],
      ),
    );
  }

  Widget _buildLessonsTab() {
    if (lessons.isEmpty) {
      return _buildEmptyState('Pas de cours disponibles', Icons.book);
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: _buildLessonCard(lesson, index)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExercisesTab() {
    if (exercises.isEmpty) {
      return _buildEmptyState('Pas de exercices disponibles', Icons.quiz);
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildExerciseCard(exercise, index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExamsTab() {
    if (exams.isEmpty) {
      return _buildEmptyState('Pas de examens disponibles', Icons.assignment);
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: _buildExamCard(exam, index)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonCard(LessonModel lesson, int index) {
    final theme = Theme.of(context);
    final subjectColor = _getSubjectColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonPage(lesson: lesson),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: subjectColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: subjectColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: theme.colorScheme.onSurface.withAlpha(
                              (0.6 * 255).round(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.duration} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                (0.6 * 255).round(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(
                                lesson.difficulty,
                              ).withAlpha((0.1 * 255).round()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lesson.difficulty,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getDifficultyColor(lesson.difficulty),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (lesson.isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)
                else
                  Icon(
                    Icons.play_circle_outline,
                    color: subjectColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseModel exercise, int index) {
    final theme = Theme.of(context);
    final subjectColor = _getSubjectColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExercisePage(exercise: exercise),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: subjectColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.quiz, color: subjectColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 16,
                            color: theme.colorScheme.onSurface.withAlpha(
                              (0.6 * 255).round(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${exercise.questions.length} questions',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                (0.6 * 255).round(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: theme.colorScheme.onSurface.withAlpha(
                              (0.6 * 255).round(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${exercise.timeLimit} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                (0.6 * 255).round(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (exercise.isCompleted && exercise.score != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.grade,
                              size: 16,
                              color: _getScoreColor(exercise.score!),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Score: ${exercise.score}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getScoreColor(exercise.score!),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (exercise.isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)
                else
                  Icon(
                    Icons.play_circle_outline,
                    color: subjectColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard(ExamModel exam, int index) {
    final theme = Theme.of(context);
    final subjectColor = _getSubjectColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExamPage(exam: exam)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: subjectColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.assignment, color: subjectColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(
                                exam.difficulty,
                              ).withAlpha((0.1 * 255).round()),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              exam.difficulty,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getDifficultyColor(exam.difficulty),
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.timer,
                            size: 14,
                            color: theme.colorScheme.onSurface.withAlpha(
                              (0.6 * 255).round(),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${exam.timeLimit} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                (0.6 * 255).round(),
                              ),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.help_outline,
                            size: 14,
                            color: theme.colorScheme.onSurface.withAlpha(
                              (0.6 * 255).round(),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${exam.questions.length} questions',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                (0.6 * 255).round(),
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (exam.isCompleted && exam.score != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              exam.isPassed ? Icons.check_circle : Icons.cancel,
                              size: 16,
                              color: exam.isPassed ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Score: ${exam.score}% (Requis: ${exam.passingScore}%)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    exam.isPassed ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (exam.isCompleted)
                  Icon(
                    exam.isPassed ? Icons.check_circle : Icons.cancel,
                    color: exam.isPassed ? Colors.green : Colors.red,
                    size: 24,
                  )
                else
                  Icon(
                    Icons.play_circle_outline,
                    color: subjectColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
            ),
          ),
        ],
      ),
    );
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return Colors.green;
      case 'moyen':
        return Colors.orange;
      case 'difficile':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
