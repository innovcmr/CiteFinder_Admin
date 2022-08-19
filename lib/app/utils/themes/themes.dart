import 'package:flutter/material.dart';

class AppTheme {
  // Here, input themedata for the application. i.e.
  // uncomment these lines below and customize as required
  static final colors = _Colors();
  static final sizes = _Size();
  static final themeLight = ThemeData(
    primaryColor: colors.mainPurpleColor,
    backgroundColor: Colors.white,
    focusColor: colors.mainPurpleColor,
    fontFamily: "LatoRegular",
    textTheme: const TextTheme(
        headline5: TextStyle(fontFamily: "LatoRegular", fontSize: 12),
        headline6: TextStyle(fontFamily: "LatoBold", fontSize: 14)),
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
}

class _Size {
  // here, Input all sizes to be used in project be it font sizes or image i.e.
  // final xs = 10.0;
  // final large = 50.0;
}
