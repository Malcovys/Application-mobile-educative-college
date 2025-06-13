import '../api/api_service.dart';
import '../models/examen_model.dart';

class ExamenService {

  static Future<List<ExamenModel>> loadMatiereExamens(int matiereId) async {
    return await ApiExamenService.getMatiereExamens(matiereId);
  }
}