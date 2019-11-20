import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
import 'package:flutter_food_ordering/viewmodels/cart_viewmodel.dart';
import 'package:flutter_food_ordering/widgets/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatelessWidget {
  final Color color;
  CartIcon({this.color: Colors.yellow});

  showCart(context) {
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCartViewModel>(
      builder: (context, cart, child) {
        return Stack(
          children: <Widget>[
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => showCart(context)),
            Positioned(
              right: 0,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                child: Text(
                  cart.cartItems.fold<int>(0, (previous, cart) {
                    return cart.quantity + previous;
                  }).toString(),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
