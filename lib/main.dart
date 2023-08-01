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
      // initialRoute: AppPages.INITIAL,
      routerDelegate: Get.rootDelegate,
      getPages: AppPages.routes,
    ),
  );
}
