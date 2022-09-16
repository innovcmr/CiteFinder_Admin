import 'dart:developer';

import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? fullName;
  String? email;
  String? location;
  String? photoURL;
  String? role;
  String? dateAdded;
  bool? isVerified;
  bool? isGoogleUser;
  bool? isFacebookUser;
  String? phoneNumber;

  User(
      {this.id,
      this.fullName,
      this.email,
      this.location,
      this.photoURL,
      this.role,
      this.dateAdded,
      this.isVerified,
      this.isGoogleUser,
      this.isFacebookUser,
      this.phoneNumber});

  User.fromJson(json1, String type) {
    var json = json1;
    if (type == "document") {
      json = json1.data();
    }
    id = json.toString().contains("id") ? json['id'] : "";
    fullName = json.toString().contains("fullName") ? json['fullName'] : "";
    email = json.toString().contains("email") ? json['email'] : "";
    location = json.toString().contains("location") ? json['location'] : "";
    photoURL = json.toString().contains("photoURL") ? json['photoURL'] : "";
    role = json.toString().contains("role") ? json['role'] : "";
    if (type == "document") {
      log("hiiyaa");
      Timestamp timestampDate =
          json.toString().contains("dateAdded") ? json['dateAdded'] : "";
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestampDate.millisecondsSinceEpoch);
      dateAdded = dateTime.day.toString() +
          "/" +
          dateTime.month.toString() +
          "/" +
          dateTime.year.toString();
    } else {
      dateAdded =
          json.toString().contains("dateAdded") ? json['dateAdded'] : "";
      log("hii");
    }
    location = json.toString().contains("location") ? json['location'] : "";

    isVerified =
        json.toString().contains("isVerified") ? json['isVerified'] : "";
    isGoogleUser =
        json.toString().contains("isGoogleUser") ? json['isGoogleUser'] : "";
    isFacebookUser = json.toString().contains("isFacebookUser")
        ? json['isFacebookUser']
        : "";
    phoneNumber =
        json.toString().contains("phoneNumber") ? json['phoneNumber'] : "";

    // }
    //  else {
    //   Map json = json1;
    //   id = json.toString().contains("id") ? json['id'] : "";
    //   fullName = json.toString().contains("fullName") ? json['fullName'] : "";
    //   email = json.toString().contains("email") ? json['email'] : "";
    //   location = json.toString().contains("location") ? json['location'] : "";
    //   photoUrl = json.toString().contains("photoUrl") ? json['photoUrl'] : "";
    //   role = json.toString().contains("role") ? json['role'] : "";

    //   dateAdded =
    //       json.toString().contains("dateAdded") ? json['dateAdded'] : "";

    //   isVerified =
    //       json.toString().contains("isVerified") ? json['isVerified'] : "";
    //   isGoogleUser =
    //       json.toString().contains("isGoogleUser") ? json['isGoogleUser'] : "";
    //   isFacebookUser = json.toString().contains("isFacebookUser")
    //       ? json['isFacebookUser']
    //       : "";
    //   phoneNumber =
    //       json.toString().contains("phoneNumber") ? json['phoneNumber'] : "";
    // }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['location'] = location;
    data['photoURL'] = photoURL;
    data['role'] = role;
    data['dateAdded'] = dateAdded;
    data['isVerified'] = isVerified;
    data['isGoogleUser'] = isGoogleUser;
    data['isFacebookUser'] = isFacebookUser;
    data['phoneNumber'] = phoneNumber;
    return data;
  }

  DocumentReference<Map<String, dynamic>> get record => id != null
      ? FirebaseFirestore.instance.collection(Config.firebaseKeys.users).doc(id)
      : FirebaseFirestore.instance.collection(Config.firebaseKeys.users).doc();
}
