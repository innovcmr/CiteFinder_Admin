import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/modules/home/views/home_view.dart';
import 'package:cite_finder_admin/app/utils/formKeys.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final count = 0.obs;
  final _userProvider = UserProvider();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = LoginFormKey();

  final autoValidate = false.obs;
  @override
  void onInit() {
    super.onInit();
    _userProvider.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void login() async {
    if (!loginFormKey.currentState!.validate()) {
      autoValidate(true);
      return;
    } else {
      autoValidate(false);
      runAsyncFunction(() async {
        bool successful = false;
        try {
          successful = await _userProvider.signInUser(
              email: emailController.text.trim(),
              password: passwordController.text);
          if (successful) {
            // Get.offAll(() => HomeView());
          }
        } catch (e) {}
      });
    }
  }
}
