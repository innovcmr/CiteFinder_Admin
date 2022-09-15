// ignore_for_file: prefer_const_constructors

import 'package:cite_finder_admin/app/modules/login/controllers/login_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    Get.put(LoginController());
  });

  await GetStorage.init();
  runApp(
    GetMaterialApp(
      navigatorKey: Get.key,
      title: Config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeLight,
      textDirection: TextDirection.ltr,
      // initialRoute: AppPages.INITIAL,
      // we don't really have to put the home page here
      // GetX is going to navigate the user and clear the navigation stack

      getPages: AppPages.routes,
      home: FractionallySizedBox(
          widthFactor: 0.3,
          heightFactor: 0.3,
          child: const CircularProgressIndicator()),
    ),
  );
}
