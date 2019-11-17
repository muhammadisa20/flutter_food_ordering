import 'package:flutter/material.dart';
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
                      snap: true,
                      pinned: true,
                      floating: true,
                      expandedHeight: 250,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(widget.shop.name),
                        background: Image.network(
                          '$BASE_URL/uploads/${widget.shop.logo}',
                          colorBlendMode: BlendMode.overlay,
                          color: Colors.black12,
                          fit: BoxFit.cover,
                        ),
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
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                        padding: EdgeInsets.zero,
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
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
