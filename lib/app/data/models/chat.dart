import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class Chat {
  String id;
  List<DocumentReference<Map<String, dynamic>>> users;

  DocumentReference<Map<String, dynamic>> userA;
  DocumentReference<Map<String, dynamic>> userB;
  String? lastMessage;
  DateTime? lastMessageTime;
  DocumentReference<Map<String, dynamic>>? lastMessageSentBy;
  List<DocumentReference<Map<String, dynamic>>> lastMessageSeenBy;
  List<DocumentReference<Map<String, dynamic>>> visibleTo;

  Chat(
      {required this.id,
      required this.users,
      required this.userA,
      required this.userB,
      required this.visibleTo,
      required this.lastMessage,
      required this.lastMessageSeenBy,
      required this.lastMessageSentBy,
      required this.lastMessageTime});

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map[Config.firebaseKeys.id],
      users: map[Config.firebaseKeys.users] != null
          ? map[Config.firebaseKeys.users]
              .cast<DocumentReference<Map<String, dynamic>>>()
          : [],
      userA: map[Config.firebaseKeys.userA],
      userB: map[Config.firebaseKeys.userB],
      visibleTo: map[Config.firebaseKeys.visibleTo] != null
          ? map[Config.firebaseKeys.visibleTo]
              .cast<DocumentReference<Map<String, dynamic>>>()
          : [],
      lastMessage: map[Config.firebaseKeys.lastMessage],
      lastMessageTime: toDate(map[Config.firebaseKeys.lastMessageTime]),
      lastMessageSentBy: map[Config.firebaseKeys.lastMessageSentBy],
      lastMessageSeenBy: map[Config.firebaseKeys.lastMessageSeenBy] != null
          ? map[Config.firebaseKeys.lastMessageSeenBy]
              .cast<DocumentReference<Map<String, dynamic>>>()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.users: users,
      Config.firebaseKeys.userA: userA,
      Config.firebaseKeys.userB: userB,
      Config.firebaseKeys.visibleTo: visibleTo,
      Config.firebaseKeys.lastMessage: lastMessage,
      Config.firebaseKeys.lastMessageSeenBy: lastMessageSeenBy,
      Config.firebaseKeys.lastMessageTime: lastMessageTime,
      Config.firebaseKeys.lastMessageSentBy: lastMessageSentBy,
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record =>
      FirebaseFirestore.instance.collection(Config.firebaseKeys.chats).doc(id);

  static Future<Chat> getChatFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData =
        (await firestore.collection(Config.firebaseKeys.chats).doc(uid).get())
            .data();

    if (objectData != null) {
      return Chat.fromMap(objectData);
    }
    throw Exception("couldNotGetData".tr);
  }

  static Future<Chat?> updateChat(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.chats)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.chats)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return Chat.fromMap(updatedData);
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
