import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class HomeSearchRequest {
  String? id;
  DocumentReference<Map<String, dynamic>> user;
  String name;
  String address;
  DocumentReference<Map<String, dynamic>> town;

  String phoneNumber;
  String description;
  String status;

  DateTime dateAdded;
  HomeSearchRequest(
      {this.id,
      required this.address,
      required this.dateAdded,
      required this.description,
      required this.name,
      required this.phoneNumber,
      required this.town,
      required this.status,
      required this.user});

  factory HomeSearchRequest.fromMap(Map<String, dynamic> map) {
    return HomeSearchRequest(
        id: map[Config.firebaseKeys.id],
        user: map[Config.firebaseKeys.user],
        town: map[Config.firebaseKeys.town],
        status: map[Config.firebaseKeys.status],
        address: map[Config.firebaseKeys.address],
        description: map[Config.firebaseKeys.description],
        phoneNumber: map[Config.firebaseKeys.phoneNumber],
        name: map[Config.firebaseKeys.name],
        dateAdded: toDate(map[Config.firebaseKeys.dateAdded])!);
  }

  toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.user: user,
      Config.firebaseKeys.town: town,
      Config.firebaseKeys.address: address,
      Config.firebaseKeys.phoneNumber: phoneNumber,
      Config.firebaseKeys.name: name,
      Config.firebaseKeys.status: status,
      Config.firebaseKeys.description: description,
      Config.firebaseKeys.dateAdded: dateAdded,
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.homeSearchRequest)
          .doc(id)
      : FirebaseFirestore.instance
          .collection(Config.firebaseKeys.homeSearchRequest)
          .doc();

  static Future<HomeSearchRequest> getFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.homeSearchRequest)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return HomeSearchRequest.fromMap(objectData);
    }
    throw Exception("couldNotGetData".tr);
  }

  static Future<HomeSearchRequest?> update(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.homeSearchRequest)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.homeSearchRequest)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return HomeSearchRequest.fromMap(updatedData);
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
