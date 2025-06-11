import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';

class MatiereService {
  static final apiClient = ApiClient();
  
  static Future<List<Map<String, dynamic>>> getMatieres() async {
    final response = await apiClient.get(ApiRoutes.matieres);
    return List<Map<String, dynamic>>.from(response.data);
  }
  
  static Future<Map<String, dynamic>> getMatiere(int matiereId) async {
    final path = ApiRoutes.path(ApiRoutes.matiere, params: {'matiereId': matiereId});
    final response = await apiClient.get(path);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> createMatiere(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.matieres, data: data);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> updateMatiere(int matiereId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.matiere, params: {'matiereId': matiereId});
    final response = await apiClient.put(path, data: data);
    return response.data;
  }
  
  static Future<void> deleteMatiere(int matiereId) async {
    final path = ApiRoutes.path(ApiRoutes.matiere, params: {'matiereId': matiereId});
    await apiClient.delete(path);
  }
} 