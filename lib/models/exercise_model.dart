class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String type; // 'multiple_choice', 'true_false', 'fill_blank'

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.type,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'type': type,
    };
  }
}

class ExerciseModel {
  final String id;
  final String title;
  final String lessonId;
  final String subject;
  final List<QuestionModel> questions;
  final int timeLimit; // in minutes
  final bool isCompleted;
  final int? score;
  final DateTime? completedAt;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.lessonId,
    required this.subject,
    required this.questions,
    required this.timeLimit,
    this.isCompleted = false,
    this.score,
    this.completedAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      title: json['title'],
      lessonId: json['lessonId'],
      subject: json['subject'],
      questions: (json['questions'] as List)
          .map((q) => QuestionModel.fromJson(q))
          .toList(),
      timeLimit: json['timeLimit'],
      isCompleted: json['isCompleted'] ?? false,
      score: json['score'],
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lessonId': lessonId,
      'subject': subject,
      'questions': questions.map((q) => q.toJson()).toList(),
      'timeLimit': timeLimit,
      'isCompleted': isCompleted,
      'score': score,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  ExerciseModel copyWith({
    String? id,
    String? title,
    String? lessonId,
    String? subject,
    List<QuestionModel>? questions,
    int? timeLimit,
    bool? isCompleted,
    int? score,
    DateTime? completedAt,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      lessonId: lessonId ?? this.lessonId,
      subject: subject ?? this.subject,
      questions: questions ?? this.questions,
      timeLimit: timeLimit ?? this.timeLimit,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}