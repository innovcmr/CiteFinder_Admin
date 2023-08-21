import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class Notification {
  String id;
  List<String>? recipientsType;

  /// specific user to whom a notification might be targeted.
  DocumentReference<Map<String, dynamic>>? user;

  String title;
  String? body;
  String type;

  ///type of notification (general, homes, transactions, agent)
  List<DocumentReference<Map<String, dynamic>>>? readBy;

  List<String>? images;

  ///a link attached to the notification
  String? link;

  ///route to which the notification should lead to on click
  String? route;

  /// extra data which a notification could contain
  Map<String, dynamic>? extras;

  ///the date the notification was created
  DateTime dateAdded;

  Notification(
      {required this.id,
      required this.title,
      required this.type,
      required this.recipientsType,
      this.body,
      this.readBy = const [],
      this.images = const [],
      this.link,
      this.route,
      this.extras,
      this.user,
      required this.dateAdded});

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
        id: map[Config.firebaseKeys.id],
        title: map[Config.firebaseKeys.title],
        type: map[Config.firebaseKeys.type],
        recipientsType: map[Config.firebaseKeys.recipientsType]?.cast<String>(),
        body: map[Config.firebaseKeys.body],
        readBy: map[Config.firebaseKeys.readBy]
            ?.cast<DocumentReference<Map<String, dynamic>>>(),
        images: map[Config.firebaseKeys.images]?.cast<String>(),
        link: map[Config.firebaseKeys.link],
        route: map[Config.firebaseKeys.route],
        extras: map[Config.firebaseKeys.extras],
        user: map[Config.firebaseKeys.user],
        dateAdded:
            toDate(map[Config.firebaseKeys.dateAdded]) ?? DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.title: title,
      Config.firebaseKeys.type: type,
      Config.firebaseKeys.recipientsType: recipientsType,
      Config.firebaseKeys.body: body,
      Config.firebaseKeys.readBy: readBy,
      Config.firebaseKeys.images: images,
      Config.firebaseKeys.link: link,
      Config.firebaseKeys.route: route,
      Config.firebaseKeys.extras: extras,
      Config.firebaseKeys.user: user,
      Config.firebaseKeys.dateAdded: dateAdded,
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record =>
      FirebaseFirestore.instance
          .collection(Config.firebaseKeys.notifications)
          .doc(id);

  static Future<Notification> getNotificationFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.notifications)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return Notification.fromMap(objectData);
    }
    throw Exception("couldNotGetNotificationData".tr);
  }

  static Future<Notification?> updateNotification(
      String id, Map<String, dynamic> fields) async {
    final doc = FirebaseFirestore.instance
        .collection(Config.firebaseKeys.locations)
        .doc(id);

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return Notification.fromMap(updatedData);
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
