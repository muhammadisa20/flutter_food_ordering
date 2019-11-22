import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
import 'package:flutter_food_ordering/model/shop_response.dart';
import 'package:flutter_food_ordering/pages/shop_detail_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  ShopCard(this.shop);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: roundedRectangle12,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShopDetailPage(shop)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildImage(context),
              buildShopInfo(),
              buildRating(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(context) {
    return Container(
      height: MediaQuery.of(context).size.width / 2.5,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "$BASE_URL/uploads/${shop.images[0]}",
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
              child: Text(shop.type),
            ),
          )
        ],
      ),
    );
  }

  Widget buildShopInfo() {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(shop.name, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
          SizedBox(height: 4),
          Text(shop.description, style: infoStyle, maxLines: shop.name.length > 25 ? 1 : 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget buildRating() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
          Text('(20)'),
        ],
      ),
    );
  }
}
