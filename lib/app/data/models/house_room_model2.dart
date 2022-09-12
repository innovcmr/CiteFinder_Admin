// ignore_for_file: prefer_initializing_formals, unnecessary_this

import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class HomeRoom2 {
  String? id;
  DocumentReference<Map<String, dynamic>>? home;
  String? type;
  List<String>? images;
  int? numberAvailable;
  String? description;
  double? price;

  HomeRoom2({
    String? id,
    DocumentReference<Map<String, dynamic>>? home,
    String? type,
    List<String>? images,
    int? numberAvailable,
    String? description,
    double? price,
  }) {
    this.id = id;
    this.home = home;
    this.type = type;
    this.images = images;
    this.numberAvailable = numberAvailable;
    this.description = description;
    this.price = price;
  }

  factory HomeRoom2.fromMap(Map<String, dynamic> map) {
    return HomeRoom2(
      id: map[Config.firebaseKeys.id],
      home: map[Config.firebaseKeys.home],
      type: map[Config.firebaseKeys.type],
      images: map[Config.firebaseKeys.images].cast<String>(),
      numberAvailable: map[Config.firebaseKeys.numberAvailable],
      description: map[Config.firebaseKeys.description],
      price: map[Config.firebaseKeys.price],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.home: home,
      Config.firebaseKeys.description: description,
      Config.firebaseKeys.type: type,
      Config.firebaseKeys.numberAvailable: numberAvailable,
      Config.firebaseKeys.price: price,
      Config.firebaseKeys.images: images
    };
  }

  void updateFromMap(Map<String, dynamic> map) {
    this.id = map[Config.firebaseKeys.id];
    this.home = map[Config.firebaseKeys.home];
    this.type = map[Config.firebaseKeys.type];
    this.images = map[Config.firebaseKeys.images].cast<String>();
    this.numberAvailable = map[Config.firebaseKeys.numberAvailable];
    this.description = map[Config.firebaseKeys.description];
    this.price = map[Config.firebaseKeys.price];
  }

  @override
  toString() {
    return this.toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.homeRooms)
          .doc(id)
      : FirebaseFirestore.instance
          .collection(Config.firebaseKeys.homeRooms)
          .doc();

  static Future<HomeRoom2> getHomeRoomFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.homeRooms)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return HomeRoom2.fromMap(objectData);
    }
    throw Exception("Could not get user data");
  }

  static Future<HomeRoom2?> updateHomeRoom(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.homeRooms)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.homeRooms)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null)
      return HomeRoom2.fromMap(updatedData);
    else
      return null;
  }

  Future<bool> delete() async {
    if (record != null) {
      await record!.delete();
      return true;
    }
    return false;
  }
}
