import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/formKeys.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:cite_finder_admin/app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final _loginFormKey = LoginFormKey();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Config.assets.loginBg),
                  opacity: 0.6,
                  fit: BoxFit.fill),
            ),
            child: Container(
              padding: const EdgeInsets.all(50.0),
              child: Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(children: [
                    Image.asset(
                      Config.assets.logo,
                      scale: 1,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Welcome Admin",
                      style: Get.textTheme.headline2!
                          .copyWith(color: AppTheme.colors.mainPurpleColor),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Obx(
                      () => Form(
                        key: _loginFormKey,
                        autovalidateMode: controller.autoValidate.value
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email",
                                isDense: true,
                                prefixIcon: Icon(Icons.person,
                                    color: AppTheme.colors.mainPurpleColor),
                              ),
                              style: Get.textTheme.headline5,
                              controller: controller.emailController,
                              validator: Validator.email,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              style: Get.textTheme.headline5,
                              controller: controller.passwordController,
                              validator: Validator.password,
                              decoration: InputDecoration(
                                labelText: "Password",
                                // add padding to adjust text
                                isDense: true,
                                prefixIcon: Icon(Icons.lock,
                                    color: AppTheme.colors.mainPurpleColor),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.login(_loginFormKey);
                              },
                              child: const Text("Login"),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
