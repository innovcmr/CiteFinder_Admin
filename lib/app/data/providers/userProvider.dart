import 'package:cite_finder_admin/app/data/models/user_model.dart' as UserModel;
import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:developer';

class UserProvider extends BasePovider {
  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> signInUser(
      {required String email, required String password}) async {
    try {
      final userCredential = await auth
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .timeout(const Duration(seconds: 15));
      final user = userCredential.user;

      // box.write(Config.keys.user, user);
      return true;
    } on FirebaseException catch (e) {
      // print("error in signin is ${e.message}");
      Fluttertoast.showToast(
          timeInSecForIosWeb: 4,
          msg: e.message ?? "Error in signIn. Check credentials",
          webBgColor: "#ff0000");
      return false;
      // rethrow;
    }
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
  Stream<List<UserModel.User>> moduleStream(
    dynamic startAfter, {
    limit = 25,
    dummy = 0,
  }) {
    return firestore
        .collection(Config.firebaseKeys.users)
        .orderBy("dateAdded")
        .startAfter([startAfter])
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot query) {
          List<UserModel.User> users = [];
          for (var user in query.docs) {
            final userModel = UserModel.User.fromJson(user, "document");
            users.add(userModel);
          }

          return users;
        })
        // .timeout(const Duration(seconds: 30))
        .handleError((error) {
          Get.snackbar("Error in User Fetch", error.toString());
          print(error);
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
    await firestore
        .collection(Config.firebaseKeys.users)
        .doc(userId)
        .delete()
        .timeout(const Duration(seconds: 20))
        .then((val) {
      Get.snackbar("Success", "User delete successful");
      log("User delete Succesful}");
    }).catchError((error) {
      Get.snackbar("Error in Deletion", error.toString());
      log("Error in User Deletion  ${error.toString()}");
    });
  }
}
