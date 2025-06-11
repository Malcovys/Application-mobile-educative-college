import 'package:flutter/material.dart';
import '../../models/exam_model.dart';
import '../../widgets/examens/exam_header.dart';
import '../../widgets/examens/progress_indicator.dart';
import '../../widgets/examens/question_card.dart';
import '../../widgets/examens/navigation_buttons.dart';

class ExamQuestionPage extends StatelessWidget {
  final ExamModel exam;
  final int currentQuestionIndex;
  final List<int?> userAnswers;
  final int remainingTime;
  final Color subjectColor;
  final Function(int) onAnswerSelected;
  final VoidCallback onNextQuestion;
  final VoidCallback onPreviousQuestion;
  final VoidCallback onFinishExam;

  const ExamQuestionPage({
    super.key,
    required this.exam,
    required this.currentQuestionIndex,
    required this.userAnswers,
    required this.remainingTime,
    required this.subjectColor,
    required this.onAnswerSelected,
    required this.onNextQuestion,
    required this.onPreviousQuestion,
    required this.onFinishExam,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ExamHeader(
              exam: exam,
              remainingTime: remainingTime,
              subjectColor: subjectColor,
            ),
            ExamProgressIndicator(
              exam: exam,
              currentQuestionIndex: currentQuestionIndex,
              userAnswers: userAnswers,
              subjectColor: subjectColor,
            ),
            Expanded(
              child: QuestionCard(
                question: exam.questions[currentQuestionIndex],
                selectedAnswer: userAnswers[currentQuestionIndex],
                subjectColor: subjectColor,
                onAnswerSelected: onAnswerSelected,
              ),
            ),
            NavigationButtons(
              exam: exam,
              currentQuestionIndex: currentQuestionIndex,
              userAnswers: userAnswers,
              subjectColor: subjectColor,
              onNextQuestion: onNextQuestion,
              onPreviousQuestion: onPreviousQuestion,
              onFinishExam: onFinishExam,
            ),
          ],
        ),
      ),
    );
  }
}
