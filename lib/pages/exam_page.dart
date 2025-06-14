import 'package:flutter/material.dart';
import 'dart:async';

import '../models/examen_model.dart';
import '../models/exercice_model.dart';
import '../models/exercice_resultat_model.dart';

import '../services/data_service.dart';

class ExamPage extends StatefulWidget {
  final ExamenModel exam;

  const ExamPage({super.key, required this.exam});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int currentQuestionIndex = 0;
  List<ReponseModel> userAnswers = [];

  Timer? timer;
  int remainingTime = 0;

  bool isCompleted = false;
  bool showResults = false;
  bool examStarted = false;

  int score = 0;

  late String examenSubject;

  @override
  void initState() {
    super.initState();

    examenSubject = DataService.getMatiereOfExamen(widget.exam);

    userAnswers = List.filled(
      widget.exam.questions.length,
      ReponseModel(selectionne: "", correcte: false, questionIdx: -1),
    );

    remainingTime = widget.exam.duree * 60; // Convert to seconds

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
  }

  @override
  void dispose() {
    timer?.cancel();

    _animationController.dispose();

    super.dispose();
  }

  void _startExam() {
    setState(() {
      examStarted = true;
    });

    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _finishExam();
      }
    });
  }

  void _selectAnswer(String selectedLabel, bool isCorrect, int answerIndex) {
    setState(() {
      userAnswers[currentQuestionIndex] = ReponseModel(
        selectionne: selectedLabel,
        correcte: isCorrect,
        questionIdx: currentQuestionIndex,
      );
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.exam.questions.length - 1) {
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

  void _finishExam() {
    timer?.cancel();

    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < widget.exam.questions.length; i++) {
      // if (userAnswers[i] == widget.exam.questions[i].correctAnswerIndex) {
      //   correctAnswers++;
      // }
      final QuestionModel question = widget.exam.questions[i];
      final OptionModel correctOption = question.options.firstWhere(
        (option) => option.correcte,
      );
      if (userAnswers[i].selectionne == correctOption.label) {
        correctAnswers++;
      }
    }

    score = ((correctAnswers / widget.exam.questions.length) * 100).round();

    // Save progress
    // DataService.updateExamProgress(
    //   widget.exam.id,
    //   true,
    //   score,
    //   userAnswers.map((e) => e ?? -1).toList(),
    // );

    setState(() {
      isCompleted = true;
      showResults = true;
    });
  }

  Color _getSubjectColor() {
    switch (examenSubject) {
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

    if (!examStarted) {
      return _buildStartPage(theme, subjectColor);
    }

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

  Widget _buildStartPage(ThemeData theme, Color subjectColor) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Examen de $examenSubject',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      subjectColor,
                      subjectColor.withAlpha((0.8 * 255).toInt()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.assignment, color: Colors.white, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      widget.exam.nom,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vous êtes prêt?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withAlpha((0.9 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(
                      (0.2 * 255).round(),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildExamInfo(
                      theme,
                      'Questions',
                      '${widget.exam.questions.length}',
                      Icons.help_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildExamInfo(
                      theme,
                      'Duré',
                      '${widget.exam.duree} minutes',
                      Icons.timer,
                    ),
                    const SizedBox(height: 16),
                    _buildExamInfo(theme, 'Score requis', '50%', Icons.grade),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withAlpha((0.3 * 255).round()),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Une fois débuté, tu ne peux pas pausé.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startExam,
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
                      const Icon(Icons.play_arrow, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Commencer',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildExamInfo(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: _getSubjectColor(), size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
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
                onPressed: () {
                  _showExitDialog();
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  widget.exam.nom,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      remainingTime < 300
                          ? Colors.red.withAlpha((0.3 * 255).round())
                          : Colors.white.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      color:
                          remainingTime < 300
                              ? Colors.red.shade100
                              : Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(remainingTime),
                      style: TextStyle(
                        color:
                            remainingTime < 300
                                ? Colors.red.shade100
                                : Colors.white,
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
    final progress = (currentQuestionIndex + 1) / widget.exam.questions.length;

    final answeredQuestions =
        userAnswers
            .where(
              (answer) => answer.selectionne != "" || answer.questionIdx != -1,
            )
            .length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} sur ${widget.exam.questions.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '$answeredQuestions repondu',
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
            backgroundColor: subjectColor.withAlpha((0.2 * 255).round()),
            valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ThemeData theme, Color subjectColor) {
    final question = widget.exam.questions[currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: subjectColor.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              question.ennonce,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...question.options.asMap().entries.map((entry) {
            final int optionIndex = entry.key;
            final OptionModel option = entry.value;
            final isSelected =
                userAnswers[currentQuestionIndex].selectionne == option.label;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap:
                      () => _selectAnswer(
                        option.label,
                        option.correcte,
                        optionIndex,
                      ),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? subjectColor.withAlpha((0.1 * 255).round())
                              : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? subjectColor
                                : theme.colorScheme.outline.withAlpha(
                                  (0.3 * 255).round(),
                                ),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? subjectColor
                                    : theme.colorScheme.outline.withAlpha(
                                      (0.2 * 255).round(),
                                    ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(
                                65 + optionIndex,
                              ), // A, B, C, D
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    isSelected
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
                            option.valeur,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
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
    final isLastQuestion =
        currentQuestionIndex == widget.exam.questions.length - 1;
    final answeredQuestions =
        userAnswers
            .where(
              (answer) => answer.selectionne != "" || answer.questionIdx != -1,
            )
            .length;
    final allAnswered = answeredQuestions == widget.exam.questions.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (!allAnswered && isLastQuestion)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.exam.questions.length - answeredQuestions} question(s) remaining unanswered',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
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
                          'Precedent',
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
                  onPressed: isLastQuestion ? _finishExam : _nextQuestion,
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
                        isLastQuestion ? 'Finir' : 'Suivant',
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
        ],
      ),
    );
  }

  Widget _buildResultsPage(ThemeData theme, Color subjectColor) {
    // final correctAnswers =
    //     userAnswers
    //         .asMap()
    //         .entries
    //         .where(
    //           (entry) =>
    //               entry.value ==
    //               widget.exam.questions[entry.key].correctAnswerIndex,
    //         )
    //         .length;

    final correctAnswers =
        userAnswers.where((response) {
          final question = widget.exam.questions[response.questionIdx];
          final correctOption = question.options.firstWhere(
            (option) => option.correcte,
          );
          return response.selectionne == correctOption.label;
        }).length;

    final isPassed = score >= 50;

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
                      isPassed ? Colors.green : Colors.red,
                      isPassed
                          ? Colors.green.withAlpha((0.8 * 255).round())
                          : Colors.red.withAlpha((0.8 * 255).round()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      isPassed ? Icons.emoji_events : Icons.refresh,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isPassed ? 'Examen Passé!' : 'Echec',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPassed
                          ? 'Félicitations! Vous avez passez lexamen.'
                          : 'Do not give up, you can try again.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withAlpha((0.9 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(
                      (0.2 * 255).round(),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreStat(
                          theme,
                          'Score Final ',
                          '$score%',
                          isPassed ? Colors.green : Colors.red,
                        ),
                        _buildScoreStat(theme, 'Requis', '${50}%', Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreStat(
                          theme,
                          'Correct',
                          '$correctAnswers',
                          Colors.green,
                        ),
                        _buildScoreStat(
                          theme,
                          'Incorrect',
                          '${widget.exam.questions.length - correctAnswers}',
                          Colors.red,
                        ),
                        _buildScoreStat(
                          theme,
                          'Total',
                          '${widget.exam.questions.length}',
                          Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (!isPassed)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withAlpha((0.3 * 255).round()),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Conseil : Passez en revue les leçons et refaites les exercices avant de reprendre l’examen.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  if (!isPassed)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Reset and restart exam
                          setState(() {
                            // userAnswers = List.filled(
                            //   widget.exam.questions.length,
                            //   null,
                            // );
                            userAnswers = [];
                            currentQuestionIndex = 0;
                            remainingTime = widget.exam.duree * 60;
                            isCompleted = false;
                            showResults = false;
                            examStarted = false;
                            score = 0;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: subjectColor,
                          side: BorderSide(color: subjectColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Essayer encore',
                          style: TextStyle(
                            color: subjectColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (!isPassed) const SizedBox(width: 16),
                  Expanded(
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
                        'Revenir à lexamen',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreStat(
    ThemeData theme,
    String label,
    String value,
    Color color,
  ) {
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
            color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
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
      builder:
          (context) => AlertDialog(
            title: const Text('Quitter lexam?'),
            content: const Text(
              'Attention ! Si vous quittez maintenant, vos progrès seront perdus et l’examen sera considéré comme un échec.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continuer'),
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
}
