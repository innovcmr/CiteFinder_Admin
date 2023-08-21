import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/config.dart';

class HomeRoom {
  String? id;
  String? home;
  DocumentReference<Map<String, dynamic>>? homeRef;
  String? type;
  List<String>? images;
  int? numberAvailable;
  String? description;
  double? price;

  HomeRoom(
      {this.id,
      this.home,
      this.type,
      this.images,
      this.numberAvailable,
      this.description,
      this.homeRef,
      this.price});

  HomeRoom.fromJson(Map<String, dynamic> json) {
    final price =
        double.parse(json[Config.firebaseKeys.price]?.toString() ?? "0");

    id = json['id'];
    home = json['home'].toString();
    homeRef = json['home'];
    type = json['type'];
    images = json['images'].cast<String>();
    numberAvailable = int.tryParse(
        json[Config.firebaseKeys.numberAvailable]?.toString() ?? "");
    description = json['description'];
    this.price = price;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['home'] = homeRef;
    data['type'] = type;
    data['images'] = images;
    data['numberAvailable'] = numberAvailable;
    data['description'] = description;
    data['price'] = price;
    return data;
  }

  static Future<HomeRoom> getFromFirestore(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final DocumentSnapshot<Map<String, dynamic>> roomData;

    roomData = (await firestore
        .collection(Config.firebaseKeys.homeRooms)
        .doc(uid)
        .get());

    if (roomData.data() != null) {
      return HomeRoom.fromJson(roomData.data()!);
    }
    throw Exception("Could not get room data");
  }
}
