class UserResponse {
  int status;
  String message;
  User user;

  UserResponse({
    this.status,
    this.message,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
}

class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String profileImg;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  Location location;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profileImg,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        profileImg: json["profile_img"] == null ? null : json["profile_img"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
      );
}

class Location {
  String id;
  double latitude;
  double longitude;
  String address;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  @override
  String toString() {
    return '$address';
  }

  Location({
    this.id,
    this.latitude,
    this.longitude,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["_id"] == null ? null : json["_id"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        address: json["address"] == null ? null : json["address"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
      );
}
