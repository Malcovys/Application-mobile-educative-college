import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../helpers/database_helper.dart';
import 'matiere_dao.dart';
import 'chapitre_dao.dart';
import 'lecon_dao.dart';
import 'exercice_dao.dart';
import 'exercice_resultat_dao.dart';

class DaoFactory {
  static final DaoFactory _instance = DaoFactory._initialize();

  factory DaoFactory() {
    return _instance;
  }

  DaoFactory._initialize();

  Future<Database> getDatabaseInstance() async {
    return await DatabaseHelper().getDatabase();
  }

  MatiereDao getMatiereDao() {
    return MatiereDao(this);
  }

  ChapitreDao getChapitreDao() {
    return ChapitreDao(this);
  }

  LeconDao getLeconDao() {
    return LeconDao(this);
  }

  ExerciceDao getExerciceDao() {
    return ExerciceDao(this);
  }

  ExerciceResultatDao getExerciceResultatDao() {
    return ExerciceResultatDao(this);
  }
}