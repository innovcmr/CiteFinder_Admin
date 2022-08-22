import 'package:cite_finder_admin/app/data/providers/baseProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
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
}
