
class LeconModel {
  final int id, chapitreId;
  final String titre, contenu;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeconModel({
    required this.id,
    required this.chapitreId,
    required this.titre,
    required this.contenu,
    required this.createdAt,
    required this.updatedAt
  });

  factory LeconModel.fromJson(Map<String, dynamic> json) {
    return LeconModel(
      id: json['id'], 
      chapitreId: json['chapitre_id'], 
      titre: json['titre'], 
      contenu: json['contenu'], 
      createdAt: json['created_at'], 
      updatedAt: json['updated_at']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapitre_id': chapitreId,
      'titre': titre,
      'contenu': contenu,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

}