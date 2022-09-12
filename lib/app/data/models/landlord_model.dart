import 'package:cite_finder_admin/app/data/models/user_model.dart';

class Landlord extends User {
  Landlord.fromJson(json, String type) {
    User.fromJson(json, type);
  }
}
