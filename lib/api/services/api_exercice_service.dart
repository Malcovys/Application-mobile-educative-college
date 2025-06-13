import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';
import '../../models/exercice_model.dart';

class ApiExerciceService {
  static final apiClient = ApiClient();

  // Récupérer tous les exercices
  static Future<List<ExerciceModel>> getExercicesByMatiere(int matiereId) async {
    final List<ExerciceModel> listExercice = [];

    try{
      final path = ApiRoutes.path(ApiRoutes.exercices, params: {'matiereId': matiereId});
      final response = await apiClient.get(path);

      for (var data in response.data["exercice"]) {
        listExercice.add(ExerciceModel.fromJson(data));
      }
    }catch (error) {
      print(error);
    }
    return listExercice;
  }

  // Récupérer un exercice par ID
  static Future<Map<String, dynamic>> getExercice(int exerciceId) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    final response = await apiClient.get(path);
    return response.data;
  }

  // Créer un exercice
  static Future<Map<String, dynamic>> createExercice(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.exercices, data: data);
    return response.data;
  }

  // Mettre à jour un exercice (PUT)
  static Future<Map<String, dynamic>> updateExercice(int exerciceId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    final response = await apiClient.put(path, data: data);
    return response.data;
  }

  // Mettre à jour partiellement un exercice (PATCH)
  static Future<Map<String, dynamic>> patchExercice(int exerciceId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    final response = await apiClient.patch(path, data: data);
    return response.data;
  }

  // Supprimer un exercice
  static Future<void> deleteExercice(int exerciceId) async {
    final path = ApiRoutes.path(ApiRoutes.exercice, params: {'exerciceId': exerciceId});
    await apiClient.delete(path);
  }

  // Récupérer tous les résultats d'exercices
  static Future<List<Map<String, dynamic>>> getExercicesResultats() async {
    final response = await apiClient.get(ApiRoutes.exercicesResultats);
    return List<Map<String, dynamic>>.from(response.data);
  }

  // Récupérer un résultat d'exercice par ID
  static Future<Map<String, dynamic>> getExerciceResultat(int resultatId) async {
    final path = ApiRoutes.path(ApiRoutes.exerciceResultat, params: {'resultatId': resultatId});
    final response = await apiClient.get(path);
    return response.data;
  }

  // Créer un résultat d'exercice
  static Future<Map<String, dynamic>> createExerciceResultat(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.exercicesResultats, data: data);
    return response.data;
  }
}