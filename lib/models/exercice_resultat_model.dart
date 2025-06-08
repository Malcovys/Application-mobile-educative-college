
class ReponseModel {
  final String selectionne;
  final bool correcte;

  ReponseModel({
    required this.selectionne,
    required this.correcte
  });

  factory ReponseModel.fromJson(Map<String, dynamic> json) {
    return ReponseModel(
      selectionne: json['selected'], 
      correcte: json['correct']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selected': selectionne,
      'correct': correcte
    };
  }  
}

enum ResultatEtat {
  sync,
  nonSync
}

class ExerciceResultatModel {
  final int id, exerciceId;
  final List<ReponseModel> reponses;
  final int score;
  final ResultatEtat etat;
  final DateTime dateDeSoumission;

  ExerciceResultatModel({
    required this.id,
    required this.exerciceId,
    required this.reponses,
    required this.score,
    required this.etat,
    required this.dateDeSoumission
  });

  factory ExerciceResultatModel.fromJson(Map<String, dynamic> json) {
    return ExerciceResultatModel(
      id: json['id'], 
      exerciceId: json['exercice_id'], 
      reponses: (json['reponses'] as List)
        .map((r) => ReponseModel.fromJson(r))
        .toList(), 
      score: json['score'], 
      etat: json['etat'], 
      dateDeSoumission: json['date_de_soumission']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercice_id': exerciceId,
      'reponses': reponses.map((r) => r.toJson()).toList(),
      'score': score,
      'etat': etat,
      'date_de_soumission': dateDeSoumission
    };
  }
}