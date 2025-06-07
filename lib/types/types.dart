enum ResultatEtat {
  sync,
  nonSync;
  
  // Convertir enum → String pour affichage/stockage
  String get libelle {
    switch (this) {
      case ResultatEtat.sync: return "Synchronisé";
      case ResultatEtat.nonSync: return "NonSynchronisé";
    }
  }
  
  // Convertir String → enum (pour lire depuis la BD)
  static ResultatEtat fromString(String value) {
    if (value == "Synchronisé") return ResultatEtat.sync;
    return ResultatEtat.nonSync;
  }
}

enum Niveau {
  six,
  cinq,
  quatre,
  trois;

  String get value {
    switch(this) {
      case Niveau.six: return "Sixième";
      case Niveau.cinq: return "Cinquième";
      case Niveau.quatre: return "Quatrième";
      case Niveau.trois: return "Troisième";
    }
  }

  // convertie un text donnée en etat
  static Niveau fromString(String value) {
    switch (value) {
      case "Sixième": return Niveau.six;
      case "Cinquième": return Niveau.cinq;
      case "Quatrième": return Niveau.quatre;
      case "Troisième": return Niveau.trois;
      default: throw ArgumentError('Niveau non reconnu: $value');
    }
  }
  
}