class ShopResponse {
  int status;
  String message;
  List<Shop> shops;

  ShopResponse({
    this.status,
    this.message,
    this.shops,
  });

  factory ShopResponse.fromJson(Map<String, dynamic> json) => ShopResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        shops: json["shops"] == null ? null : List<Shop>.from(json["shops"].map((x) => Shop.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "shops": shops == null ? null : List<dynamic>.from(shops.map((x) => x.toJson())),
      };
}

class Shop {
  String logo;
  String id;
  String name;
  String email;
  String phoneNumber;
  String type;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Shop({
    this.logo,
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.type,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        logo: json["logo"] == null ? null : json["logo"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        type: json["type"] == null ? null : json["type"],
        description: json["description"] == null ? null : json["description"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "logo": logo == null ? null : logo,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "type": type == null ? null : type,
        "description": description == null ? null : description,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "__v": v == null ? null : v,
      };
}
