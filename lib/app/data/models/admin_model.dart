import 'package:cite_finder_admin/app/data/models/agent_model.dart';

class Admin extends Agent {
  Admin.fromJson(json, String type) {
    Agent.fromJson(json, type);
  }
}
