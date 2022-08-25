import 'package:cite_finder_admin/app/data/models/user_model.dart';

class Agent extends User {
  String? jurisdiction;

  Agent({this.jurisdiction});

  Agent.fromJson(Map<String, dynamic> json) {
    User.fromJson(json);
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
