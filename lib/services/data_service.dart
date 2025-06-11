import 'dart:math';
import '../models/lesson_model.dart';
import '../models/exercise_model.dart';
import '../models/exam_model.dart';
import '../models/progress_model.dart';
import '../utils/storage_service.dart';

class DataService {
  static List<LessonModel> _lessons = [];
  static List<ExerciseModel> _exercises = [];
  static List<ExamModel> _exams = [];
  static UserProgress? _userProgress;

  static final List<String> subjects = [
    'Mathematics',
    'Science',
    'Literature',
    'History',
    'Geography',
  ];

  static Future<void> initialize() async {
    await StorageService.init();
    await _loadOrCreateSampleData();
  }

  static Future<void> _loadOrCreateSampleData() async {
    // Load existing data
    final lessonsData = StorageService.loadLessons();
    final exercisesData = StorageService.loadExercises();
    final examsData = StorageService.loadExams();
    final progressData = StorageService.loadProgress();

    if (lessonsData.isNotEmpty) {
      _lessons = lessonsData.map((json) => LessonModel.fromJson(json)).toList();
    } else {
      _lessons = _generateSampleLessons();
      await StorageService.saveLessons(_lessons.map((l) => l.toJson()).toList());
    }

    if (exercisesData.isNotEmpty) {
      _exercises = exercisesData.map((json) => ExerciseModel.fromJson(json)).toList();
    } else {
      _exercises = _generateSampleExercises();
      await StorageService.saveExercises(_exercises.map((e) => e.toJson()).toList());
    }

    if (examsData.isNotEmpty) {
      _exams = examsData.map((json) => ExamModel.fromJson(json)).toList();
    } else {
      _exams = _generateSampleExams();
      await StorageService.saveExams(_exams.map((e) => e.toJson()).toList());
    }

    if (progressData != null) {
      _userProgress = UserProgress.fromJson(progressData);
    } else {
      _userProgress = _generateSampleProgress();
      await StorageService.saveProgress(_userProgress!.toJson());
    }
  }

  static List<LessonModel> _generateSampleLessons() {
    final lessons = <LessonModel>[];
    
    // Mathematics lessons
    lessons.addAll([
      LessonModel(
        id: 'math_1',
        title: 'Linear Equations',
        subject: 'Mathematics',
        content: '''# Linear Equations

## Introduction
A linear equation is an equation that contains variables raised to the first power only.

## General Form
ax + b = 0, where a ≠ 0

## Solution Methods
1. **Isolate the variable**: Move all terms containing x to one side
2. **Simplify**: Perform arithmetic operations
3. **Verify**: Substitute the solution into the original equation

## Practical Examples
- 2x + 5 = 13 → x = 4
- 3x - 7 = 2x + 1 → x = 8

## Applications
Linear equations are used in many fields including physics, economics, and geometry.''',
        duration: 45,
        difficulty: 'Easy',
        objectives: [
          'Understand the general form of a linear equation',
          'Master solution techniques',
          'Apply knowledge to concrete problems'
        ],
      ),
      LessonModel(
        id: 'math_2',
        title: 'Linear Functions',
        subject: 'Mathematics',
        content: '''# Linear Functions

## Definition
A linear function is a function of the form f(x) = ax where a is a real number called the slope.

## Graphical Representation
- The graph of a linear function is a straight line passing through the origin
- The slope of this line equals the coefficient a

## Important Properties
1. f(0) = 0 (the function passes through the origin)
2. f(x + y) = f(x) + f(y) (additivity)
3. f(kx) = kf(x) (homogeneity)

## Examples
- f(x) = 2x : slope = 2
- g(x) = -0.5x : slope = -0.5

## Practical Applications
Linear functions model many proportional situations in daily life.''',
        duration: 50,
        difficulty: 'Medium',
        objectives: [
          'Identify a linear function',
          'Draw the graph of a linear function',
          'Solve proportionality problems'
        ],
      ),
    ]);

    // Science lessons
    lessons.addAll([
      LessonModel(
        id: 'sci_1',
        title: 'Atomic Structure',
        subject: 'Science',
        content: '''# Atomic Structure

## Introduction
An atom is the smallest unit of matter that retains the properties of a chemical element.

## Composition of the Atom
1. **The nucleus**: Center of the atom containing:
   - Protons (positive charge)
   - Neutrons (neutral charge)

2. **Electrons**: Negatively charged particles orbiting around the nucleus

## Atomic Models
- **Rutherford Model**: Atom mostly empty with a dense nucleus
- **Bohr Model**: Electrons on circular orbits
- **Quantum Model**: Electron orbitals

## Notation
- Atomic number Z = number of protons
- Mass number A = protons + neutrons
- Notation: 23Na (sodium-23)

## Importance
Understanding atomic structure is fundamental to chemistry and physics.''',
        duration: 40,
        difficulty: 'Medium',
        objectives: [
          'Know the composition of the atom',
          'Distinguish different atomic models',
          'Use atomic notation'
        ],
      ),
    ]);

    return lessons;
  }

