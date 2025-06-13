import 'package:application_mobile_educative_college/services/examen_service.dart';
import 'package:application_mobile_educative_college/services/matiere_service.dart';
import 'package:application_mobile_educative_college/services/chapitre_service.dart';
import 'package:application_mobile_educative_college/services/lecon_service.dart';
import 'package:application_mobile_educative_college/services/exercice_service.dart';

import '../models/lecon_model.dart';
import '../models/examen_model.dart';
import '../models/progress_model.dart';
import '../models/matiere_model.dart';
import '../models/chapitre_model.dart';
import '../models/exercice_model.dart';

import 'storage_service.dart';

class DataService {
  static List<MatiereModel> _matieres = [];
  static List<ChapitreModel> _chapitres = [];
  static List<LeconModel> _lecons = [];
  static List<ExerciceModel> _exercises = [];
  static List<ExamenModel> _examens = [];
  static UserProgress? _userProgress;

  // Getter
  static List<MatiereModel> get matieres => _matieres;
  static List<ChapitreModel> get chapitres => _chapitres;
  static List<LeconModel> get lecons => _lecons;
  static List<ExerciceModel> get exercises => _exercises;
  static List<ExamenModel> get examens => _examens;
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

  static Future<void> loadMatiereExercices(int matiereId) async {
    _exercises = await ExerciceService.loadMatiereExercices(matiereId);
  }

  static Future<void> loadMatiereExamens(int matiereId) async {
    _examens = await ExamenService.loadMatiereExamens(matiereId);
  }

  static String getMatiereOfLecon(LeconModel lecon) {
    ChapitreModel? chapitre = _chapitres.firstWhere(
      (c) => c.id == lecon.chapitreId,
      orElse:
          () =>
              throw Exception('Chapitre non trouvé pour la leçon ${lecon.id}'),
    );

    MatiereModel matiere = _matieres.firstWhere(
      (m) => m.id == chapitre.matiereId,
      orElse:
          () =>
              throw Exception(
                'Matière non trouvée pour le chapitre ${chapitre.id}',
              ),
    );

    return matiere.nom;
  }

  static String getMatiereOfExamen(ExamenModel examen) {
    MatiereModel matiere = _matieres.firstWhere(
      (m) => m.id == examen.matiereId,
      orElse:
          () =>
              throw Exception(
                'Matière non trouvée pour le chapitre ${examen.id}',
              ),
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

  // static List<ExerciseModel> getExercisesBySubject(String subject) {
  //   return _exercises.where((exercise) => exercise.subject == subject).toList();
  // }

  // static List<ExamenModel> getExamsBySubject(String subject) {
  //   return _examens.where((exam) => exam.subject == subject).toList();
  // }
}
