//TODO: Implement Home Provider
// Add here all requests to firebase involving home Class
import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HouseProvider extends BasePovider {
  @override
  void onInit() {
    super.onInit();
  }

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

// read user operation
  Stream<List<House>> moduleStream(dynamic startAfter,
      {limit = 25, dummy = 0}) {
    return firestore
        .collection(Config.firebaseKeys.homes)
        .orderBy("dateAdded")
        .startAfter([startAfter])
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot query) {
          List<House> homes = [];
          for (var home in query.docs) {
            final homeModel = House.fromJson(home, "document");
            homes.add(homeModel);
          }
          log("home Fetch  ${homes.map((element) => element.toJson()).toString()}");
          log("home count is ${homes.length}");

          return homes;
        })
        // .timeout(const Duration(seconds: 30))
        .handleError((error) {
          Get.snackbar("Error in home Fetch", error.toString());
          log("Error in home Fetch  ${error.toString()}");
        });
  }

  // update home operation
  update(House newhome) async {
    await firestore
        .collection(Config.firebaseKeys.homes)
        .doc(newhome.id)
        .update(newhome.toJson())
        .timeout(const Duration(seconds: 20))
        .then((val) {
      Get.snackbar("Success", "home Update successful");
      log("home update Succesful}");
    }).catchError((error) {
      Get.snackbar("Error in home Update", error.toString());
      log("Error in home Update  ${error.toString()}");
    });
  }

  approve(id) async {
    await firestore
        .collection(Config.firebaseKeys.homes)
        .doc(id)
        .update({Config.firebaseKeys.isApproved: true})
        .timeout(const Duration(seconds: 20))
        .then((val) {
          Get.snackbar("Success", "Home Approval successful");
          log("Home Approval Succesful}");
        })
        .catchError((error) {
          Get.snackbar("Error in home Approval", error.toString());
          log("Error in home Approval  ${error.toString()}");
        });
  }

  Future<bool> setAgent(DocumentReference<Map<String, dynamic>> homeRef,
      DocumentReference<Map<String, dynamic>> agentRef) async {
    try {
      await homeRef.update({Config.firebaseKeys.agent: agentRef});
      Fluttertoast.showToast(msg: "House agent updated successfully");
      return true;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      return false;
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
