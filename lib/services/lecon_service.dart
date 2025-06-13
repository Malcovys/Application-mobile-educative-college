import '../api/api_service.dart';
import '../models/lecon_model.dart';

class LeconService {

  static Future<List<LeconModel>> loadChapitreLecons(int chapitreId) async {
    return await ApiLeconService.getLeconsByChapitre(chapitreId);
  }
  
}
