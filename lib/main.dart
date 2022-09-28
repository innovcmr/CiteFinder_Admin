// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cite_finder_admin/app/modules/login/controllers/login_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

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
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
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
      home: SplashScreen(),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      heightFactor: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Config.assets.logo,
                scale: 1,
              ),
              Text(
                "Find-Home Admin",
                textAlign: TextAlign.center,
                style: Get.textTheme.headline3!.copyWith(
                    color: AppTheme.colors.mainPurpleColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 30),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(height: 60, width: 60, child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
