import '../api/api_service.dart';
import '../models/exercice_model.dart';

class ExerciceService {

    static Future<List<ExerciceModel>> loadMatiereExercices(int matiereId) async {
        return await ApiExerciceService.getExercicesByMatiere(matiereId);
    }
}
