//TODO: Implement Home Provider
// Add here all requests to firebase involving agent Class
import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/user_model.dart' as userModel;
import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/enumeration.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginProvider extends BasePovider {
  @override
  void onInit() {
    super.onInit();
  }

  void logOut() async {
    Get.showLoader();
    try {
      await auth.signOut().timeout(const Duration(seconds: 25));
      Get.closeLoader();
    } on FirebaseAuthException catch (error) {
      Get.snackbar("Error in Logout", error.toString());
      log("Error in logout  ${error.toString()}");
      Get.closeLoader();
    } finally {
      Get.closeLoader();
    }
  }

  Future<bool> logInAsAdmin(
      {required String email, required String password}) async {
    log(email);
    log(password);
    try {
      final admin = (await firestore
              .collection(Config.firebaseKeys.users)
              .where(Config.firebaseKeys.email, isEqualTo: email)
              .limit(1)
              .withConverter(
                fromFirestore: (item, _) =>
                    userModel.User.fromJson(item, "document"),
                toFirestore: (userModel.User item, _) => item.toJson(),
              )
              .get()
              .timeout(const Duration(seconds: 25)))
          .docs;
      userModel.User trialUser = admin.first.data();
      if (admin.isEmpty ||
          trialUser.role == null ||
          trialUser.role!.toLowerCase() != userRole.admin.toStr()) {
        Get.snackbar("Error", "Error User not an Admin");
        throw "Error User not an Admin";
      }
      final userCredential = await auth
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .timeout(const Duration(seconds: 25));
      final user = userCredential.user;
      print(user?.uid);
      // box.write(Config.keys.user, user);
      Get.closeLoader();
      return true;
    } on FirebaseAuthException catch (e) {
      print("error in signin is ${e.message}");
      Get.closeLoader();
      Get.snackbar("Error", e.message ?? "Error in SignIn. Check credentials");
      return false;
      // rethrow;
    } finally {
      Get.closeLoader();
    }
  }
}
