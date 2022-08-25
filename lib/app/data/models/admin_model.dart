import 'package:cite_finder_admin/app/data/models/agent_model.dart';

class Admin extends Agent {
  Admin.fromJson(Map<String, dynamic> json) {
    Agent.fromJson(json);
  }
}
