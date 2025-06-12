class LessonModel {
  final String id;
  final String title;
  final String subject;
  final String content;
  final int duration; // in minutes
  final String difficulty;
  final List<String> objectives;
  final bool isCompleted;

  LessonModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.content,
    required this.duration,
    required this.difficulty,
    required this.objectives,
    this.isCompleted = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? "",
      title: json['title'],
      subject: json['subject'],
      content: json['content'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      objectives: List<String>.from(json['objectives']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'content': content,
      'duration': duration,
      'difficulty': difficulty,
      'objectives': objectives,
      'isCompleted': isCompleted,
    };
  }

  LessonModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? content,
    int? duration,
    String? difficulty,
    List<String>? objectives,
    bool? isCompleted,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      objectives: objectives ?? this.objectives,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}