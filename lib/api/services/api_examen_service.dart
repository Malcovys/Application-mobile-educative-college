import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';

import '../../models/examen_model.dart';

class ApiExamenService {
  static final apiClient = ApiClient();

  static Future<List<ExamenModel>> getMatiereExamens(int matiereId) async {
    final List<ExamenModel> listExam = [];

    try {
      final path = ApiRoutes.path(ApiRoutes.examens, params: {'matiereId': matiereId});
      final response = await apiClient.get(path);

      for (var data in response.data["simulation"]) {
        listExam.add(ExamenModel.fromJson(data));
      }
    } catch (error) {
      print(error);
    }
    return listExam;
  }

  static Future<Map<String, dynamic>> getExamen(int examenId) async {
    final path = ApiRoutes.path(
      ApiRoutes.examen,
      params: {'examenId': examenId},
    );
    final response = await apiClient.get(path);
    return response.data;
  }

  static Future<Map<String, dynamic>> createExamen(
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.post(ApiRoutes.examens, data: data);
    return response.data;
  }

  static Future<Map<String, dynamic>> updateExamen(
    int examenId,
    Map<String, dynamic> data,
  ) async {
    final path = ApiRoutes.path(
      ApiRoutes.examen,
      params: {'examenId': examenId},
    );
    final response = await apiClient.put(path, data: data);
    return response.data;
  }

  static Future<void> deleteExamen(int examenId) async {
    final path = ApiRoutes.path(
      ApiRoutes.examen,
      params: {'examenId': examenId},
    );
    await apiClient.delete(path);
  }
}
