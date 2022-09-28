import 'dart:developer';

import 'package:cite_finder_admin/app/data/providers/loginProvider.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/modules/dashboard/views/dashboard_view.dart';
import 'package:cite_finder_admin/app/modules/home/views/home_view.dart';
import 'package:cite_finder_admin/app/modules/login/views/login_view.dart';
import 'package:cite_finder_admin/app/routes/app_pages.dart';
import 'package:cite_finder_admin/app/utils/formKeys.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final count = 0.obs;
  static LoginController instance = Get.find();
  late Rx<User?> firebaseUser;
  final loginProvider = LoginProvider();

  // googleSignInAccount = Rx<GoogleSignInAccount?>(googleSign.currentUser);
  final _userProvider = UserProvider();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final autoValidate = false.obs;
  @override
  void onInit() {
    super.onInit();
    _userProvider.onInit();
    loginProvider.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(loginProvider.auth.currentUser);
    firebaseUser.bindStream(loginProvider.auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      // if the user is not found then the user is navigated to the Register Screen

      Get.offAllNamed(
        Routes.LOGIN,
      );
    } else {
      log(Get.currentRoute.toString());
      // if the user exists and logged in the the user is navigated to the Home Screen
      if (Get.currentRoute == Routes.LOGIN || Get.currentRoute == '/') {
        Get.offAllNamed(
          Routes.DASHBOARD,
          // parameters: {"user": user.displayName!}
        );
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
  }

  clearFields() {
    this.emailController.clear();
    this.passwordController.clear();
  }

  // getFormKey() => _loginFormKey;

  void increment() => count.value++;

  void login(loginFormKey) async {
    if (!loginFormKey.currentState!.validate()) {
      autoValidate(true);
      return;
    } else {
      autoValidate(false);
      Get.showLoader();
      bool successful = false;
      try {
        successful = await loginProvider.logInAsAdmin(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        if (successful) {
          Get.snackbar("Login", "Login Successful");
          print("successful signin");
          clearFields();
        }
        Get.closeLoader();
      } catch (e) {
        Get.snackbar("Error", e.toString());
        Get.closeLoader();
      }
    }
  }
}
