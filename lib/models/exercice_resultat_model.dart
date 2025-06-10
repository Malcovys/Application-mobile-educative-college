
class ReponseModel {
  final String selectionne;
  final bool correcte;
  final int questionIdx;

  ReponseModel({
    required this.selectionne,
    required this.correcte,
    required this.questionIdx
  });

  factory ReponseModel.fromJson(Map<String, dynamic> json) {
    return ReponseModel(
      selectionne: json['selected'], 
      correcte: json['correct'],
      questionIdx: json['question_idx']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selected': selectionne,
      'correct': correcte,
      'question_idx': questionIdx
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
  ResultatEtat etat;
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
      score: json['score'] ?? ExerciceResultatModel._calculateScore(), 
      etat: json['etat'] ?? ResultatEtat.sync, 
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

  // à implémenté
  static int _calculateScore() {
    return 0;
  }
}