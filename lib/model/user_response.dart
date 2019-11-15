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
        status: json["status"],
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String profileImg;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.profileImg,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        profileImg: json["profile_img"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "profile_img": profileImg,
      };
}
