import '../types/types.dart';

class MatiereModel {
  final int _id;
  String _nom, _description;
  Niveau _niveau;
  DateTime _createdAt,_updatedAt;

  // MatiereModel(this._id);

  MatiereModel._internal(this._id, this._nom, this._niveau, this._description, this._createdAt, this._updatedAt);

  factory MatiereModel.fromMap(Map<String, Object?> map) {
    return MatiereModel._internal(
      map['id'] as int, 
      map['nom'].toString(),
      Niveau.fromString(map['niveau'].toString()), 
      map['description']?.toString() ?? '', 
      DateTime.parse(map['created_at'].toString()),
      DateTime.parse(map['updated_at'].toString())
    );
  }

  Map<String, Object> toMap() {
    var map = <String, Object> {
      "id": _id,
      "nom": _nom,
      "niveau": _niveau.value,
      "description": _description,
      "created_at": _createdAt.toIso8601String(),
      "updated_at": _updatedAt.toIso8601String(),
    };

    return map;
  }

  int getId() {
    return _id;
  }

  String getNom() {
    return _nom;
  }

  Niveau getNiveau() {
    return _niveau;
  }

  String getDescription() {
    return _description;
  }

  DateTime getCreatedAt() {
    return _createdAt;
  } 

  DateTime getUpdatedAt() {
    return _updatedAt;
  }

  // void setNom(String value) {
  //   _nom = value;
  // }

  // void setNivau(Niveau value) {
  //   _niveau = value;
  // }

  // void setDescription(String value) {
  //   _description = value;
  // }

  // void setCreatedAt(DateTime value) {
  //   _updatedAt = value;
  // }

  // void setUpdatedAt(DateTime value) {
  //   _updatedAt = value;
  // }
}