import 'package:flutter/material.dart';
import '../../models/exam_model.dart';
import '../../widgets/examens/score_stat.dart';

class ExamResultsPage extends StatelessWidget {
  final ExamModel exam;
  final Color subjectColor;
  final List<int?> userAnswers;
  final int score;

  const ExamResultsPage({
    super.key,
    required this.exam,
    required this.subjectColor,
    required this.userAnswers,
    required this.score,
  });

  bool get isPassed => score >= exam.passingScore;

  int get correctAnswers =>
      userAnswers
          .asMap()
          .entries
          .where(
            (entry) =>
                entry.value == exam.questions[entry.key].correctAnswerIndex,
          )
          .length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                          ? Colors.green.withAlpha(200)
                          : Colors.red.withAlpha(200),
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
                      isPassed ? 'Examen Réussi!' : 'Échec',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPassed
                          ? 'Félicitations! Vous avez réussi l\'examen.'
                          : 'Ne baissez pas les bras, vous pouvez réessayer.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withAlpha(230),
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
                    color: theme.colorScheme.outline.withAlpha(50),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScoreStat(
                          label: 'Score Final',
                          value: '$score%',
                          color: isPassed ? Colors.green : Colors.red,
                        ),
                        ScoreStat(
                          label: 'Requis',
                          value: '${exam.passingScore}%',
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScoreStat(
                          label: 'Correctes',
                          value: '$correctAnswers',
                          color: Colors.green,
                        ),
                        ScoreStat(
                          label: 'Incorrectes',
                          value: '${exam.questions.length - correctAnswers}',
                          color: Colors.red,
                        ),
                        ScoreStat(
                          label: 'Total',
                          value: '${exam.questions.length}',
                          color: Colors.blue,
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
                    color: Colors.blue.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withAlpha(75)),
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
                          'Conseil : Passez en revue les leçons et refaites les exercices avant de reprendre l\'examen.',
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
                          Navigator.pop(context);
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subjectColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Retour aux examens',
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
}
