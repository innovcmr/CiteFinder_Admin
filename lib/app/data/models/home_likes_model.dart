class HomeLikes {
  String? id;
  String? home;
  int? likes;
  int? dislikes;
  List<String>? likers;
  List<String>? dislikers;

  HomeLikes(
      {this.id,
      this.home,
      this.likes,
      this.dislikes,
      this.likers,
      this.dislikers});

  HomeLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    home = json['home'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    likers = json['likers'].cast<String>();
    dislikers = json['dislikers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['home'] = home;
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    data['likers'] = likers;
    data['dislikers'] = dislikers;
    return data;
  }
}
