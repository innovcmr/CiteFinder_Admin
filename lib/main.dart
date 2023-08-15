import 'dart:developer';

import 'package:cite_finder_admin/app/controllers/auth_controller.dart';
import 'package:cite_finder_admin/app/data/initial_bindings.dart';
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
  ).timeout(const Duration(seconds: 15));
  await GetStorage.init();
  runApp(
    GetMaterialApp.router(
      title: Config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeLight,
      initialBinding: InitialBindings(),
      routerDelegate: Get.rootDelegate,
      getPages: AppPages.routes,
    ),
  );
}
