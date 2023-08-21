import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class Town {
  String? id;
  String? name;
  String? region;
  DateTime? dateAdded;

  Town({this.id, this.name, this.region, this.dateAdded});

  factory Town.fromMap(Map<String, dynamic> map) {
    return Town(
        id: map[Config.firebaseKeys.id],
        name: map[Config.firebaseKeys.name],
        region: map[Config.firebaseKeys.region],
        dateAdded: toDate(map[Config.firebaseKeys.dateAdded]));
  }

  toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.name: name,
      Config.firebaseKeys.region: region,
      Config.firebaseKeys.dateAdded: dateAdded
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection(Config.firebaseKeys.towns);
  DocumentReference<Map<String, dynamic>> get record => id != null
      ? FirebaseFirestore.instance.collection(Config.firebaseKeys.towns).doc(id)
      : FirebaseFirestore.instance.collection(Config.firebaseKeys.towns).doc();

  static Future<Town> getTownFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData =
        (await firestore.collection(Config.firebaseKeys.towns).doc(uid).get())
            .data();

    if (objectData != null) {
      return Town.fromMap(objectData);
    }
    throw Exception("couldNotGetData".tr);
  }

  static Future<Town?> update(String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.towns)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.towns)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({
        ...fields,
        Config.firebaseKeys.id: doc.id,
      });
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return Town.fromMap(updatedData);
    } else {
      return null;
    }
  }

  Future<bool> delete() async {
    try {
      await record.delete();
      return true;
    } catch (err) {
      return false;
    }
  }
}
