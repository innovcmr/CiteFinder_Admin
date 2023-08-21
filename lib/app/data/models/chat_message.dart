import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class ChatMessage {
  String id;
  DocumentReference<Map<String, dynamic>> sender;
  DocumentReference<Map<String, dynamic>> receiver;
  DocumentReference<Map<String, dynamic>> chat;
  List<DocumentReference<Map<String, dynamic>>> visibleTo;
  String text;
  List<String> images;
  DateTime timestamp;
  bool isRead;

  ChatMessage(
      {required this.id,
      required this.sender,
      required this.receiver,
      required this.chat,
      required this.text,
      required this.visibleTo,
      this.images = const <String>[],
      this.isRead = false,
      required this.timestamp});

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
        id: map[Config.firebaseKeys.id],
        sender: map[Config.firebaseKeys.sender],
        receiver: map[Config.firebaseKeys.receiver],
        chat: map[Config.firebaseKeys.chat],
        text: map[Config.firebaseKeys.text],
        visibleTo: map[Config.firebaseKeys.visibleTo] != null
            ? map[Config.firebaseKeys.visibleTo]
                .cast<DocumentReference<Map<String, dynamic>>>()
            : [],
        images: map[Config.firebaseKeys.images]?.cast<String>() ?? <String>[],
        isRead: map[Config.firebaseKeys.isRead] ?? false,
        timestamp: toDate(map[Config.firebaseKeys.timestamp])!);
  }

  Map<String, dynamic> toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.sender: sender,
      Config.firebaseKeys.receiver: receiver,
      Config.firebaseKeys.chat: chat,
      Config.firebaseKeys.text: text,
      Config.firebaseKeys.visibleTo: visibleTo,
      Config.firebaseKeys.images: images,
      Config.firebaseKeys.isRead: isRead,
      Config.firebaseKeys.timestamp: timestamp
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection(Config.firebaseKeys.chat_messages);

  DocumentReference<Map<String, dynamic>>? get record =>
      FirebaseFirestore.instance
          .collection(Config.firebaseKeys.chat_messages)
          .doc(id);

  static Future<ChatMessage> getChatMessageFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.chat_messages)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return ChatMessage.fromMap(objectData);
    }
    throw Exception("couldNotGetData".tr);
  }

  static Future<ChatMessage?> updateChatMessage(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.chat_messages)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.chat_messages)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return ChatMessage.fromMap(updatedData);
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
