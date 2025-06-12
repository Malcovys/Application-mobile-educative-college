import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';

import 'package:application_mobile_educative_college/models/chapitre_model.dart';

class ApiChapitreService {
  static final apiClient = ApiClient();
  
  // static Future<List<ChapitreModel>> getChapitres() async {
  //   final response = await apiClient.get(ApiRoutes.chapitres);
  //   final data = response.data;
  //   final chapitres = data['chapitres'] ?? [];
  //   return List<ChapitreModel>.from(
  //     chapitres.map((json) => ChapitreModel.fromJson(json)),
  //   );
  // }

  static Future<List<ChapitreModel>> getChapitresByMatiere(int matiereId) async {
    final List<ChapitreModel> listChapitre = [];

    final path = ApiRoutes.path(ApiRoutes.chapitres, params: {'matiereId': matiereId});
    final response = await apiClient.get(path);

    for (var data in response.data["chapitres"]) {
      listChapitre.add(ChapitreModel.fromJson(data));
    }
    
    return listChapitre;
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