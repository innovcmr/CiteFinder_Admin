import 'package:cloud_firestore/cloud_firestore.dart';

class HomeLocation {
  String? id;
  String? geoCoordinates;
  String? city;
  String? quarter;

  HomeLocation({this.id, this.geoCoordinates, this.city, this.quarter});

  HomeLocation.fromJson(json1, String type) {
    var json = json1;
    // if (type == "document") {
    //   json = json1.data();
    // }
    id = json.toString().contains("id") ? json['id'] : "";
    city = json.toString().contains("city") ? json['city'] : "";
    quarter = json.toString().contains("quarter") ? json['quarter'] : "";
    if (type != "document") {
      geoCoordinates = json.toString().contains("geoCoordinates")
          ? json['geoCoordinates']
          : "";
    } else {
      GeoPoint initialCoordinates = json.toString().contains("geoCoordinates")
          ? json['geoCoordinates']
          : null;
      geoCoordinates = initialCoordinates.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['geoCoordinates'] = geoCoordinates;
    data['city'] = city;
    data['quarter'] = quarter;
    return data;
  }
}
