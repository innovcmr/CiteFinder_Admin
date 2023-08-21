import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../../utils/config.dart';
import '../../utils/new_utils.dart';

class AppUser {
  String? id;
  String? fullName;
  String? email;
  String? photoURL;
  String? location;
  String? role;
  String? phoneNumber;
  DateTime? dateAdded = DateTime.now();
  bool isVerified = false;
  bool isGoogleUser = false;
  bool isFacebookUser = false;
  bool isDeleted = false;

  AppUser(
      {this.id,
      this.fullName,
      this.email,
      this.location,
      this.photoURL,
      this.role,
      this.phoneNumber,
      this.dateAdded,
      this.isDeleted = false,
      this.isVerified = false,
      this.isFacebookUser = false,
      this.isGoogleUser = false});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
        id: map[Config.firebaseKeys.id],
        fullName: map[Config.firebaseKeys.fullName],
        email: map[Config.firebaseKeys.email],
        location: map[Config.firebaseKeys.location],
        photoURL: map[Config.firebaseKeys.photoURL],
        role: map[Config.firebaseKeys.role],
        isDeleted: map[Config.firebaseKeys.isDeleted] ?? false,
        phoneNumber: map[Config.firebaseKeys.phoneNumber],
        dateAdded: toDate(map[Config.firebaseKeys.dateAdded]),
        isVerified: map[Config.firebaseKeys.isVerified] ?? false,
        isGoogleUser: map[Config.firebaseKeys.isGoogleUser] ?? false,
        isFacebookUser: map[Config.firebaseKeys.isFacebookUser] ?? false);
  }

  toMap() {
    return {
      Config.firebaseKeys.id: id,
      Config.firebaseKeys.fullName: fullName,
      Config.firebaseKeys.email: email,
      Config.firebaseKeys.location: location,
      Config.firebaseKeys.role: role,
      Config.firebaseKeys.photoURL: photoURL,
      Config.firebaseKeys.phoneNumber: phoneNumber,
      Config.firebaseKeys.isVerified: isVerified,
      Config.firebaseKeys.dateAdded: dateAdded,
      Config.firebaseKeys.isGoogleUser: isGoogleUser,
      Config.firebaseKeys.isFacebookUser: isFacebookUser,
      Config.firebaseKeys.isDeleted: isDeleted,
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  static void updateUserFromMap(AppUser user, Map<String, dynamic> map) {
    if (map[Config.firebaseKeys.id] != null)
      user.id = map[Config.firebaseKeys.id];
    if (map[Config.firebaseKeys.fullName] != null)
      user.fullName = map[Config.firebaseKeys.fullName];
    if (map[Config.firebaseKeys.email] != null)
      user.email = map[Config.firebaseKeys.email];
    if (map[Config.firebaseKeys.location] != null)
      user.location = map[Config.firebaseKeys.location];
    if (map[Config.firebaseKeys.role] != null)
      user.role = map[Config.firebaseKeys.role];

    if (map[Config.firebaseKeys.phoneNumber] != null) {
      user.phoneNumber = map[Config.firebaseKeys.phoneNumber];
    }
    if (map[Config.firebaseKeys.isVerified] != null) {
      user.isVerified = map[Config.firebaseKeys.isVerified];
    }

    if (map[Config.firebaseKeys.isDeleted] != null) {
      user.isDeleted = map[Config.firebaseKeys.isDeleted];
    }

    if (map[Config.firebaseKeys.photoURL] != null)
      user.photoURL = map[Config.firebaseKeys.photoURL];
    if (map[Config.firebaseKeys.isGoogleUser] != null) {
      user.isGoogleUser = map[Config.firebaseKeys.isGoogleUser];
    }
    if (map[Config.firebaseKeys.isFacebookUser] != null) {
      user.isFacebookUser = map[Config.firebaseKeys.isFacebookUser];
    }
  }

  DocumentReference<Map<String, dynamic>>? get record => id != null
      ? FirebaseFirestore.instance.collection(Config.firebaseKeys.users).doc(id)
      : FirebaseFirestore.instance.collection(Config.firebaseKeys.users).doc();

  static Future<AppUser> getUserFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;
    Map<String, dynamic>? userData;

    userData =
        (await firestore.collection(Config.firebaseKeys.users).doc(uid).get())
            .data();

    if (userData != null) {
      return AppUser.fromMap(userData);
    }
    throw Exception("couldNotGetUserData".tr);
  }

  static Future<AppUser?> updateUser(
      String? id, Map<String, dynamic> fields) async {
    final doc = id != null
        ? FirebaseFirestore.instance
            .collection(Config.firebaseKeys.users)
            .doc(id)
        : FirebaseFirestore.instance
            .collection(Config.firebaseKeys.users)
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
      return AppUser.fromMap(updatedData);
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
