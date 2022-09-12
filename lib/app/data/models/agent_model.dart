import 'package:cite_finder_admin/app/data/models/user_model.dart';

class Agent extends User {
  String? jurisdiction;

  Agent({this.jurisdiction});

  Agent.fromJson(json, String type) {
    User.fromJson(json, type);
    jurisdiction = json['jurisdiction'];
  }

  @override
  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data = super.toJson();
    data['jurisdiction'] = jurisdiction;
    return data;
  }
}
