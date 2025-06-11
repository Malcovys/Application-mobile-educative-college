import 'package:application_mobile_educative_college/api/api_client.dart';
import 'package:application_mobile_educative_college/api/endpoints.dart';

class ApiService {
  static final apiClient = ApiClient();
  
  // Services pour les chapitres
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

  // Services pour les exercices
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

  // Services pour les leçons
  static Future<List<Map<String, dynamic>>> getLecons() async {
    final response = await apiClient.get(ApiRoutes.lecons);
    return List<Map<String, dynamic>>.from(response.data);
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

  // Services pour les matières
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

  // Services pour les simulations d'examen
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