  static List<ExerciseModel> _generateSampleExercises() {
    final exercises = <ExerciseModel>[];
    
    exercises.add(ExerciseModel(
      id: 'ex_math_1',
      title: 'Linear Equations Practice',
      lessonId: 'math_1',
      subject: 'Mathematics',
      timeLimit: 20,
      questions: [
        QuestionModel(
          id: 'q1',
          question: 'Solve the equation: 2x + 5 = 13',
          options: ['x = 4', 'x = 6', 'x = 8', 'x = 2'],
          correctAnswerIndex: 0,
          explanation: '2x = 13 - 5 = 8, so x = 8 ÷ 2 = 4',
          type: 'multiple_choice',
        ),
        QuestionModel(
          id: 'q2',
          question: 'What is the solution to 3x - 7 = 2x + 1?',
          options: ['x = 8', 'x = 6', 'x = 4', 'x = 10'],
          correctAnswerIndex: 0,
          explanation: '3x - 2x = 1 + 7, so x = 8',
          type: 'multiple_choice',
        ),
      ],
    ));

    exercises.add(ExerciseModel(
      id: 'ex_sci_1',
      title: 'Atomic Structure Quiz',
      lessonId: 'sci_1',
      subject: 'Science',
      timeLimit: 15,
      questions: [
        QuestionModel(
          id: 'q3',
          question: 'Protons have a positive electric charge.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation: 'Protons indeed carry a positive charge.',
          type: 'true_false',
        ),
        QuestionModel(
          id: 'q4',
          question: 'How many electrons does a neutral carbon atom (Z=6) have?',
          options: ['4', '6', '8', '12'],
          correctAnswerIndex: 1,
          explanation: 'A neutral atom has as many electrons as protons.',
          type: 'multiple_choice',
        ),
      ],
    ));

    return exercises;
  }

  static List<ExamModel> _generateSampleExams() {
    final exams = <ExamModel>[];
    
    exams.add(ExamModel(
      id: 'exam_math_1',
      title: 'Mathematics Exam - Algebra',
      subject: 'Mathematics',
      timeLimit: 60,
      passingScore: 60,
      difficulty: 'Medium',
      questions: [
        QuestionModel(
          id: 'eq1',
          question: 'Solve: 5x - 3 = 2x + 9',
          options: ['x = 4', 'x = 6', 'x = 3', 'x = 2'],
          correctAnswerIndex: 0,
          explanation: '5x - 2x = 9 + 3, so 3x = 12, x = 4',
          type: 'multiple_choice',
        ),
        QuestionModel(
          id: 'eq2',
          question: 'If f(x) = 3x, what is f(5)?',
          options: ['8', '15', '25', '35'],
          correctAnswerIndex: 1,
          explanation: 'f(5) = 3 × 5 = 15',
          type: 'multiple_choice',
        ),
        QuestionModel(
          id: 'eq3',
          question: 'A linear function always passes through the origin.',
          options: ['True', 'False'],
          correctAnswerIndex: 0,
          explanation: 'By definition, f(x) = ax implies f(0) = 0.',
          type: 'true_false',
        ),
      ],
    ));

    return exams;
  }

  static UserProgress _generateSampleProgress() {
    final now = DateTime.now();
    return UserProgress(
      userId: 'student_1',
      totalStudyTime: 245,
      streak: 5,
      lastLoginDate: now,
      achievements: ['First lesson completed', 'First week completed'],
      subjectProgress: subjects.map((subject) {
        final random = Random();
        final lessonsForSubject = _lessons.where((l) => l.subject == subject).length;
        final exercisesForSubject = _exercises.where((e) => e.subject == subject).length;
        final examsForSubject = _exams.where((e) => e.subject == subject).length;
        
        return SubjectProgress(
          subject: subject,
          completedLessons: random.nextInt(lessonsForSubject + 1),
          totalLessons: lessonsForSubject.clamp(1, 4),
          completedExercises: random.nextInt(exercisesForSubject + 1),
          totalExercises: exercisesForSubject.clamp(1, 6),
          completedExams: random.nextInt(examsForSubject + 1),
          totalExams: examsForSubject.clamp(1, 3),
          averageScore: 60 + random.nextDouble() * 35,
          lastActivity: now.subtract(Duration(days: random.nextInt(7))),
        );
      }).toList(),
    );
  }

  // Getters
  static List<LessonModel> get lessons => _lessons;
  static List<ExerciseModel> get exercises => _exercises;
  static List<ExamModel> get exams => _exams;
  static UserProgress? get userProgress => _userProgress;

  // Get data by subject
  static List<LessonModel> getLessonsBySubject(String subject) {
    return _lessons.where((lesson) => lesson.subject == subject).toList();
  }

  static List<ExerciseModel> getExercisesBySubject(String subject) {
    return _exercises.where((exercise) => exercise.subject == subject).toList();
  }

  static List<ExamModel> getExamsBySubject(String subject) {
    return _exams.where((exam) => exam.subject == subject).toList();
  }

  // Update methods
  static Future<void> updateLessonProgress(String lessonId, bool isCompleted) async {
    final index = _lessons.indexWhere((l) => l.id == lessonId);
    if (index != -1) {
      _lessons[index] = _lessons[index].copyWith(isCompleted: isCompleted);
      await StorageService.saveLessons(_lessons.map((l) => l.toJson()).toList());
    }
  }

  static Future<void> updateExerciseProgress(String exerciseId, bool isCompleted, int score) async {
    final index = _exercises.indexWhere((e) => e.id == exerciseId);
    if (index != -1) {
      _exercises[index] = _exercises[index].copyWith(
        isCompleted: isCompleted,
        score: score,
        completedAt: DateTime.now(),
      );
      await StorageService.saveExercises(_exercises.map((e) => e.toJson()).toList());
    }
  }

  static Future<void> updateExamProgress(String examId, bool isCompleted, int score, List<int> userAnswers) async {
    final index = _exams.indexWhere((e) => e.id == examId);
    if (index != -1) {
      _exams[index] = _exams[index].copyWith(
        isCompleted: isCompleted,
        score: score,
        completedAt: DateTime.now(),
        userAnswers: userAnswers,
      );
      await StorageService.saveExams(_exams.map((e) => e.toJson()).toList());
    }
  }
}