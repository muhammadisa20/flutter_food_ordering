class OrderResponse {
  int status;
  String message;
  List<Order> order;

  OrderResponse({
    this.status,
    this.message,
    this.order,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        order: json["order"] == null ? null : List<Order>.from(json["order"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "order": order == null ? null : List<dynamic>.from(order.map((x) => x.toJson())),
      };
}

class Order {
  String id;
  DateTime orderDate;
  List<Item> items;
  num totalPrice;
  Customer shop;
  Customer customer;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Order({
    this.id,
    this.orderDate,
    this.items,
    this.totalPrice,
    this.shop,
    this.customer,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["_id"] == null ? null : json["_id"],
        orderDate: json["order_date"] == null ? null : DateTime.parse(json["order_date"]),
        items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        totalPrice: json["total_price"] == null ? null : json["total_price"],
        shop: json["shop"] == null ? null : Customer.fromJson(json["shop"]),
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "order_date": orderDate == null ? null : orderDate.toIso8601String(),
        "items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
        "total_price": totalPrice == null ? null : totalPrice,
        "shop": shop == null ? null : shop.toJson(),
        "customer": customer == null ? null : customer.toJson(),
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "__v": v == null ? null : v,
      };
}

class Customer {
  String id;
  String name;
  String email;

  Customer({
    this.id,
    this.name,
    this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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

class Item {
  String id;
  Food food;
  int quantity;

  Item({
    this.id,
    this.food,
    this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"] == null ? null : json["_id"],
        food: json["food"] == null ? null : Food.fromJson(json["food"]),
        quantity: json["quantity"] == null ? null : json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "food": food == null ? null : food.toJson(),
        "quantity": quantity == null ? null : quantity,
      };
}

class Food {
  String id;
  String name;
  String description;
  num price;
  String image;
  num rating;
  String shop;
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
        shop: json["shop"] == null ? null : json["shop"],
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
        "shop": shop == null ? null : shop,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "__v": v == null ? null : v,
      };
}
