import 'package:cite_finder_admin/app/data/models/user_model.dart';

class Tenant extends User {
  Tenant.fromJson(Map<String, dynamic> json) {
    User.fromJson(json);
  }
}
