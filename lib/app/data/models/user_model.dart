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
  DateTime? createdDate;
  bool isDeleted = false;

  User({
    this.id,
    this.fullName,
    this.email,
    this.location,
    this.photoUrl,
    this.role,
    this.dateAdded,
    this.isVerified,
    this.isGoogleUser,
    this.isFacebookUser,
    this.phoneNumber,
    this.createdDate,
    this.isDeleted = false,
  });

  User.fromJson(json1, [String type = "map"]) {
    var json = json1;
    print(json1);
    if (type == "document") {
      json = json1.data();
    }
    id = json.toString().contains("id") ? json['id'] : "";
    fullName = json.toString().contains("fullName") ? json['fullName'] : "";
    email = json.toString().contains("email") ? json['email'] : "";
    location = json.toString().contains("location") ? json['location'] : "";
    photoUrl = json.toString().contains("photoURL") ? json['photoURL'] : "";
    role = json.toString().contains("role") ? json['role'] : "";

    if (type == "document") {
      Timestamp timestampDate =
          json.toString().contains("dateAdded") ? json['dateAdded'] : "";
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestampDate.millisecondsSinceEpoch);

      dateAdded = dateTime.day.toString() +
          "/" +
          dateTime.month.toString() +
          "/" +
          dateTime.year.toString();

      createdDate = json["dateAdded"].toDate();
    } else {
      dateAdded = json.toString().contains("dateAdded")
          ? json['dateAdded'].toString()
          : "";

      createdDate = DateTime.parse(json["createdDate"]);
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

    isDeleted = json["isDeleted"] ?? false;
  }

  Map<String, dynamic> toJson([bool toFirestore = false]) {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['location'] = location;
    data['photoUrl'] = photoUrl;
    data['role'] = role;
    data['dateAdded'] = dateAdded;
    data["createdDate"] = toFirestore ? createdDate : createdDate!.toString();
    data['isVerified'] = isVerified;
    data['isGoogleUser'] = isGoogleUser;
    data['isFacebookUser'] = isFacebookUser;
    data['phoneNumber'] = phoneNumber;
    data["isDeleted"] = isDeleted;
    return data;
  }
}
