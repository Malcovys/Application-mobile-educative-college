import 'exercice_model.dart';

class ExamenModel {
  final int id, matiereId;
  final String nom;
  final int duree;
  final List<QuestionModel> questions;
  final DateTime dateLimite;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExamenModel({
    required this.id,
    required this.matiereId,
    required this.nom,
    required this.duree,
    required this.questions,
    required this.dateLimite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExamenModel.fromJson(Map<String, dynamic> json) {
    return ExamenModel(
      id: json['id'],
      matiereId: json['matiereId'],
      nom: json['nom'],
      duree: json['duree'],
      questions:
          (json['questions'] as List)
              .map((q) => QuestionModel.fromJson(q))
              .toList(),
      dateLimite: DateTime.parse(json['date_limite']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matiereId': matiereId,
      'duree': duree,
      'nom': nom,
      'questions': questions.map((q) => q.toJson()).toList(),
      'date_limite': dateLimite.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
