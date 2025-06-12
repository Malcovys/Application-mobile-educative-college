import 'package:application_mobile_educative_college/api/api_service.dart';

import 'package:application_mobile_educative_college/services/matiere_service.dart';
import 'package:application_mobile_educative_college/services/chapitre_service.dart';
import 'package:application_mobile_educative_college/services/lecon_service.dart';

import '../models/lecon_model.dart';
import '../models/exercise_model.dart';
import '../models/exam_model.dart';
import '../models/progress_model.dart';
import '../models/matiere_model.dart';
import '../models/chapitre_model.dart';

import 'storage_service.dart';

class DataService {
  static List<MatiereModel> _matieres = [];
  static List<ChapitreModel> _chapitres = [];
  static List<LeconModel> _lecons = [];

  static List<ExerciseModel> _exercises = [];
  static List<ExamModel> _exams = [];
  static UserProgress? _userProgress;

  static List<MatiereModel> get matieres => _matieres;
  static List<ChapitreModel> get chapitres => _chapitres;
  static List<LeconModel> get lecons => _lecons;

  static List<ExerciseModel> get exercises => _exercises;
  static List<ExamModel> get exams => _exams;
  static UserProgress? get userProgress => _userProgress;

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

  static Future<void> loadChapitreLecons(int chapitreId) async {
    _lecons = await LeconService.loadChapitreLecons(chapitreId);
  }

  static String getMatiereOfLecon(LeconModel lecon) {
    ChapitreModel? chapitre = _chapitres.firstWhere(
      (c) => c.id == lecon.chapitreId,
      orElse: () => throw Exception('Chapitre non trouvé pour la leçon ${lecon.id}'),
    );
    
    MatiereModel matiere = _matieres.firstWhere(
      (m) => m.id == chapitre.matiereId,
      orElse: () => throw Exception('Matière non trouvée pour le chapitre ${chapitre.id}'),
    );
  
  return matiere.nom;
}

  static Future<void> _loadOrCreateSampleData() async {
    final chaptersData = StorageService.loadChapters();
    final progressData = StorageService.loadProgress();

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

    if (progressData != null) {
      _userProgress = UserProgress.fromJson(progressData);
    } else {
      _userProgress = _generateSampleProgress();
      await StorageService.saveProgress(_userProgress!.toJson());
    }
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

  static List<ExerciseModel> getExercisesBySubject(String subject) {
    return _exercises.where((exercise) => exercise.subject == subject).toList();
  }

  static List<ExamModel> getExamsBySubject(String subject) {
    return _exams.where((exam) => exam.subject == subject).toList();
  }
}
