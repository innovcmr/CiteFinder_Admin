import 'package:cite_finder_admin/app/data/models/user_model.dart' as UserModel;
import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:developer';

class UserProvider extends BasePovider {
  @override
  void onInit() {
    super.onInit();
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        //   box.write(Config.keys.user, user);
        //   box.write(Config.keys.userIsLogIn, true);
        // } else {
        //   box.remove(Config.keys.user);
        //   box.write(Config.keys.userIsLogIn, false);
      }
    });
  }

  Future<bool> signInUser(
      {required String email, required String password}) async {
    log(email);
    log(password);
    try {
      final userCredential = await auth
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .timeout(const Duration(seconds: 15));
      final user = userCredential.user;
      print(user?.uid);
      // box.write(Config.keys.user, user);
      return true;
    } on FirebaseAuthException catch (e) {
      print("error in signin is ${e.message}");
      Get.closeLoader();
      Get.snackbar("Error", e.message ?? "Error in signIn. Check credentials");
      return false;
      // rethrow;
    }
  }

// create User Operation
  add(UserModel.User user) async {
    await firestore
        .collection("users")
        .add(user.toJson())
        .timeout(const Duration(seconds: 20))
        .then((val) {
      Get.snackbar("Success", "User Update successful");
      log("User update Succesful}");
    }).catchError((error) {
      Get.snackbar("Error in User Creation", error.toString());
      log("Error in User Creation  ${error.toString()}");
    });
  }

// read user operation
  Stream<List<UserModel.User>> moduleStream() {
    return firestore.collection("users").snapshots().map((QuerySnapshot query) {
      List<UserModel.User> users = [];
      for (var user in query.docs) {
        final userModel = UserModel.User.fromJson(user);
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
        .collection("users")
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
        .collection("users")
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
