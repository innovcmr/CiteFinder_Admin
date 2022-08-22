import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/modules/home/views/home_view.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final count = 0.obs;
  final _userProvider = UserProvider();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();

  final autoValidate = false.obs;
  @override
  void onInit() {
    super.onInit();
    _userProvider.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void increment() => count.value++;

  void login() async {
    if (!key.currentState!.validate()) {
      autoValidate(true);
      return;
    } else {
      autoValidate(false);
      Get.showLoader();
      bool successful = false;
      try {
        successful = await _userProvider.signInUser(
            email: emailController.text, password: passwordController.text);
        if (successful) {
          Get.snackbar("Login", "Login Successful");
          print("successful signin");
          Get.offAll(() => HomeView());
        }
        Get.closeLoader();
      } catch (e) {
        Get.closeLoader();
      }
    }
  }
}
