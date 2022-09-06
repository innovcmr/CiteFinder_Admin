class Location {
  String? id;
  String? geoCoordinates;
  String? city;
  String? quarter;

  Location({this.id, this.geoCoordinates, this.city, this.quarter});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    geoCoordinates = json['geoCoordinates'];
    city = json['city'];
    quarter = json['quarter'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['geoCoordinates'] = geoCoordinates;
    data['city'] = city;
    data['quarter'] = quarter;
    return data;
  }
}
