import 'package:application_mobile_educative_college/api/api_service.dart';
import 'package:application_mobile_educative_college/services/matiere_service.dart';
import 'package:application_mobile_educative_college/services/chapitre_service.dart';

import '../models/lesson_model.dart';
import '../models/exercise_model.dart';
import '../models/exam_model.dart';
import '../models/progress_model.dart';
import '../models/matiere_model.dart';
import '../models/chapitre_model.dart';

import 'storage_service.dart';

class DataService {
  static List<LessonModel> _lessons = [];
  static List<ExerciseModel> _exercises = [];
  static List<ExamModel> _exams = [];
  static List<MatiereModel> _matieres = [];
  static List<ChapitreModel> _chapitres = [];
  static UserProgress? _userProgress;

  static List<ChapitreModel> get chapitres => _chapitres;

  static Future<void> initialize() async {
    await StorageService.init();

    await _loadOrCreateSampleData();

    await loadMatieres();
  }

  static Future<void> loadMatieres() async {
    _matieres = await MatiereService.loadMatieres();
  }

  static Future<void> loadMatiereChapitres(int matiereId) async {
    _chapitres = await ChapitreService.loadMatiereChapitres(matiereId);
  }

  static List<MatiereModel> get matieres => _matieres;

  static Future<void> _loadOrCreateSampleData() async {
    // Load existing data
    final lessonsData = StorageService.loadLessons();
    final chaptersData = StorageService.loadChapters();
    final exercisesData = StorageService.loadExercises();
    final examsData = StorageService.loadExams();
    final progressData = StorageService.loadProgress();

    if (lessonsData.isNotEmpty) {
      _lessons = lessonsData.map((json) => LessonModel.fromJson(json)).toList();
    } else {
      _lessons = _generateSampleLessons();
      await StorageService.saveLessons(
        _lessons.map((l) => l.toJson()).toList(),
      );
    }

    if (chaptersData.isNotEmpty) {
      _chapitres =
          chaptersData.map((json) => ChapitreModel.fromJson(json)).toList();
    } else {
      int? matiereId = _matieres.isNotEmpty ? _matieres.first.id : null;
      if (matiereId != null) {
        _chapitres = await ChapitreService.loadMatiereChapitres(matiereId);
        await StorageService.saveChapters(
          _chapitres.map((c) => c.toJson()).toList(),
        );
      } else {
        _chapitres = [];
        await StorageService.saveChapters([]);
      }
    }

    if (exercisesData.isNotEmpty) {
      _exercises =
          exercisesData.map((json) => ExerciseModel.fromJson(json)).toList();
    } else {
      _exercises = _generateSampleExercises();
      await StorageService.saveExercises(
        _exercises.map((e) => e.toJson()).toList(),
      );
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

    // Mathematique lessons
    lessons.addAll([
      LessonModel(
        id: 'math_1',
        title: 'Equations Lineaire ',
        subject: 'Mathematique',
        content: '''# Equations Lineaire

## Introduction
Une équation linéaire est une équation qui contient des variables portées à la première puissance seulement.

## Forme Generale 
ax + b = 0, where a ≠ 0

## Méthodes de résolution
1. **Isoler la variable** : Déplacer tous les termes contenant x d’un côté
2. **Simplifier** : Effectuer des opérations arithmétiques
3. **Vérifier** : Remplacer la solution dans l’équation d’origine

## Exemples pratiques
- 2x + 5 = 13 → x = 4
- 3x - 7 = 2x + 1 → x = 8

## Applications
Les équations linéaires sont utilisées dans de nombreux domaines, notamment la physique, l’économie et la géométrie.''',
        duration: 45,
        difficulty: 'Facile',
        objectives: [
          'Comprendre la forme générale d’une équation linéaire',
          'Techniques de solution maîtresse',
          'Appliquer les connaissances à des problèmes concrets',
        ],
      ),
      LessonModel(
        id: 'math_2',
        title: 'Functions Lineaire',
        subject: 'Mathematique',
        content: '''# Functions Lineaire

## Definition
Une fonction linéaire est une fonction de la forme f(x) = ax où a est un nombre réel appelé pente.

## Représentation graphique
- Le graphe d’une fonction linéaire est une ligne droite passant par l’origine
- La pente de cette ligne est égale au coefficient a

## Propriétés importantes
1. f(0) = 0 (la fonction passe par l’origine)
2. f(x + y) = f(x) + f(y) (additivité)
3. f(kx) = kf(x) (homogénéité)

## Exemples
- f(x) = 2x : pente = 2
- g(x) = -0.5x : pente = -0.5

## Applications pratiques
Les fonctions linéaires modélisent de nombreuses situations proportionnelles dans la vie quotidienne.''',
        duration: 50,
        difficulty: 'Moyen',
        objectives: [
          'Identifier une fonction linéaire',
          'Dessiner le graphe d’une fonction linéaire',
          'Résoudre les problèmes de proportionnalité',
        ],
      ),
    ]);

    // Science lessons
    lessons.addAll([
      LessonModel(
        id: 'sci_1',
        title: 'Structure atomique',
        subject: 'Science',
        content: '''# Structure atomique

## Introduction
Un atome est la plus petite unité de matière qui conserve les propriétés d’un élément chimique.

## Composition de l’atome
1. **Le noyau** : centre de l’atome contenant :
   - Protons (charge positive)
   - Neutrons (charge neutre)

2. **Électrons** : particules à charge négative en orbite autour du noyau

## Modèles atomiques
- **Modèle Rutherford** : Atome presque vide avec un noyau dense
- **Bohr Model** : Electrons on circular orbits
- **Modèle quantique** : orbitales d’électrons

## Notation
- Nombre atomique Z = nombre de protons
- Nombre de masse A = protons + neutrons
- Notation : 23Na (sodium-23)

## Important
La compréhension de la structure atomique est fondamentale pour la chimie et la physique.''',
        duration: 40,
        difficulty: 'Moyen',
        objectives: [
          'Connaître la composition de l’atome',
          'Distinguer les différents modèles atomiques',
          'Utiliser des notatios atomique',
        ],
      ),
    ]);

    return lessons;
  }

  static List<ExerciseModel> _generateSampleExercises() {
    final exercises = <ExerciseModel>[];

    exercises.add(
      ExerciseModel(
        id: 'ex_math_1',
        title: 'Lineaire Equations Practice',
        lessonId: 'math_1',
        subject: 'Mathematique',
        timeLimit: 20,
        questions: [
          QuestionModel(
            id: 'q1',
            question: 'résoudre l’équation: 2x + 5 = 13',
            options: ['x = 4', 'x = 6', 'x = 8', 'x = 2'],
            correctAnswerIndex: 0,
            explanation: '2x = 13 - 5 = 8, so x = 8 ÷ 2 = 4',
            type: 'multiple_choice',
          ),
          QuestionModel(
            id: 'q2',
            question: 'Quelle est la solution to 3x - 7 = 2x + 1?',
            options: ['x = 8', 'x = 6', 'x = 4', 'x = 10'],
            correctAnswerIndex: 0,
            explanation: '3x - 2x = 1 + 7, so x = 8',
            type: 'multiple_choice',
          ),
        ],
      ),
    );

    exercises.add(
      ExerciseModel(
        id: 'ex_sci_1',
        title: 'Structure atomique Quiz',
        lessonId: 'sci_1',
        subject: 'Science',
        timeLimit: 15,
        questions: [
          QuestionModel(
            id: 'q3',
            question: 'Les protons ont une charge électrique positive.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
            explanation: 'Les protons portent en effet une charge positive.',
            type: 'true_false',
          ),
          QuestionModel(
            id: 'q4',
            question:
                'Combien d’électrons possède un atome de carbone neutre (Z=6)?',
            options: ['4', '6', '8', '12'],
            correctAnswerIndex: 1,
            explanation: 'Un atome neutre a autant d’électrons que de protons.',
            type: 'multiple_choice',
          ),
        ],
      ),
    );

    return exercises;
  }

  static List<ExamModel> _generateSampleExams() {
    final exams = <ExamModel>[];

    exams.add(
      ExamModel(
        id: 'exam_math_1',
        title: 'Examen Mathematique - Algebre',
        subject: 'Mathematique',
        timeLimit: 60,
        passingScore: 60,
        difficulty: 'Moyen',
        questions: [
          QuestionModel(
            id: 'eq1',
            question: 'Resoudre: 5x - 3 = 2x + 9',
            options: ['x = 4', 'x = 6', 'x = 3', 'x = 2'],
            correctAnswerIndex: 0,
            explanation: '5x - 2x = 9 + 3, so 3x = 12, x = 4',
            type: 'multiple_choice',
          ),
          QuestionModel(
            id: 'eq2',
            question: 'Si f(x) = 3x, what is f(5)?',
            options: ['8', '15', '25', '35'],
            correctAnswerIndex: 1,
            explanation: 'f(5) = 3 × 5 = 15',
            type: 'multiple_choice',
          ),
          QuestionModel(
            id: 'eq3',
            question: 'Une fonction linéaire passe toujours par l’origine.',
            options: ['True', 'False'],
            correctAnswerIndex: 0,
            explanation: 'Par definition, f(x) = ax implies f(0) = 0.',
            type: 'true_false',
          ),
        ],
      ),
    );

    return exams;
  }

  static UserProgress _generateSampleProgress() {
    final now = DateTime.now();
    return UserProgress(
      userId: 'student_1',
      totalStudyTime: 245,
      streak: 5,
      lastLoginDate: now,
      achievements: ['Premier leçon términé', 'Premier semaine términee'],
      subjectProgress: [],
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
  static Future<void> updateLessonProgress(
    String lessonId,
    bool isCompleted,
  ) async {
    final index = _lessons.indexWhere((l) => l.id == lessonId);
    if (index != -1) {
      _lessons[index] = _lessons[index].copyWith(isCompleted: isCompleted);
      await StorageService.saveLessons(
        _lessons.map((l) => l.toJson()).toList(),
      );
    }
  }

  static Future<void> updateExerciseProgress(
    String exerciseId,
    bool isCompleted,
    int score,
  ) async {
    final index = _exercises.indexWhere((e) => e.id == exerciseId);
    if (index != -1) {
      _exercises[index] = _exercises[index].copyWith(
        isCompleted: isCompleted,
        score: score,
        completedAt: DateTime.now(),
      );
      await StorageService.saveExercises(
        _exercises.map((e) => e.toJson()).toList(),
      );
    }
  }

  static Future<void> updateExamProgress(
    String examId,
    bool isCompleted,
    int score,
    List<int> userAnswers,
  ) async {
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
