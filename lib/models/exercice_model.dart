import '../types/types.dart';

class ExerciceModel {
  final int id, leconId;
  final String nom;
  final List<Question> questions;
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
      questions: json['questions'],  // A adaper en fonction du format de l'api
      createdAt: DateTime.parse(json['created_at']), 
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lecon_id': leconId,
      'nom': nom,
      'questions': questions, // A adaper en fonction du format de l'api
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String() 
    };
  }
}