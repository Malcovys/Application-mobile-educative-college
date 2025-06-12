class ApiRoutes {
  static const String apiUrl = 'http://192.168.20.71:3000/api';

  // endpoints d'authentification
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // endpoints des chapitres
  static const String chapitres = '/chapitres/matiere/{matiereId}';
  static const String chapitre = '/chapitres/{chapitreId}';

  // endpoints des exercices
  static const String exercices = '/exercices';
  static const String exercice = '/exercices/{exerciceId}';

  // endpoints des résultats d'exercices
  static const String exercicesResultats = '/exercices-resultats';
  static const String exerciceResultat = '/exercices-resultats/{resultatId}';

  // endpoints des leçons
  static const String lecons = '/lecons/chapitre/{chapitreId}';
  static const String lecon = '/lecons/{leconId}';

  // endpoints des matières
  static const String matieres = '/matieres/niveau';
  static const String matiere = '/matieres/{matiereId}';

  // endpoints des simulations d'examen
  static const String examens = '/simulations';
  static const String examen = '/simulations/{examenId}';

  // Remplace les paramètres dans une route
  static String path(String route, {Map<String, dynamic>? params}) {
    if (params == null) return route;
    return params.entries.fold(
      route,
      (r, entry) => r.replaceAll('{${entry.key}}', entry.value.toString()),
    );
  }
}
