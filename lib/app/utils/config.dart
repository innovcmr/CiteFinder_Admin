class Config {
  // Here, input any variables deemed necessary. This file should be made global to avoid import everytime before usage i.e
  // Uncomment lines below and customize if needed
  // static final apiUrl = "http://192.168.43.49:5000/";
  static final keys = _Keys();
  static final assets = _Assets();
  static final appName = "Cite Finder Admin";
  // static final countryCode = "+237";
  // static final appKeyAndroid = "j8V634F9f0x8DGkqj4HkT6bELJWd0mBt";
}

class _Keys {
  // Here, all getStorage keys will be stored. preferrable to make two atrributes andvalues the same (in nomenclature) i.e.
  // final token = "token";
  // final user = "user";
  // uncomment if needed
  final fisrtOpen = 'firstOpen';
  final userIsLogIn = "userIsLogIn";
  final user = "user";
}

class _Assets {
  // here, input all assets to be used and links to them i.e
  // final logo = "assets/images/logo.png";
  // final english = "assets/images/english.svg";
  // final french = "assets/images/french.svg";
  final loginBg = "assets/images/loginBg.jpeg";
}
