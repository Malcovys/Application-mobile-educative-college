import 'storage_service.dart';
import '../models/matiere_model.dart';
import 'package:application_mobile_educative_college/api/api_client.dart';

final apiClient = ApiClient();

class Token {
  String? access;
  String? refresh;

  Token({required this.access, required this.refresh});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(access: json['access'], refresh: json['refresh']);
  }

  Map<String, String> toJson() {
    return {'access': access ?? "", 'refresh': refresh ?? ""};
  }
}

class Utilisateur {
  String nom;
  Niveau niveau;

  Utilisateur({required this.nom, required this.niveau});

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      nom: json['nom'],
      niveau: Niveau.fromString(json['niveau']),
    );
  }

  Map<String, String> toJson() {
    return {'nom': nom, 'niveau': niveau.value};
  }
}

class AuthService {
  static Token? _token;
  static bool _isAuth = false;
  static Utilisateur? _utilisateur;

  static bool get isAuth => _isAuth;
  static String? get accessToken => _token?.access;
  static Utilisateur? get utilisateur => _utilisateur;

  static String storageTokenKey = 'token';
  static String storageUtilisateurKey = 'utilisateur';

  static Future<void> initialize() async {
    await StorageService.init();

    _token = StorageService.loadData(storageTokenKey, Token.fromJson);
    _utilisateur = StorageService.loadData(
      storageUtilisateurKey,
      Utilisateur.fromJson,
    );

    if (_token != null) {
      _isAuth = true;

      if (_token!.access != null) {
        apiClient.setAuthToken(_token!.access!);
      }
    }
  }

  static Future<void> login(String email, String password) async {
    final response = await apiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    // Parse et stocke les données
    _token = Token.fromJson(response.data);
    _utilisateur = Utilisateur.fromJson(response.data['user']);
    _isAuth = true;

    apiClient.setAuthToken(_token!.access!);

    await StorageService.saveData(storageTokenKey, _token!.toJson());
    await StorageService.saveData(
        storageUtilisateurKey, _utilisateur!.toJson());
  }

  static Future<void> logout() async {
    _token = null;
    _utilisateur = null;
    _isAuth = false;

    apiClient.clearAuthToken();

    await StorageService.clearAll();
  }
}
