import 'package:cite_finder_admin/app/data/models/kyc_model.dart';
import 'package:cite_finder_admin/app/data/models/landlord_model.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart' as UserModel;
import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/routes/app_pages.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/enumeration.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:developer';

class UserProvider extends BasePovider {
  @override
  void onInit() {
    super.onInit();
  }

// create User Operation
  Future<bool> add({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? phoneNumber,
  }) async {
    //create firebase user
    try {
      final userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCred.user != null) {
        // final userType = SplashController.to.initialUserType;

        //create firestore document for user

        final newDoc = firestore
            .collection(Config.firebaseKeys.users)
            .doc(userCred.user!.uid);
        final userMap = {
          Config.firebaseKeys.id: userCred.user!.uid,
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
        if (phoneNumber!.isNotEmpty || phoneNumber != null) {
          userMap.addEntries(
              {Config.firebaseKeys.phoneNumber: phoneNumber}.entries);
        }
        await newDoc.set(
          userMap,
        );

        await userCred.user!.sendEmailVerification();
        Get.back();
        log("User successfully created.");
        Get.closeLoader();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      Get.closeLoader();
      log("Error in User Creation ${e.message}");
      Get.snackbar("Error in user Creation", e.message ?? "");
      return false;
    } finally {}
  }

// read user operation
  Stream<List<UserModel.User>> moduleStream() {
    return firestore
        .collection(Config.firebaseKeys.users)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel.User> users = [];
      for (var user in query.docs) {
        final userModel = UserModel.User.fromJson(user, "document");
        users.add(userModel);
      }
      log("User Fetch  ${users.map((element) => element.toJson()).toString()}");
      log("user count is ${users.length}");

      return users;
    })
        // .timeout(const Duration(seconds: 30))
        .handleError((error) {
      Get.snackbar("Error in User Fetch", error.toString());
      log("Error in User Fetch  ${error.toString()}");
    });
  }

  // update user operation
  update(UserModel.User newUser) async {
    await firestore
        .collection(Config.firebaseKeys.users)
        .doc(newUser.id)
        .update(newUser.toJson())
        .timeout(const Duration(seconds: 20))
        .then((val) {
      Get.snackbar("Success", "User Update successful");
      log("User update Succesful}");
    }).catchError((error) {
      Get.snackbar("Error in User Update", error.toString());
      log("Error in User Update  ${error.toString()}");
    });
  }

  // delete user operation
  delete(String userId) async {
    try {
      await firestore
          .collection(Config.firebaseKeys.users)
          .doc(userId)
          .delete()
          .timeout(const Duration(seconds: 20));

      Get.snackbar("Success", "User delete successful");
      log("User delete Succesful}");
    } catch (e) {
      Get.snackbar("Error in Deletion", e.toString());
      log("Error in User Deletion  ${e.toString()}");
    }
  }

  // get KYC requests
  Future<List<KYC>> getPendingKycRequests() {
    return firestore
        .collection(Config.firebaseKeys.kyc)
        .where(Config.firebaseKeys.status, isEqualTo: KYCStatus.pending.toStr())
        .get()
        .then((querySnapshot) {
          List<KYC> items = [];
          for (var item in querySnapshot.docs) {
            items.add(KYC.fromJson(item.data()));
            //   log("KYC count is ${items.length}");
          }
          log("KYC Fetch  ${items.map((element) => element.toJson()).toString()}");
          return items;
        })
        .timeout(const Duration(seconds: 30))
        .catchError((error) {
          Get.snackbar("Error in KYC Fetch", error.toString());
          log("Error in KYC Fetch  ${error.toString()}");
        });
  }

  Future<void> approveUserKYC(
      {required String kycUid, required String userUid}) async {
    try {
      await firestore.collection(Config.firebaseKeys.kyc).doc(kycUid).update({
        Config.firebaseKeys.status: KYCStatus.approved.toStr()
      }).timeout(const Duration(seconds: 20));

      // await firestore
      //     .collection(Config.firebaseKeys.users)
      //     .doc(userUid)
      //     .update({Config.firebaseKeys.isVerified: true}).timeout(
      //         const Duration(seconds: 20));
      Get.back();
      Get.back();
      Get.snackbar("Success", "User Approval successful");
      log("Home Approval Succesful}");
    } catch (error) {
      Get.back();
      Get.snackbar("Error in home Approval", error.toString());
      log("Error in home Approval  ${error.toString()}");
    } finally {
      Get.closeLoader();
    }
  }

  // Stream<Landlord> currentLandlordStream(uid) {
  //   final user = firestore
  //       .collection(Config.firebaseKeys.users)
  //       .where(Config.firebaseKeys.id,
  //           // isEqualTo:
  //           // currentHome.value!.landlord!.id)
  //           isEqualTo: uid)
  //       .limit(1)
  //       .snapshots()
  //       .map((snapshots) => Landlord.fromJson(snapshots.docs.first.data(), ''));

  //   return user;
  // }

  // Future<UserModel.User> getUser(uid) {
  //   return firestore
  //       .collection(Config.firebaseKeys.users)
  //       .doc(
  //         Config.firebaseKeys.id,
  //       )
  //       .get()
  //       .then((result) {
  //     return UserModel.User.fromJson(result, "document");
  //   }).catchError((error) {
  //     Get.snackbar("Error in KYCUser Fetch", error.toString());
  //     log("Error in KYCUser Fetch  ${error.toString()}");
  //   });
  // }
}
