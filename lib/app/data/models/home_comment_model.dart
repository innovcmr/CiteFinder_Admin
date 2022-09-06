class HomeComment {
  String? id;
  String? home;
  String? text;
  String? user;
  String? replyingTo;

  HomeComment({this.id, this.home, this.text, this.user, this.replyingTo});

  HomeComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    home = json['home'];
    text = json['text'];
    user = json['user'];
    replyingTo = json['replyingTo'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['home'] = home;
    data['text'] = text;
    data['user'] = user;
    data['replyingTo'] = replyingTo;
    return data;
  }
}
