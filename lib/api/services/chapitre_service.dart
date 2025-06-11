import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';

class ChapitreService {
  static final apiClient = ApiClient();
  
  static Future<List<Map<String, dynamic>>> getChapitres() async {
    final response = await apiClient.get(ApiRoutes.chapitres);
    return List<Map<String, dynamic>>.from(response.data);
  }
  
  static Future<Map<String, dynamic>> getChapitre(int chapitreId) async {
    final path = ApiRoutes.path(ApiRoutes.chapitre, params: {'chapitreId': chapitreId});
    final response = await apiClient.get(path);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> createChapitre(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.chapitres, data: data);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> updateChapitre(int chapitreId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.chapitre, params: {'chapitreId': chapitreId});
    final response = await apiClient.put(path, data: data);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> patchChapitre(int chapitreId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.chapitre, params: {'chapitreId': chapitreId});
    final response = await apiClient.patch(path, data: data);
    return response.data;
  }
  
  static Future<void> deleteChapitre(int chapitreId) async {
    final path = ApiRoutes.path(ApiRoutes.chapitre, params: {'chapitreId': chapitreId});
    await apiClient.delete(path);
  }
} 