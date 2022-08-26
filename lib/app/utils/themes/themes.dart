import 'package:flutter/material.dart';

class AppTheme {
  // Here, input themedata for the application. i.e.
  // uncomment these lines below and customize as required
  static final colors = _Colors();
  static final sizes = _Sizes();
  static final themeLight = ThemeData(
    primaryColor: colors.mainPurpleColor,
    backgroundColor: colors.mainGreyBg,
    focusColor: colors.mainPurpleColor,
    fontFamily: "LatoRegular",
    // colorSchemeSeed: colors.mainPurpleColor,
    // primarySwatch: MaterialColor(5, {
    //   1: colors.lightPurpleSidebarColor,
    //   5: colors.mainLightPurpleColor,
    //   9: colors.mainPurpleColor
    // }),
    textTheme: const TextTheme(
      headline2: TextStyle(fontFamily: "LatoBold", fontSize: 20),
      headline4: TextStyle(fontFamily: "LatoRegular", fontSize: 12),
      headline5: TextStyle(fontFamily: "LatoRegular", fontSize: 14),
      button: TextStyle(fontFamily: "LatoRegular", fontSize: 16),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      floatingLabelStyle: TextStyle(color: colors.mainPurpleColor),
      labelStyle: TextStyle(color: colors.inputPlaceholderColor),
      border: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.0, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(10.0)),
      fillColor: colors.greyInputColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          minimumSize: const Size(200, 30),
          primary: colors.mainPurpleColor),
    ),
  );

  // Apply Darktheme here below if needed
  // static final themeDark = ThemeData(
  //   backgroundColor: Colors.white,
  //   fontFamily: "",
  // );
}

class _Colors {
  // Here input all colors to be used in project i.e.
  // final bluecolor = Colors.blueAccent;
  final mainPurpleColor = const Color(0xFF431C69);
  final mainLightPurpleColor = const Color(0xFF8560A8);
  final mainGreyBg = const Color(0xFFE5E5E5);
  final greyInputColor = Color.fromARGB(255, 239, 239, 242);
  final greySidebarTextColor = Color.fromARGB(255, 202, 203, 208);
  final darkerGreyTextColor = Color.fromARGB(255, 167, 168, 172);
  final lightPurpleSidebarColor = const Color(0xFFF5F4F8);
  final inputPlaceholderColor = const Color(0xFFA1A5C1);
}

class _Sizes {
  // here, Input all sizes to be used in project be it font sizes or image i.e.
  // final xs = 10.0;
  // final large = 50.0;
  final xl = 71.0;
}
