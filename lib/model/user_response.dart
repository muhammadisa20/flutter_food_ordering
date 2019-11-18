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

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "user": user == null ? null : user.toJson(),
      };
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

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "profile_img": profileImg == null ? null : profileImg,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "__v": v == null ? null : v,
        "location": location == null ? null : location.toJson(),
      };
}

class Location {
  String id;
  double latitude;
  double longitude;
  String streetName;
  String khan;
  String city;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  @override
  String toString() {
    return '${streetName ?? 'no data'}, ${khan ?? 'no data'}, ${city ?? 'no data'}';
  }

  Location({
    this.id,
    this.latitude,
    this.longitude,
    this.streetName,
    this.khan,
    this.city,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["_id"] == null ? null : json["_id"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        streetName: json["streetName"] == null ? null : json["streetName"],
        khan: json["khan"] == null ? null : json["khan"],
        city: json["city"] == null ? null : json["city"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "streetName": streetName == null ? null : streetName,
        "khan": khan == null ? null : khan,
        "city": city == null ? null : city,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "__v": v == null ? null : v,
      };
}
