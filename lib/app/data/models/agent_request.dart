import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class AgentRequest {
  String? id;
  String idFront;
  String idBack;
  String idUser;
  String status;
  String fullName;
  String email;
  String phoneNumber;
  String city;
  String? shortVideo;
  String? idType;
  DocumentReference<Map<String, dynamic>> user;

  DateTime dateAdded;
  AgentRequest(
      {this.id,
      required this.idFront,
      required this.idBack,
      required this.idUser,
      required this.user,
      required this.status,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.city,
      required this.dateAdded,
      required this.idType,
      this.shortVideo});

  factory AgentRequest.fromMap(Map<String, dynamic> map) {
    return AgentRequest(
        id: map[Config.firebaseKeys.id],
        idFront: map[Config.firebaseKeys.idFront],
        idUser: map[Config.firebaseKeys.idUser],
        user: map[Config.firebaseKeys.user],
        idBack: map[Config.firebaseKeys.idBack],
        status: map[Config.firebaseKeys.status],
        shortVideo: map[Config.firebaseKeys.shortVideo],
        fullName: map[Config.firebaseKeys.fullName],
        email: map[Config.firebaseKeys.email],
        phoneNumber: map[Config.firebaseKeys.phoneNumber],
        city: map[Config.firebaseKeys.city],
        idType: map[Config.firebaseKeys.idType],
        dateAdded: toDate(map[Config.firebaseKeys.dateAdded])!);
  }

  toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.idFront: idFront,
      Config.firebaseKeys.user: user,
      Config.firebaseKeys.idBack: idBack,
      Config.firebaseKeys.idUser: idUser,
      Config.firebaseKeys.status: status,
      Config.firebaseKeys.idType: idType,
      Config.firebaseKeys.fullName: fullName,
      Config.firebaseKeys.email: email,
      Config.firebaseKeys.phoneNumber: phoneNumber,
      Config.firebaseKeys.city: city,
      Config.firebaseKeys.dateAdded: dateAdded,
      Config.firebaseKeys.shortVideo: shortVideo
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.agentRequests)
          .doc(id)
      : FirebaseFirestore.instance
          .collection(Config.firebaseKeys.agentRequests)
          .doc();

  static Future<AgentRequest> getKYCFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.agentRequests)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return AgentRequest.fromMap(objectData);
    }
    throw Exception("couldNotGetKycData".tr);
  }

  static Future<AgentRequest?> updateKYC(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.agentRequests)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.agentRequests)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return AgentRequest.fromMap(updatedData);
    } else {
      return null;
    }
  }

  Future<bool> delete() async {
    if (record != null) {
      await record!.delete();
      return true;
    }
    return false;
  }
}
