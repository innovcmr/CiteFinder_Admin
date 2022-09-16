import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/home_room_model.dart';
import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// currentHomeRooms//TODO: Implement Home

class HomeRoomProvider extends BasePovider {
  @override
  void onInit() {
    super.onInit();
  }

  // Future<List<HomeRoom>> getAllHomeRooms(uid) async {
  //   try {
  //     var houseReference =
  //         firestore.collection(Config.firebaseKeys.home).doc(uid);
  //     var query = await firestore
  //         .collection(Config.firebaseKeys.homeRooms)
  //         .where(Config.firebaseKeys.home, isEqualTo: houseReference)
  //         .withConverter<HomeRoom>(
  //           fromFirestore: (item, _) => HomeRoom.fromJson(item.data()!),
  //           toFirestore: (item, _) => item.toJson(),
  //         );
  //     List<HomeRoom> homeRooms = [];
  //     List<QueryDocumentSnapshot<HomeRoom>> homeRoomsSnapshot =
  //         await query.get().then((value) => value.docs);
  //     homeRooms.forEach((element) {
  //       homeRooms.add(element);
  //       log("homeRoom Fetch  ${element.toJson()}");
  //     });

  //     return homeRooms;
  //   } catch (e) {
  //     Get.snackbar("Error in homeRoom Fetch", e.toString());
  //     log("error in homeRoom Fetch, $e");
  //     rethrow;
  //   }
  // }

// create home Operation
  Future<bool> add({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? phoneNumber,
  }) async {
    //create firebase home
    try {
      final homeCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (homeCred.user != null) {
        // final homeType = SplashController.to.initialhomeType;

        //create firestore document for home

        final newDoc = firestore
            .collection(Config.firebaseKeys.homes)
            .doc(homeCred.user!.uid);
        final homeMap = {
          Config.firebaseKeys.id: homeCred.user!.uid,
          Config.firebaseKeys.fullName: fullName,
          Config.firebaseKeys.email: email,
          Config.firebaseKeys.role: role,
          Config.firebaseKeys.dateAdded: DateTime.now(),
          Config.firebaseKeys.isVerified: false,
          Config.firebaseKeys.isGoogleUser: false,
          Config.firebaseKeys.isFacebookUser: false
          // if(phoneNumber.isNotEmpty || phoneNumber != null)

          // Config.firebaseKeys.phoneNumber: phoneNumber,
        };
        // if (phoneNumber!.isNotEmpty || phoneNumber != null) {
        //   userMap.addEntries(
        //       {Config.firebaseKeys.phoneNumber: phoneNumber}.entries);
        // }
        await newDoc.set(
          homeMap,
        );

        await homeCred.user!.sendEmailVerification();
      }
      Get.back();
      log("User successfully Created.");
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error in user Creation", e.message ?? "");
      log("Error in User Creation ${e.message}");
      return false;
    } finally {
      Get.closeLoader();
    }
  }

  // delete home operation
  delete(String homeId) async {
    await firestore
        .collection(Config.firebaseKeys.homes)
        .doc(homeId)
        .delete()
        .timeout(const Duration(seconds: 20))
        .then((val) {
      Get.snackbar("Success", "Home delete successful");
      log("Home delete Succesful}");
    }).catchError((error) {
      Get.snackbar("Error in Deletion", error.toString());
      log("Error in home Deletion  ${error.toString()}");
    });
  }
}
