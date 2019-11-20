class LoginResponse {
  int status;
  String message;
  User user;
  String token;

  LoginResponse({
    this.status,
    this.message,
    this.user,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "user": user == null ? null : user.toJson(),
        "token": token == null ? null : token,
      };
}

class User {
  String id;
  String name;
  String email;

  User({
    this.id,
    this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
      };
}
