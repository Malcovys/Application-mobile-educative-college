import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../services/data_service.dart';

class LessonPage extends StatefulWidget {
  final LessonModel lesson;

  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.lesson.isCompleted;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getSubjectColor() {
    switch (widget.lesson.subject) {
      case 'Mathematics':
        return const Color(0xFF6F61EF);
      case 'Science':
        return const Color(0xFF39D2C0);
      case 'Literature':
        return const Color(0xFFEE8B60);
      case 'History':
        return const Color(0xFFFF6B95);
      case 'Geography':
        return const Color(0xFF4ECDC4);
      default:
        return const Color(0xFF6F61EF);
    }
  }

  Future<void> _markAsCompleted() async {
    await DataService.updateLessonProgress(widget.lesson.id, true);
    setState(() {
      isCompleted = true;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lesson marked as completed! 🎉'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjectColor = _getSubjectColor();
    
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(theme, subjectColor),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLessonInfo(theme),
                        const SizedBox(height: 24),
                        _buildObjectives(theme, subjectColor),
                        const SizedBox(height: 24),
                        _buildContent(theme),
                        const SizedBox(height: 32),
                        _buildActionButton(theme, subjectColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, Color subjectColor) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: subjectColor,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        if (isCompleted)
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.lesson.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16, right: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                subjectColor,
                subjectColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getSubjectIcon(),
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  theme,
                  Icons.access_time,
                  'Duration',
                  '${widget.lesson.duration} min',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  theme,
                  Icons.school,
                  'Subject',
                  widget.lesson.subject,
                  _getSubjectColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            theme,
            Icons.trending_up,
            'Difficulty',
            widget.lesson.difficulty,
            _getDifficultyColor(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(ThemeData theme, IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildObjectives(ThemeData theme, Color subjectColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: subjectColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: subjectColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag,
                color: subjectColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Lesson Objectives',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: subjectColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.lesson.objectives.asMap().entries.map((entry) {
            final index = entry.key;
            final objective = entry.value;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: subjectColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      objective,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lesson Content',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Text(
              widget.lesson.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme, Color subjectColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isCompleted ? null : _markAsCompleted,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? Colors.green : subjectColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isCompleted ? 0 : 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.check,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isCompleted ? 'Lesson Completed' : 'Mark as Completed',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon() {
    switch (widget.lesson.subject) {
      case 'Mathematics':
        return Icons.calculate;
      case 'Science':
        return Icons.science;
      case 'Literature':
        return Icons.menu_book;
      case 'History':
        return Icons.account_balance;
      case 'Geography':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  Color _getDifficultyColor() {
    switch (widget.lesson.difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}