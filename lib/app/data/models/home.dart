import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../utils/config.dart';
import 'location.dart';
import 'ownerInfo.dart';

enum Availability { NONE, LOW, MEDIUM, HIGH, ALWAYS }

class Home {
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

  int floors;
  int rooms;
  int minimumPeriodCount;
  HomeLocation? location;
  List<String>? facilities;
  List<String>? images;
  String? paymentPeriod;
  double? basePrice;
  bool isApproved = false;
  DocumentReference<Map<String, dynamic>>? agent;

  OwnerInfo? ownerInfo;

  Home(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.mainImage,
      this.shortVideo,
      this.rating,
      this.landlord,
      this.dateAdded,
      this.dateModified,
      this.waterAvailability,
      this.electricityAvailability,
      this.floors = 0,
      this.rooms = 0,
      this.minimumPeriodCount = 1,
      this.paymentPeriod = 'Yearly',
      this.security,
      this.location,
      this.facilities,
      this.basePrice,
      this.images,
      this.isApproved = false,
      this.agent,
      this.ownerInfo});

  factory Home.fromMap(Map<String, dynamic> map) {
    return Home(
        id: map[Config.firebaseKeys.id],
        name: map[Config.firebaseKeys.name],
        type: map[Config.firebaseKeys.type],
        description: map[Config.firebaseKeys.description],
        mainImage: map[Config.firebaseKeys.mainImage],
        shortVideo: map[Config.firebaseKeys.shortVideo],
        rating:
            double.tryParse(map[Config.firebaseKeys.rating]?.toString() ?? ""),
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
            ? HomeLocation.fromMap(map[Config.firebaseKeys.location])
            : null,
        landlord: map[Config.firebaseKeys.landlord],
        basePrice: map[Config.firebaseKeys.basePrice]?.toDouble(),
        isApproved: map[Config.firebaseKeys.isApproved] ?? false,
        floors: map[Config.firebaseKeys.floors] ?? 0,
        rooms: map[Config.firebaseKeys.rooms] ?? 0,
        minimumPeriodCount: map[Config.firebaseKeys.minimumPeriodCount] ?? 1,
        paymentPeriod: map[Config.firebaseKeys.paymentPeriod],
        agent: map[Config.firebaseKeys.agent],
        ownerInfo: map[Config.firebaseKeys.ownerInfo] != null
            ? OwnerInfo.fromJson(map[Config.firebaseKeys.ownerInfo])
            : null);
  }

  double? get priceWithCharge =>
      basePrice != null ? basePrice! + (0.07 * basePrice!) : null;

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
      Config.firebaseKeys.minimumPeriodCount: minimumPeriodCount,
      Config.firebaseKeys.security: security,
      Config.firebaseKeys.location: location,
      Config.firebaseKeys.landlord: landlord,
      Config.firebaseKeys.facilities: facilities,
      Config.firebaseKeys.images: images,
      Config.firebaseKeys.basePrice: basePrice,
      Config.firebaseKeys.isApproved: isApproved,
      Config.firebaseKeys.agent: agent,
      Config.firebaseKeys.floors: floors,
      Config.firebaseKeys.rooms: rooms,
      Config.firebaseKeys.ownerInfo:
          ownerInfo != null ? ownerInfo!.toJson() : null
    };
  }

  @override
  toString() {
    return toMap().toString();
  }

  DocumentReference<Map<String, dynamic>> get record => id != null
      ? FirebaseFirestore.instance.collection(Config.firebaseKeys.homes).doc(id)
      : FirebaseFirestore.instance.collection(Config.firebaseKeys.homes).doc();

  static Future<Home> getHomeFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final homeData =
        (await firestore.collection(Config.firebaseKeys.homes).doc(uid).get())
            .data();

    if (homeData != null) {
      return Home.fromMap(homeData);
    }
    throw Exception("couldNotGetHomeData".tr);
  }

  static Future<Home?> updateHome(
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

    if (updatedData != null) {
      return Home.fromMap(updatedData);
    } else {
      return null;
    }
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
