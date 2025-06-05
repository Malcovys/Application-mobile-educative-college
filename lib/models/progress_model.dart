class SubjectProgress {
  final String subject;
  final int completedLessons;
  final int totalLessons;
  final int completedExercises;
  final int totalExercises;
  final int completedExams;
  final int totalExams;
  final double averageScore;
  final DateTime lastActivity;

  SubjectProgress({
    required this.subject,
    required this.completedLessons,
    required this.totalLessons,
    required this.completedExercises,
    required this.totalExercises,
    required this.completedExams,
    required this.totalExams,
    required this.averageScore,
    required this.lastActivity,
  });

  double get overallProgress {
    final lessonProgress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;
    final exerciseProgress = totalExercises > 0 ? completedExercises / totalExercises : 0.0;
    final examProgress = totalExams > 0 ? completedExams / totalExams : 0.0;
    
    return (lessonProgress + exerciseProgress + examProgress) / 3;
  }

  factory SubjectProgress.fromJson(Map<String, dynamic> json) {
    return SubjectProgress(
      subject: json['subject'],
      completedLessons: json['completedLessons'],
      totalLessons: json['totalLessons'],
      completedExercises: json['completedExercises'],
      totalExercises: json['totalExercises'],
      completedExams: json['completedExams'],
      totalExams: json['totalExams'],
      averageScore: json['averageScore'].toDouble(),
      lastActivity: DateTime.parse(json['lastActivity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'completedExercises': completedExercises,
      'totalExercises': totalExercises,
      'completedExams': completedExams,
      'totalExams': totalExams,
      'averageScore': averageScore,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }
}

class UserProgress {
  final String userId;
  final List<SubjectProgress> subjectProgress;
  final int totalStudyTime; // in minutes
  final int streak; // consecutive days
  final DateTime lastLoginDate;
  final List<String> achievements;

  UserProgress({
    required this.userId,
    required this.subjectProgress,
    required this.totalStudyTime,
    required this.streak,
    required this.lastLoginDate,
    required this.achievements,
  });

  double get overallProgress {
    if (subjectProgress.isEmpty) return 0.0;
    return subjectProgress
        .map((s) => s.overallProgress)
        .reduce((a, b) => a + b) / subjectProgress.length;
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'],
      subjectProgress: (json['subjectProgress'] as List)
          .map((s) => SubjectProgress.fromJson(s))
          .toList(),
      totalStudyTime: json['totalStudyTime'],
      streak: json['streak'],
      lastLoginDate: DateTime.parse(json['lastLoginDate']),
      achievements: List<String>.from(json['achievements']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'subjectProgress': subjectProgress.map((s) => s.toJson()).toList(),
      'totalStudyTime': totalStudyTime,
      'streak': streak,
      'lastLoginDate': lastLoginDate.toIso8601String(),
      'achievements': achievements,
    };
  }
}