import 'package:cite_finder_admin/app/data/models/user_model.dart';

class Landlord extends User {
  Landlord.fromJson(Map<String, dynamic> json) {
    User.fromJson(json);
  }
}
