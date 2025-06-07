
class ChapitreModel {
  final int _id,_matiereId;
  final String _nom, _description;
  final DateTime _createdAt, _updatedAt;

  ChapitreModel._internal(this._id, this._matiereId, this._nom, this._description, this._createdAt, this._updatedAt);

  factory ChapitreModel.fromMap(Map<String, Object?> map) {
    return ChapitreModel._internal(
      map['id'] as int, 
      map['matiere_id'] as int,
      map['nom'].toString(),
      map['description'].toString(), 
      DateTime.parse(map['created_at'].toString()),
      DateTime.parse(map['updated_at'].toString())
    );
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?> {
      "id": _id,
      "matiere_id": _matiereId,
      "nom": _nom,
      "description": _description,
      "created_at": _createdAt.toIso8601String(),
      "updated_at": _updatedAt.toIso8601String(),
    };

    return map;
  }
}
