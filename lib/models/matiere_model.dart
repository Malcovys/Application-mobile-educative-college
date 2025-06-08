import '../types/types.dart';

class MatiereModel {
  final int id;
  final String nom;
  final String? description;
  final Niveau niveau;
  final DateTime createdAt, updatedAt;

  MatiereModel({
    required this.id, 
    required this.nom, 
    required this.niveau, 
    this.description, 
    required this.createdAt, 
    required this.updatedAt
  });

  factory MatiereModel.fromJson(Map<String, dynamic> json) {
    return MatiereModel(
      id:  json['id'], 
      nom: json['nom'], 
      niveau: Niveau.fromString(json['niveau']), 
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']), 
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'niveau': niveau.value,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}