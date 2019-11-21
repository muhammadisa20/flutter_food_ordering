import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
import 'package:flutter_food_ordering/model/shop_response.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';
import 'package:flutter_food_ordering/viewmodels/cart_viewmodel.dart';
import 'package:flutter_food_ordering/viewmodels/food_viewmodels.dart';
import 'package:flutter_food_ordering/widgets/cart_icon.dart';
import 'package:flutter_food_ordering/widgets/center_loading.dart';
import 'package:flutter_food_ordering/widgets/food_card.dart';
import 'package:provider/provider.dart';

class ShopDetailPage extends StatefulWidget {
  final Shop shop;
  const ShopDetailPage(this.shop);

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  num top = double.infinity;
  int items = 0;
  int _current = 0;
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => FoodViewModel(shopId: widget.shop.id),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          title: Text(widget.shop.name),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: CartIcon(color: Colors.white),
            ),
          ],
        ),
        body: Container(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerScrolled) => [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverSafeArea(
                  top: false,
                  sliver: SliverPadding(
                    padding: EdgeInsets.zero,
                    sliver: SliverAppBar(
                      snap: false,
                      automaticallyImplyLeading: false,
                      pinned: false,
                      floating: true,
                      expandedHeight: 250,
                      flexibleSpace: FlexibleSpaceBar(
                        background: buildImageSlideShow(context),
                      ),
                    ),
                  ),
                ),
              ),
              // SliverPersistentHeader(
              //   pinned: true,
              //   delegate: _SliverAppBarDelegate(
              //     TabBar(controller: tabController, tabs: <Widget>[
              //       Tab(text: 'Foods'),
              //       Tab(text: 'Contact'),
              //     ]),
              //   ),
              // )
            ],
            body: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  color: mainColor,
                  child: TabBar(
                    unselectedLabelColor: Colors.black54,
                    controller: tabController,
                    indicatorColor: Colors.black,
                    indicatorWeight: 3,
                    tabs: <Widget>[
                      Tab(child: Container(child: Text('Menu', style: titleStyle))),
                      Tab(child: Container(child: Text('Info', style: titleStyle))),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      buildFoodList(),
                      buildShopInfo(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFoodList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Consumer<FoodViewModel>(
        builder: (context, food, child) {
          switch (food.state) {
            case ViewState.error:
              return CenterLoadingError(Text(food.errorMessage));
              break;
            case ViewState.loading:
              return CenterLoadingError(CircularProgressIndicator());
              break;
            case ViewState.ready:
              return GridView.count(
                padding: EdgeInsets.only(top: 16),
                childAspectRatio: 0.65,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                shrinkWrap: true,
                crossAxisCount: 2,
                children: food.foodShopResponse.foods.map((food) {
                  return FoodCard(food);
                }).toList(),
              );
              break;
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget buildShopInfo() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(top: 16, left: 8, right: 8),
            child: ListTile(
              title: Text('Shop name'),
              subtitle: Text(widget.shop.name),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Description'),
              subtitle: Text(widget.shop.description),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Type'),
              subtitle: Text(widget.shop.type),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Email'),
              subtitle: Text(widget.shop.email),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Phone Number'),
              subtitle: Text(widget.shop.phoneNumber),
              trailing: IconButton(icon: Icon(Icons.call), onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageSlideShow(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarouselSlider(
          viewportFraction: 1.0,
          aspectRatio: 4 / 3,
          autoPlay: true,
          onPageChanged: (index) => setState(() {
            _current = index;
          }),
          autoPlayInterval: Duration(seconds: 3),
          height: 250,
          items: widget.shop.images.map((image) {
            return Container(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: '$BASE_URL/uploads/$image',
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          }).toList(),
        ),
        buildDotIndicator(),
      ],
    );
  }

  Widget buildDotIndicator() {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.shop.images.length, (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index ? Colors.white : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
    );
  }
}
