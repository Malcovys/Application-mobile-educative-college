
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
      chapitreId: json['chapitreId'], 
      titre: json['titre'], 
      contenu: json['contenu'], 
      createdAt: DateTime.parse(json['created_at']), 
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapitreId': chapitreId,
      'titre': titre,
      'contenu': contenu,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

}