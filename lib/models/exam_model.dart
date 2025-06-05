import 'exercise_model.dart';

class ExamModel {
  final String id;
  final String title;
  final String subject;
  final List<QuestionModel> questions;
  final int timeLimit; // in minutes
  final int passingScore; // percentage
  final String difficulty;
  final bool isCompleted;
  final int? score;
  final DateTime? completedAt;
  final List<int>? userAnswers;

  ExamModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    required this.timeLimit,
    required this.passingScore,
    required this.difficulty,
    this.isCompleted = false,
    this.score,
    this.completedAt,
    this.userAnswers,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      questions: (json['questions'] as List)
          .map((q) => QuestionModel.fromJson(q))
          .toList(),
      timeLimit: json['timeLimit'],
      passingScore: json['passingScore'],
      difficulty: json['difficulty'],
      isCompleted: json['isCompleted'] ?? false,
      score: json['score'],
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      userAnswers: json['userAnswers'] != null 
          ? List<int>.from(json['userAnswers']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'questions': questions.map((q) => q.toJson()).toList(),
      'timeLimit': timeLimit,
      'passingScore': passingScore,
      'difficulty': difficulty,
      'isCompleted': isCompleted,
      'score': score,
      'completedAt': completedAt?.toIso8601String(),
      'userAnswers': userAnswers,
    };
  }

  ExamModel copyWith({
    String? id,
    String? title,
    String? subject,
    List<QuestionModel>? questions,
    int? timeLimit,
    int? passingScore,
    String? difficulty,
    bool? isCompleted,
    int? score,
    DateTime? completedAt,
    List<int>? userAnswers,
  }) {
    return ExamModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      questions: questions ?? this.questions,
      timeLimit: timeLimit ?? this.timeLimit,
      passingScore: passingScore ?? this.passingScore,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
      userAnswers: userAnswers ?? this.userAnswers,
    );
  }

  bool get isPassed => score != null && score! >= passingScore;
}