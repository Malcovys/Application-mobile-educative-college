
class ChapitreModel {
  final int id, matiereId;
  final String nom;
  final String? description;
  final DateTime createdAt, updatedAt;

  ChapitreModel({
    required this.id, 
    required this.matiereId, 
    required this.nom, 
    this.description, 
    required this.createdAt, 
    required this.updatedAt
  });

  factory ChapitreModel.fromJson(Map<String, dynamic> json) {
    return ChapitreModel(
      id: json['id'], 
      matiereId: json['matiere_id'],
      nom: json['nom'],
      description: json['description'], 
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matiere_id': matiereId,
      'nom': nom,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
