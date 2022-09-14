import 'package:cloud_firestore/cloud_firestore.dart';

class KYC {
  String? id;
  String? idFront;
  String? idBack;
  String? idUser;
  DocumentReference<Map<String, dynamic>>? user;
  String? status;
  DateTime? dateAdded;

  KYC(
      {this.id,
      this.idFront,
      this.idBack,
      this.idUser,
      this.user,
      this.status,
      this.dateAdded});

  KYC.fromJson(json) {
    id = json.toString().contains("id") ? json['id'] : '';
    idFront = json.toString().contains("idFront") ? json['idFront'] : '';
    idBack = json.toString().contains("idBack") ? json['idBack'] : '';
    idUser = json.toString().contains("idUser") ? json['idUser'] : '';
    user = json.toString().contains("user") ? json['user'] : null;
    status = json.toString().contains("status") ? json['status'] : '';
    dateAdded =
        json.toString().contains("dateAdded") ? json['dateAdded:'] : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['idFront'] = idFront;
    data['idBack'] = idBack;
    data['idUser'] = idUser;
    data['user'] = user;
    data['status'] = status;
    data['dateAdded:'] = dateAdded;
    return data;
  }
}
