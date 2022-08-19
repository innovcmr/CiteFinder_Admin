import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: Config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeLight,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
