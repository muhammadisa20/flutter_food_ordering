import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/foods_response.dart';

class MyCartViewModel extends ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get cartItems => _items;

  bool addItem(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.food.shop.id != cart.food.shop.id) {
        return false;
      }
      if (cartItem.food.id == cart.food.id) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        notifyListeners();
        return true;
      }
    }

    _items.add(cartItem);
    notifyListeners();
    return true;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void decreaseItem(CartItem cartModel) {
    if (cartItems[cartItems.indexOf(cartModel)].quantity <= 1) {
      return;
    }
    cartItems[cartItems.indexOf(cartModel)].quantity--;
    notifyListeners();
  }

  void increaseItem(CartItem cartModel) {
    cartItems[cartItems.indexOf(cartModel)].quantity++;
    notifyListeners();
  }

  void removeAllInCart(Food food) {
    cartItems.removeWhere((f) {
      return f.food.id == food.id;
    });
    notifyListeners();
  }
}

class CartItem {
  Food food;
  int quantity;

  CartItem({this.food, this.quantity});
}
