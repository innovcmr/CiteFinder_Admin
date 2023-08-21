import '../../utils/config.dart';

class OwnerInfo {
  String name;
  String email;
  String phoneNumber;

  OwnerInfo(
      {required this.name, required this.phoneNumber, required this.email});

  factory OwnerInfo.fromJson(Map<String, dynamic> json) {
    return OwnerInfo(
        name: json[Config.firebaseKeys.name],
        phoneNumber: json[Config.firebaseKeys.phoneNumber],
        email: json[Config.firebaseKeys.email]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[Config.firebaseKeys.name] = name;
    data[Config.firebaseKeys.phoneNumber] = phoneNumber;
    data[Config.firebaseKeys.email] = email;
    return data;
  }
}
