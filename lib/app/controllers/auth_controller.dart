import 'dart:developer';

import 'package:cite_finder_admin/app/modules/chats/controllers/chats_controller.dart';
import 'package:cite_finder_admin/app/routes/app_pages.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../data/models/user.dart';
import '../data/models/user_model.dart' as u;
import '../utils/new_utils.dart';

class AuthController extends GetxService {
  static AuthController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    appLauncRoutine();
  }

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Rx<u.User?> currentUser = Rx(null);

  Rx<AppUser?> supportUser = Rx(null);

  Future<void> appLauncRoutine() async {
    auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        Get.rootDelegate.offNamed(Routes.LOGIN);
        return;
      }

      // fetch database user
      final userCollection = firestore.collection(Config.firebaseKeys.users);

      final userData = (await userCollection.doc(firebaseUser.uid).get());

      final u.User user = u.User.fromJson(userData, "document");

      if (user.role != "admin") {
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(
            msg: "You are not a Find-Home admin", webBgColor: "#ff0000");
        Get.rootDelegate.offNamed(Routes.LOGIN);
        return;
      }

      currentUser.value = user;

      supportUser.value = await getSupportAccountUser();

      final route = Get.rootDelegate.currentConfiguration!.currentPage?.name;

      if (route == Routes.CHATS) {
        Get.rootDelegate.offNamed(Routes.CHATS);
        return;
      }
      if (route != Routes.HOME) {
        Get.rootDelegate.offNamed(Routes.HOME);
      }
    });
  }

  Future<AppUser> getSupportAccountUser() async {
    final collection =
        FirebaseFirestore.instance.collection(Config.firebaseKeys.users);

    final stream =
        queryCollection(collection, singleRecord: true, queryBuilder: (users) {
      return users.where(Config.firebaseKeys.email,
          isEqualTo: "contact@innovcmr.com");
    }, objectBuilder: (map) {
      return AppUser.fromMap(map);
    });

    final res = await stream.first;

    return res[0];
  }

  Future<void> signoutUser() async {
    final res = await Get.defaultDialog<bool>(
        title: "Sign out",
        middleText: "Are you sure you want to sign out?",
        onConfirm: () {
          Get.back(result: true);
        },
        onCancel: () {
          Get.back(result: false);
        });

    if (res != true) return;

    Get.showLoader();
    FirebaseAuth.instance.signOut().then((_) {
      Get.rootDelegate.offNamed(Routes.LOGIN);

      currentUser.value = null;
    });
  }
}
