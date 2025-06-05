import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/exercise_model.dart';
import '../../services/data_service.dart';

class ExercisePage extends StatefulWidget {
  final ExerciseModel exercise;

  const ExercisePage({super.key, required this.exercise});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> with TickerProviderStateMixin {
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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

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

  Color _getSubjectColor() {
    switch (widget.exercise.subject) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjectColor = _getSubjectColor();
    
    if (showResults) {
      return _buildResultsPage(theme, subjectColor);
    }
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme, subjectColor),
            _buildProgressIndicator(theme, subjectColor),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildQuestionCard(theme, subjectColor),
                ),
              ),
            ),
            _buildNavigationButtons(theme, subjectColor),
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
          colors: [
            subjectColor,
            subjectColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _showExitDialog();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  widget.exercise.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(remainingTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildProgressIndicator(ThemeData theme, Color subjectColor) {
    final progress = (currentQuestionIndex + 1) / widget.exercise.questions.length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} sur ${widget.exercise.questions.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: subjectColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: subjectColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ThemeData theme, Color subjectColor) {
    final question = widget.exercise.questions[currentQuestionIndex];
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: subjectColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              question.question,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = userAnswers[currentQuestionIndex] == index;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? subjectColor.withOpacity(0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? subjectColor
                            : theme.colorScheme.outline.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? subjectColor
                                : theme.colorScheme.outline.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: subjectColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme, Color subjectColor) {
    final isLastQuestion = currentQuestionIndex == widget.exercise.questions.length - 1;
    final hasAnswered = userAnswers[currentQuestionIndex] != null;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousQuestion,
                style: OutlinedButton.styleFrom(
                  foregroundColor: subjectColor,
                  side: BorderSide(color: subjectColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: subjectColor),
                    const SizedBox(width: 8),
                    Text(
                      'Previous',
                      style: TextStyle(
                        color: subjectColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (currentQuestionIndex > 0 && !isLastQuestion)
            const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: hasAnswered 
                  ? (isLastQuestion ? _finishExercise : _nextQuestion)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: subjectColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastQuestion ? 'Finish' : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isLastQuestion ? Icons.check : Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsPage(ThemeData theme, Color subjectColor) {
    final correctAnswers = userAnswers.asMap().entries
        .where((entry) => entry.value == widget.exercise.questions[entry.key].correctAnswerIndex)
        .length;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      subjectColor,
                      subjectColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      score >= 70 ? Icons.emoji_events : Icons.refresh,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      score >= 70 ? 'Congratulations!' : 'Good effort!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Exercise completed',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreStat(theme, 'Score', '$score%', subjectColor),
                        _buildScoreStat(theme, 'Correct', '$correctAnswers/${widget.exercise.questions.length}', Colors.green),
                        _buildScoreStat(theme, 'Time', _formatTime(widget.exercise.timeLimit * 60 - remainingTime), Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: subjectColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back to Exercises',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreStat(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit exercise?'),
        content: const Text('Your progress will be lost if you exit now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}