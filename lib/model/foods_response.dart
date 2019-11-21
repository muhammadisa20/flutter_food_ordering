class FoodResponse {
  int status;
  String message;
  List<Food> foods;

  FoodResponse({
    this.status,
    this.message,
    this.foods,
  });

  factory FoodResponse.fromJson(Map<String, dynamic> json) => FoodResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        foods: json["foods"] == null ? null : List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "foods": foods == null ? null : List<dynamic>.from(foods.map((x) => x.toJson())),
      };
}

class Food {
  String id;
  String name;
  String description;
  num price;
  String image;
  num rating;
  Shop shop;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Food({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.rating,
    this.shop,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        price: json["price"] == null ? null : json["price"],
        image: json["image"] == null ? 'Placeholder-food.jpg' : json["image"],
        rating: json["rating"] == null ? null : json["rating"],
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "price": price == null ? null : price,
        "image": image == null ? null : image,
        "rating": rating == null ? null : rating,
        "shop": shop == null ? null : shop.toJson(),
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "__v": v == null ? null : v,
      };
}

class Shop {
  String id;
  String name;
  String email;

  Shop({
    this.id,
    this.name,
    this.email,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
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

enum FoodTypes {
  StreetFood,
  All,
  Drinks,
  Khmer,
  FastFood,
  Dessert,
}
