// ignore_for_file: prefer_initializing_formals

import 'package:cite_finder_admin/app/data/models/location_model2.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

enum Availability { NONE, LOW, MEDIUM, HIGH, ALWAYS }

class Home2 {
  String? id;
  String? name;
  String? description;
  String? type;
  String? mainImage;
  String? shortVideo;
  double? rating;
  DocumentReference<Map<String, dynamic>>? landlord;
  DateTime? dateAdded;
  DateTime? dateModified;
  Availability? waterAvailability;
  Availability? electricityAvailability;
  Availability? security;
  Location? location;
  List<String>? facilities;
  List<String>? images;
  double? basePrice;
  bool isApproved = false;

  Home2(
      {String? id,
      String? name,
      String? description,
      String? type,
      String? mainImage,
      String? shortVideo,
      double? rating,
      DocumentReference<Map<String, dynamic>>? landlord,
      DateTime? dateAdded,
      DateTime? dateModified,
      Availability? waterAvailability,
      Availability? electricityAvailability,
      Availability? security,
      location,
      List<String>? facilities,
      double? basePrice,
      List<String>? images,
      bool isApproved = false}) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.type = type;
    this.mainImage = mainImage;
    this.shortVideo = shortVideo;
    this.rating = rating;
    this.landlord = landlord;
    this.dateAdded = dateAdded;
    this.dateModified = dateModified;
    this.waterAvailability = waterAvailability;
    this.electricityAvailability = electricityAvailability;
    this.security = security;
    this.location = location;
    this.facilities = facilities;
    this.images = images;
    this.basePrice = basePrice;
    this.isApproved = isApproved;
  }

  factory Home2.fromMap(Map<String, dynamic> map) {
    return Home2(
        id: map[Config.firebaseKeys.id],
        name: map[Config.firebaseKeys.name],
        type: map[Config.firebaseKeys.type],
        description: map[Config.firebaseKeys.description],
        mainImage: map[Config.firebaseKeys.mainImage],
        shortVideo: map[Config.firebaseKeys.shortVideo],
        rating: map[Config.firebaseKeys.rating],
        dateAdded: map[Config.firebaseKeys.dateAdded].runtimeType is DateTime
            ? map[Config.firebaseKeys.dateAdded]
            : (map[Config.firebaseKeys.dateAdded] as Timestamp?)?.toDate(),
        dateModified:
            map[Config.firebaseKeys.dateModified].runtimeType is DateTime
                ? map[Config.firebaseKeys.dateAdded]
                : (map[Config.firebaseKeys.dateAdded] as Timestamp?)?.toDate(),
        waterAvailability: map[Config.firebaseKeys.waterAvailability],
        electricityAvailability:
            map[Config.firebaseKeys.electricityAvailability],
        facilities: map[Config.firebaseKeys.facilities].cast<String>(),
        images: map[Config.firebaseKeys.images].cast<String>(),
        security: map[Config.firebaseKeys.security],
        location: map[Config.firebaseKeys.location] != null
            ? Location.fromMap(map[Config.firebaseKeys.location])
            : null,
        landlord: map[Config.firebaseKeys.landlord],
        basePrice: map[Config.firebaseKeys.basePrice],
        isApproved: map[Config.firebaseKeys.isApproved] ?? false);
  }

  toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.name: name,
      Config.firebaseKeys.description: description,
      Config.firebaseKeys.type: type,
      Config.firebaseKeys.mainImage: mainImage,
      Config.firebaseKeys.shortVideo: shortVideo,
      Config.firebaseKeys.rating: rating,
      Config.firebaseKeys.dateAdded: dateAdded,
      Config.firebaseKeys.dateModified: dateModified,
      Config.firebaseKeys.waterAvailability: waterAvailability,
      Config.firebaseKeys.electricityAvailability: electricityAvailability,
      Config.firebaseKeys.security: security,
      Config.firebaseKeys.location: location,
      Config.firebaseKeys.landlord: landlord,
      Config.firebaseKeys.facilities: facilities,
      Config.firebaseKeys.images: images,
      Config.firebaseKeys.basePrice: basePrice,
      Config.firebaseKeys.isApproved: isApproved,
    };
  }

  toString() {
    return this.toMap().toString();
  }

  DocumentReference<Map<String, dynamic>> get record => id != null
      ? FirebaseFirestore.instance.collection(Config.firebaseKeys.homes).doc(id)
      : FirebaseFirestore.instance.collection(Config.firebaseKeys.homes).doc();

  static Future<Home2> getHomeFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final homeData =
        (await firestore.collection(Config.firebaseKeys.homes).doc(uid).get())
            .data();

    if (homeData != null) {
      return Home2.fromMap(homeData);
    }
    throw Exception("Could not get home data");
  }

  static Future<Home2?> updateHome(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.homes)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.homes)
            .doc();

    //if document does not exists create it
    if (!(await doc.get()).exists) {
      await doc.set({...fields, Config.firebaseKeys.id: doc.id});
    } else {
      await doc.update(fields);
    }

    final updatedData = (await doc.get()).data();

    if (updatedData != null)
      return Home2.fromMap(updatedData);
    else
      return null;
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
