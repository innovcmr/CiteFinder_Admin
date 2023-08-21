import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class AddHomeRequest {
  String? id;
  DocumentReference<Map<String, dynamic>> user;
  String buildingName;
  String quarter;
  DocumentReference<Map<String, dynamic>> town;

  String ownerName;
  String ownerPhone;
  String ownerEmail;

  DateTime dateAdded;
  AddHomeRequest(
      {this.id,
      required this.buildingName,
      required this.dateAdded,
      required this.ownerPhone,
      required this.ownerEmail,
      required this.ownerName,
      required this.quarter,
      required this.town,
      required this.user});

  factory AddHomeRequest.fromMap(Map<String, dynamic> map) {
    return AddHomeRequest(
        id: map[Config.firebaseKeys.id],
        user: map[Config.firebaseKeys.user],
        town: map[Config.firebaseKeys.town],
        quarter: map[Config.firebaseKeys.quarter],
        buildingName: map['buildingName'],
        ownerEmail: map['ownerEmail'],
        ownerName: map['ownerName'],
        ownerPhone: map['ownerPhone'],
        dateAdded: toDate(map[Config.firebaseKeys.dateAdded])!);
  }

  toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.user: user,
      Config.firebaseKeys.town: town,
      Config.firebaseKeys.quarter: quarter,
      'buildingName': buildingName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'ownerName': ownerName,
      Config.firebaseKeys.dateAdded: dateAdded,
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.addHomeRequests)
          .doc(id)
      : FirebaseFirestore.instance
          .collection(Config.firebaseKeys.addHomeRequests)
          .doc();

  static Future<AddHomeRequest> getKYCFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.addHomeRequests)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return AddHomeRequest.fromMap(objectData);
    }
    throw Exception("couldNotGetData".tr);
  }

  static Future<AddHomeRequest?> update(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.addHomeRequests)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.addHomeRequests)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return AddHomeRequest.fromMap(updatedData);
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
