import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String? id;
  GeoPoint? geoCoordinates;
  String? city;
  String? quarter;

  Location({this.id, this.geoCoordinates, this.city, this.quarter});

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
        id: map[Config.firebaseKeys.id],
        geoCoordinates: map[Config.firebaseKeys.geoCoordinates],
        city: map[Config.firebaseKeys.city],
        quarter: map[Config.firebaseKeys.quarter]);
  }

  Map<String, dynamic> toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.geoCoordinates: geoCoordinates,
      Config.firebaseKeys.city: city,
      Config.firebaseKeys.quarter: quarter
    };
  }

  toString() {
    return this.toMap().toString();
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance
          .collection(Config.firebaseKeys.locations)
          .doc(id)
      : null;

  static Future<Location> getLocationFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final objectData = (await firestore
            .collection(Config.firebaseKeys.homeRooms)
            .doc(uid)
            .get())
        .data();

    if (objectData != null) {
      return Location.fromMap(objectData);
    }
    throw Exception("Could not get location data");
  }

  static Future<Location?> updateLocation(
      String id, Map<String, dynamic> fields) async {
    final doc = FirebaseFirestore.instance
        .collection(Config.firebaseKeys.locations)
        .doc(id);

    await doc.update(fields);

    final updatedData = (await doc.get()).data();

    if (updatedData != null)
      return Location.fromMap(updatedData);
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
