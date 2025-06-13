import '../api/api_service.dart';
import '../db/services/database_matiere_service.dart';
import '../models/matiere_model.dart';

class MatiereService {

  static Future<List<MatiereModel>> loadMatieres() async {
    

    return await ApiMatiereService.getMatieres();
  }
}
