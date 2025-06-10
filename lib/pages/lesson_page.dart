import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../services/data_service.dart';
import '../widgets/lessons/sliver_app_bar.dart';
import '../widgets/lessons/lesson_info.dart';
import '../widgets/lessons/objectives.dart';
import '../widgets/lessons/lesson_content.dart';
import '../widgets/lessons/action_button.dart';

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                LessonSliverAppBar(
                  lesson: widget.lesson,
                  isCompleted: isCompleted,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LessonInfo(lesson: widget.lesson),
                        const SizedBox(height: 24),
                        LessonObjectives(lesson: widget.lesson),
                        const SizedBox(height: 24),
                        LessonContent(content: widget.lesson.content),
                        const SizedBox(height: 32),
                        ActionButton(
                          isCompleted: isCompleted,
                          subject: widget.lesson.subject,
                          onPressed: _markAsCompleted,
                        ),
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
}
