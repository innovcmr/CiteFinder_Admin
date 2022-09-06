class Favorites {
  String? id;
  String? user;
  String? home;

  Favorites({
    this.id,
    this.user,
    this.home,
  });

  Favorites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    home = json['home'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['home'] = home;
    return data;
  }
}
