import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? fullName;
  String? email;
  String? location;
  String? photoUrl;
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
      this.photoUrl,
      this.role,
      this.dateAdded,
      this.isVerified,
      this.isGoogleUser,
      this.isFacebookUser,
      this.phoneNumber});

  User.fromJson(json1, String type) {
    if (type == "document") {
      var json = json1;
      id = json.data().toString().contains("id") ? json['id'] : "";
      fullName =
          json.data().toString().contains("fullName") ? json['fullName'] : "";
      email = json.data().toString().contains("email") ? json['email'] : "";
      location =
          json.data().toString().contains("location") ? json['location'] : "";
      photoUrl =
          json.data().toString().contains("photoUrl") ? json['photoUrl'] : "";
      role = json.data().toString().contains("role") ? json['role'] : "";
      Timestamp timestampDate =
          json.data().toString().contains("dateAdded") ? json['dateAdded'] : "";
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestampDate.millisecondsSinceEpoch);
      dateAdded = dateTime.day.toString() +
          "/" +
          dateTime.month.toString() +
          "/" +
          dateTime.year.toString();

      isVerified = json.data().toString().contains("isVerified")
          ? json['isVerified']
          : "";
      isGoogleUser = json.data().toString().contains("isGoogleUser")
          ? json['isGoogleUser']
          : "";
      isFacebookUser = json.data().toString().contains("isFacebookUser")
          ? json['isFacebookUser']
          : "";
      phoneNumber = json.data().toString().contains("phoneNumber")
          ? json['phoneNumber']
          : "";
    } else {
      Map json = json1;
      id = json.toString().contains("id") ? json['id'] : "";
      fullName = json.toString().contains("fullName") ? json['fullName'] : "";
      email = json.toString().contains("email") ? json['email'] : "";
      location = json.toString().contains("location") ? json['location'] : "";
      photoUrl = json.toString().contains("photoUrl") ? json['photoUrl'] : "";
      role = json.toString().contains("role") ? json['role'] : "";

      dateAdded =
          json.toString().contains("dateAdded") ? json['dateAdded'] : "";

      isVerified =
          json.toString().contains("isVerified") ? json['isVerified'] : "";
      isGoogleUser =
          json.toString().contains("isGoogleUser") ? json['isGoogleUser'] : "";
      isFacebookUser = json.toString().contains("isFacebookUser")
          ? json['isFacebookUser']
          : "";
      phoneNumber =
          json.toString().contains("phoneNumber") ? json['phoneNumber'] : "";
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['location'] = location;
    data['photoUrl'] = photoUrl;
    data['role'] = role;
    data['dateAdded'] = dateAdded;
    data['isVerified'] = isVerified;
    data['isGoogleUser'] = isGoogleUser;
    data['isFacebookUser'] = isFacebookUser;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
