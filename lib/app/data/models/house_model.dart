import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/admin_model.dart';
import 'package:cite_finder_admin/app/data/models/landlord_model.dart';
import 'package:cite_finder_admin/app/data/models/location_model.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class House {
  String? id;
  String? name;
  String? description;
  String? type;
  String? shortVideo;
  double? rating;
  HomeLocation? location;
  List<String>? facilities;
  String? mainImage;
  List<String>? images;
  String? dateAdded;
  String? dateModified;
  DocumentReference<Map<String, dynamic>>? landlord;
  bool? isApproved;
  double? basePrice;

  House(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.shortVideo,
      this.rating,
      this.location,
      this.facilities,
      this.mainImage,
      this.images,
      this.dateAdded,
      this.dateModified,
      this.landlord,
      this.basePrice,
      this.isApproved});

  House.fromJson(json1, String type1) {
    var json = json1;
    if (type1 == "document") {
      json = json1.data();
    }
    id = json.toString().contains("id") ? json['id'] : "";
    name = json.toString().contains("name") ? json['name'] : "";
    description =
        json.toString().contains("description") ? json['description'] : "";
    type = json.toString().contains("type") ? json['type'] : "";

    // changed short video to empty string for testing. change it later on by uncommenting code below
    // shortVideo =
    //     json.toString().contains("shortVideo") ? json['shortVideo'] : "";
    shortVideo = "";
    //
    rating = json.toString().contains("rating") ? json['rating'] : null;
    location = json.toString().contains("location")
        ? HomeLocation?.fromJson(json['location'], type1)
        : null;
    facilities = json.toString().contains("facilities")
        ? json['facilities'].cast<String>()
        : "";
    mainImage = json.toString().contains("mainimage") ? json['mainImage'] : "";
    images =
        json.toString().contains("images") ? json['images'].cast<String>() : "";
    if (type1 == "document") {
      // conversion of dateAdded below
      Timestamp timestamp =
          json.toString().contains("dateAdded") ? json['dateAdded'] : "";
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
      dateAdded = dateTime.day.toString() +
          "/" +
          dateTime.month.toString() +
          "/" +
          dateTime.year.toString();
      // conversion of dateModified below
      timestamp =
          json.toString().contains("dateModified") ? json['dateModified'] : "";
      dateTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
      dateModified = dateTime.day.toString() +
          "/" +
          dateTime.month.toString() +
          "/" +
          dateTime.year.toString();
    } else {
      dateAdded =
          json.toString().contains("dateAdded") ? json['dateAdded'] : "";
      dateModified =
          json.toString().contains("dateModified") ? json['dateModified'] : "";
    }
    // landlord = json['landlord'] != null
    //     ? Landlord?.fromJson(json['landlord'], type)
    //     : null;
    // if (type )
    basePrice =
        json.toString().contains("basePrice") ? json['basePrice'] : null;
    isApproved =
        json.toString().contains("isApproved") ? json['isApproved'] : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    data['shortVideo'] = shortVideo;
    data['rating'] = rating;
    if (location != null) {
      data['location'] = location?.toJson();
    }
    data['facilities'] = facilities;
    data['mainImage'] = mainImage;
    data['images'] = images;
    data['dateAdded'] = dateAdded;
    data['dateModified'] = dateModified;
    // if (landlord != null) {
    //   data['landlord'] = landlord?.toJson();
    // }
    data['basePrice'] = basePrice;
    data['isApproved'] = isApproved;
    return data;
  }

  DocumentReference<Map<String, dynamic>> get record => id != null
      ? FirebaseFirestore.instance.collection(Config.firebaseKeys.homes).doc(id)
      : FirebaseFirestore.instance.collection(Config.firebaseKeys.homes).doc();
}
