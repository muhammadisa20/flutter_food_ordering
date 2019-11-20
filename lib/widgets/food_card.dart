import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
import 'package:flutter_food_ordering/model/foods_response.dart';
import 'package:flutter_food_ordering/viewmodels/cart_viewmodel.dart';
import 'package:flutter_food_ordering/widgets/cart_bottom_sheet.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatefulWidget {
  final Food food;
  FoodCard(this.food);

  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> with SingleTickerProviderStateMixin {
  Food get food => widget.food;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: roundedRectangle12,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildImage(),
                buildTitle(),
                buildRating(),
                buildPriceInfo(),
              ],
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.all(4),
            //     decoration: BoxDecoration(
            //       color: mainColor,
            //       borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            //     ),
            //     child: Text(food.shop.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return Container(
      height: MediaQuery.of(context).size.width / 2.5,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: "$BASE_URL/uploads/${food.images[0]}",
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            food.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          Text(
            food.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: infoStyle,
          ),
        ],
      ),
    );
  }

  Widget buildRating() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RatingBar(
            initialRating: 5.0,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 14,
            unratedColor: Colors.black,
            itemPadding: EdgeInsets.only(right: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, index) => Icon(Icons.star, color: mainColor),
            onRatingUpdate: (rating) {},
          ),
          Text('(${food.rating})'),
        ],
      ),
    );
  }

  Widget buildPriceInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '\$ ${food.price}',
            style: titleStyle,
          ),
          Card(
            margin: EdgeInsets.zero,
            shape: roundedRectangle4,
            color: mainColor,
            child: InkWell(
              onTap: addItemToCard,
              splashColor: Colors.white70,
              customBorder: roundedRectangle4,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.add_shopping_cart),
              ),
            ),
          )
        ],
      ),
    );
  }

  addItemToCard() {
    bool isAddSuccess = Provider.of<MyCartViewModel>(context).addItem(CartItem(food: food, quantity: 1));

    if (isAddSuccess) {
      final snackBar = SnackBar(
        content: Text('${food.name} added to cart'),
        action: SnackBarAction(
          label: 'view',
          onPressed: showCart,
        ),
        duration: Duration(seconds: 1),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text('You can\'t order from multiple shop at the same time'),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  showCart() {
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }
}
