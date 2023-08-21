import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';

class HomeLocation {
  String? id;
  GeoPoint? geoCoordinates;
  String? city;
  String? quarter;
  DocumentReference<Map<String, dynamic>>? town;

  HomeLocation(
      {this.id, this.geoCoordinates, this.city, this.quarter, this.town});

  factory HomeLocation.fromMap(Map<String, dynamic> map) {
    return HomeLocation(
        id: map[Config.firebaseKeys.id],
        geoCoordinates: map[Config.firebaseKeys.geoCoordinates],
        city: map[Config.firebaseKeys.city],
        quarter: map[Config.firebaseKeys.quarter],
        town: map[Config.firebaseKeys.town]);
  }

  Map<String, dynamic> toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.geoCoordinates: geoCoordinates,
      Config.firebaseKeys.city: city,
      Config.firebaseKeys.quarter: quarter,
      Config.firebaseKeys.town: town
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.locations)
          .doc(id)
      : null;

  static Future<HomeLocation> getHomeLocationFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.locations)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return HomeLocation.fromMap(objectData);
    }
    throw Exception("couldNotGetLocationData".tr);
  }

  static Future<HomeLocation?> updateHomeLocation(
      String id, Map<String, dynamic> fields) async {
    final doc = FirebaseFirestore.instance
        .collection(Config.firebaseKeys.locations)
        .doc(id);

    await doc.update(fields);

    final updatedData = (await doc.get()).data();

    if (updatedData != null) {
      return HomeLocation.fromMap(updatedData);
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
