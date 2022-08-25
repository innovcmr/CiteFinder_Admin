import 'package:cite_finder_admin/app/data/models/admin_model.dart';
import 'package:cite_finder_admin/app/data/models/landlord_model.dart';
import 'package:cite_finder_admin/app/data/models/location_model.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';

class Home {
  String? id;
  String? name;
  String? description;
  String? type;
  String? shortVideo;
  double? rating;
  Location? location;
  List<String>? facilities;
  String? waterAvailability;
  String? electricityAvailability;
  String? security;
  String? mainImage;
  List<String>? images;
  String? dateAdded;
  Landlord? landlord;

  Home(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.shortVideo,
      this.rating,
      this.location,
      this.facilities,
      this.waterAvailability,
      this.electricityAvailability,
      this.security,
      this.mainImage,
      this.images,
      this.dateAdded,
      this.landlord});

  Home.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    shortVideo = json['shortVideo'];
    rating = json['rating'];
    location =
        json['location'] != null ? Location?.fromJson(json['location']) : null;
    facilities = json['facilities'].cast<String>();
    waterAvailability = json['waterAvailability'];
    electricityAvailability = json['electricityAvailability'];
    security = json['security'];
    mainImage = json['mainImage'];
    images = json['images'].cast<String>();
    dateAdded = json['dateAdded'];
    landlord =
        json['landlord'] != null ? Landlord?.fromJson(json['landlord']) : null;
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
    data['waterAvailability'] = waterAvailability;
    data['electricityAvailability'] = electricityAvailability;
    data['security'] = security;
    data['mainImage'] = mainImage;
    data['images'] = images;
    data['dateAdded'] = dateAdded;
    if (landlord != null) {
      data['landlord'] = landlord?.toJson();
    }
    return data;
  }
}
