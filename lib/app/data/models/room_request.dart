import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class RoomRequestModel {
  String? id;
  DocumentReference<Map<String, dynamic>>? home;
  DocumentReference<Map<String, dynamic>>? user;
  DocumentReference<Map<String, dynamic>>? roomType;
  DocumentReference<Map<String, dynamic>>? paymentPlan;
  int periodCount;

  String status;
  DateTime dateAdded;

  RoomRequestModel(
      {this.id,
      required this.home,
      required this.user,
      required this.status,
      this.paymentPlan,
      this.periodCount = 1,
      required this.roomType,
      required this.dateAdded});

  factory RoomRequestModel.fromMap(Map<String, dynamic> map) {
    return RoomRequestModel(
        id: map[Config.firebaseKeys.id],
        home: map[Config.firebaseKeys.home],
        user: map[Config.firebaseKeys.user],
        roomType: map[Config.firebaseKeys.roomType],
        paymentPlan: map[Config.firebaseKeys.paymentPlan],
        periodCount: map[Config.firebaseKeys.periodCount],
        status: map[Config.firebaseKeys.status],
        dateAdded: toDate(map[Config.firebaseKeys.dateAdded])!);
  }

  Map<String, dynamic> toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.user: user,
      Config.firebaseKeys.home: home,
      Config.firebaseKeys.roomType: roomType,
      Config.firebaseKeys.paymentPlan: paymentPlan,
      Config.firebaseKeys.periodCount: periodCount,
      Config.firebaseKeys.status: status,
      Config.firebaseKeys.dateAdded: dateAdded
    };
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = map[Config.firebaseKeys.id];
    home = map[Config.firebaseKeys.home];
    user = map[Config.firebaseKeys.user];
    roomType = map[Config.firebaseKeys.roomType];
    paymentPlan = map[Config.firebaseKeys.paymentPlan];
    periodCount = map[Config.firebaseKeys.periodCount];
    status = map[Config.firebaseKeys.status];
    dateAdded = toDate(map[Config.firebaseKeys.dateAdded])!;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.roomRequests)
          .doc(id)
      : FirebaseFirestore.instance
          .collection(Config.firebaseKeys.roomRequests)
          .doc();

  static Future<RoomRequestModel> getRoomRequestModelFromFirestore(
      String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.roomRequests)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return RoomRequestModel.fromMap(objectData);
    }
    throw Exception("Could not get room requests".tr);
  }

  static Future<RoomRequestModel?> updateRoomRequestModel(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.roomRequests)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.roomRequests)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return RoomRequestModel.fromMap(updatedData);
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
