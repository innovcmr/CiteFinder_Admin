class HomeRoom {
  String? id;
  String? home;
  String? type;
  List<String>? images;
  int? numberAvailable;
  String? description;
  double? price;

  HomeRoom(
      {this.id,
      this.home,
      this.type,
      this.images,
      this.numberAvailable,
      this.description,
      this.price});

  HomeRoom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    home = json['home'];
    type = json['type'];
    images = json['images'].cast<String>();
    numberAvailable = json['numberAvailable'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['home'] = home;
    data['type'] = type;
    data['images'] = images;
    data['numberAvailable'] = numberAvailable;
    data['description'] = description;
    data['price'] = price;
    return data;
  }
}
