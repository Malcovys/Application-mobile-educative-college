
class OptionModel {
  final String label, valeur;
  final bool correcte;

  OptionModel({
    required this.label,
    required this.valeur,
    required this.correcte
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      label: json['label'] ?? '', 
      valeur: json['value'] ?? '', 
      correcte: json['correct'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': valeur,
      'correct': correcte
    };
  }
}

class QuestionModel {
  final String ennonce;
  final List<OptionModel> options;
  final String explication;

  QuestionModel({
    required this.ennonce,
    required this.options,
    required this.explication
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      ennonce: json['ennonce'],
      options: (json['options'] as List)
          .map((op) => OptionModel.fromJson(op))
          .toList(),
      explication: json['explication']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ennonce': ennonce,
      'options': options,
      'explication': explication,
    };
  }
}

class ExerciceModel {
  final int id, leconId;
  final String nom;
  final List<QuestionModel> questions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExerciceModel({
    required this.id,
    required this.leconId,
    required this.nom,
    required this.questions,
    required this.createdAt,
    required this.updatedAt
  });

  factory ExerciceModel.fromJson(Map<String, dynamic> json) {
    return ExerciceModel(
      id: json['id'], 
      leconId: json['lecon_id'], 
      nom: json['nom'], 
      questions:(json['questions'] as List)
        .map((q) => QuestionModel.fromJson(q))
        .toList(),
      createdAt: DateTime.parse(json['created_at']), 
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lecon_id': leconId,
      'nom': nom,
      'questions': questions.map((q) => q.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String() 
    };
  }
}