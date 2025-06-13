import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';
import '../../models/lecon_model.dart';

class ApiLeconService {
  static final apiClient = ApiClient();
  

  static Future<List<LeconModel>> getLeconsByChapitre(int chapitreId) async {
    final List<LeconModel> listLecon = [];

    try{
      final path = ApiRoutes.path(ApiRoutes.lecons, params: {'chapitreId': chapitreId } );
      final response = await apiClient.get(path);

      for (var data in response.data["lecons"]) {
        listLecon.add(LeconModel.fromJson(data));
      }
    }catch (error) {
      print(error);
    }
    return listLecon;
  }
  
  static Future<Map<String, dynamic>> getLecon(int leconId) async {
    final path = ApiRoutes.path(ApiRoutes.lecon, params: {'leconId': leconId});
    final response = await apiClient.get(path);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> createLecon(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiRoutes.lecons, data: data);
    return response.data;
  }
  
  static Future<Map<String, dynamic>> updateLecon(int leconId, Map<String, dynamic> data) async {
    final path = ApiRoutes.path(ApiRoutes.lecon, params: {'leconId': leconId});
    final response = await apiClient.put(path, data: data);
    return response.data;
  }
  
  static Future<void> deleteLecon(int leconId) async {
    final path = ApiRoutes.path(ApiRoutes.lecon, params: {'leconId': leconId});
    await apiClient.delete(path);
  }
}