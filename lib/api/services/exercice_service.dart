import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';

class ExerciceService {
  static final apiClient = ApiClient();
  
  static Future<List<Map<String, dynamic>>> getExercices() async {
    final response = await apiClient.get(ApiRoutes.exercices);
    return List<Map<String, dynamic>>.from(response.data);
  }
  
  static Future<Map<String, dynamic>> getExercice(int exerciceId) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    final response = await apiClient.get(path);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> createExercice(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.exercices, data: data);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> updateExercice(int exerciceId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    final response = await apiClient.put(path, data: data);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> patchExercice(int exerciceId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    final response = await apiClient.patch(path, data: data);
    return response.data;
  }
  
  static Future<void> deleteExercice(int exerciceId) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    await apiClient.delete(path);
  }

  // Services pour les résultats exercices
  static Future<List<Map<String, dynamic>>> getExercicesResultats() async {
    final response = await apiClient.get(ApiRoutes.exercicesResultats);
    return List<Map<String, dynamic>>.from(response.data);
  }
  
  static Future<Map<String, dynamic>> getExerciceResultat(int resultatId) async {
    final path = ApiRoutes.path(ApiRoutes.exerciceResultat, params: {'resultatId': resultatId});
    final response = await apiClient.get(path);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> createExerciceResultat(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.exercicesResultats, data: data);
    return response.data;
  }
} 