import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';

class ExamenService {
  static final apiClient = ApiClient();
  
  static Future<List<Map<String, dynamic>>> getExamens() async {
    final response = await apiClient.get(ApiRoutes.examens);
    return List<Map<String, dynamic>>.from(response.data);
  }
  
  static Future<Map<String, dynamic>> getExamen(int examenId) async {
    final path = ApiRoutes.path(ApiRoutes.examen, params: {'examenId': examenId});
    final response = await apiClient.get(path);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> createExamen(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.examens, data: data);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> updateExamen(int examenId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.examen, params: {'examenId': examenId});
    final response = await apiClient.put(path, data: data);
    return response.data;
  }
  
  static Future<void> deleteExamen(int examenId) async {
    final path = ApiRoutes.path(ApiRoutes.examen, params: {'examenId': examenId});
    await apiClient.delete(path);
  }
} 