class User {
  String? id;
  String? fullName;
  String? email;
  String? location;
  String? photoUrl;
  String? role;
  String? dateAdded;
  bool? isVerified;
  bool? isGoogleUser;
  bool? isFacebookUser;

  User(
      {this.id,
      this.fullName,
      this.email,
      this.location,
      this.photoUrl,
      this.role,
      this.dateAdded,
      this.isVerified,
      this.isGoogleUser,
      this.isFacebookUser});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    location = json['location'];
    photoUrl = json['photoUrl'];
    role = json['role'];
    dateAdded = json['dateAdded'];
    isVerified = json['isVerified'];
    isGoogleUser = json['isGoogleUser'];
    isFacebookUser = json['isFacebookUser'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['location'] = location;
    data['photoUrl'] = photoUrl;
    data['role'] = role;
    data['dateAdded'] = dateAdded;
    data['isVerified'] = isVerified;
    data['isGoogleUser'] = isGoogleUser;
    data['isFacebookUser'] = isFacebookUser;
    return data;
  }
}
