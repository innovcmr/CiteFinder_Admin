//TODO: Implement Home Provider
// Add here all requests to firebase involving agent Class
import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/landlord_model.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:get/get.dart';

class LandlordProvider extends BasePovider {
  @override
  void onInit() {
    super.onInit();
  }

  Stream<User> currentLandLordStream(String uid) {
    final user = firestore
        .collection(Config.firebaseKeys.users)
        .doc(uid)
        // .where(Config.firebaseKeys.id, isEqualTo: uid)
        // .limit(1)
        // .withConverter(
        //   fromFirestore: (item, _) => Landlord.fromJson(item, "document"),
        //   toFirestore: (Landlord item, _) => item.toJson(),
        // )
        .snapshots()
        // .timeout(Duration(seconds: 20))
        .handleError((error) {
      Get.snackbar("Error in Landlord fetch", error.toString());
    }).map((snapshots) {
      log("user");

      return User.fromJson(snapshots, 'document');
    });
    return user;
  }
}
