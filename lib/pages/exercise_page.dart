import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/exercise_model.dart';
import '../../services/data_service.dart';
import '../widgets/exercices/exercise_header.dart';
import '../widgets/exercices/exercice_progress_indicator.dart';
import '../widgets/exercices/exercice_question_card.dart';
import '../widgets/exercices/exercice_navigation_buttons.dart';
import '../widgets/exercices/exercise_results_page.dart';
import '../../utils/subject_utils.dart';

class ExercisePage extends StatefulWidget {
  final ExerciseModel exercise;

  const ExercisePage({super.key, required this.exercise});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int currentQuestionIndex = 0;
  List<int?> userAnswers = [];
  Timer? timer;
  int remainingTime = 0;
  bool isCompleted = false;
  bool showResults = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    userAnswers = List.filled(widget.exercise.questions.length, null);
    remainingTime = widget.exercise.timeLimit * 60; // Convert to seconds

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _finishExercise();
      }
    });
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      userAnswers[currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.exercise.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _finishExercise() {
    timer?.cancel();

    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < widget.exercise.questions.length; i++) {
      if (userAnswers[i] == widget.exercise.questions[i].correctAnswerIndex) {
        correctAnswers++;
      }
    }

    score = ((correctAnswers / widget.exercise.questions.length) * 100).round();

    // Save progress
    DataService.updateExerciseProgress(widget.exercise.id, true, score);

    setState(() {
      isCompleted = true;
      showResults = true;
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Quitter l’exercice?'),
            content: const Text('Votre progression sera perdue si vous sortez maintenant.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Quitter'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectColor = SubjectUtils.getSubjectColor(widget.exercise.subject);
    if (showResults) {
      return ResultsPage(
        score: score,
        userAnswers: userAnswers,
        exercise: widget.exercise,
        remainingTime: remainingTime,
        subjectColor: subjectColor,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ExerciseHeader(
              exercise: widget.exercise,
              remainingTime: remainingTime,
              subjectColor: subjectColor,
              onBackPressed: _showExitDialog,
            ),
            ProgressIndicatorWidget(
              currentQuestionIndex: currentQuestionIndex,
              exercise: widget.exercise,
              subjectColor: subjectColor,
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: QuestionCard(
                    question: widget.exercise.questions[currentQuestionIndex],
                    userAnswer: userAnswers[currentQuestionIndex],
                    subjectColor: subjectColor,
                    onAnswerSelected: _selectAnswer,
                  ),
                ),
              ),
            ),
            NavigationButtons(
              currentQuestionIndex: currentQuestionIndex,
              exercise: widget.exercise,
              subjectColor: subjectColor,
              hasAnswered: userAnswers[currentQuestionIndex] != null,
              onPreviousPressed: _previousQuestion,
              onNextPressed: _nextQuestion,
              onFinishPressed: _finishExercise,
            ),
          ],
        ),
      ),
    );
  }
}
