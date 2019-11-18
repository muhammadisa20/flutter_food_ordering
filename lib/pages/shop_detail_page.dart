import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/shop_response.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';
import 'package:flutter_food_ordering/viewmodels/food_viewmodels.dart';
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
                      pinned: true,
                      floating: true,
                      expandedHeight: 250,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, BoxConstraints constraint) {
                          top = constraint.biggest.height;
                          return FlexibleSpaceBar(
                            background: Image.network(
                              '$BASE_URL/uploads/${widget.shop.logo}',
                              colorBlendMode: BlendMode.overlay,
                              color: Colors.black12,
                              fit: BoxFit.cover,
                            ),
                            title: Text(top > 100 ? '' : widget.shop.name, style: headerStyleSmall),
                          );
                        },
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
                TabBar(
                  controller: tabController,
                  tabs: <Widget>[
                    Tab(child: Text('Foods', style: titleStyle)),
                    Tab(child: Text('Info', style: titleStyle)),
                  ],
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
}

class TestPersistentHeader implements SliverPersistentHeaderDelegate {
  TestPersistentHeader({
    this.minExtent,
    @required this.maxExtent,
  });
  final double minExtent;
  final double maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black54],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(
            '$shrinkOffset',
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.white.withOpacity(titleOpacity(shrinkOffset)),
            ),
          ),
        ),
      ],
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;
}
