import '../api/api_service.dart';
import '../models/chapitre_model.dart';

class ChapitreService {

  static Future<List<ChapitreModel>> loadMatiereChapitres(int matiereId) async {
    return await ApiChapitreService.getChapitresByMatiere(matiereId);
  }
}