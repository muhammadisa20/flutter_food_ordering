import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/foods_response.dart';
import 'package:flutter_food_ordering/model/shop_response.dart' as prefix0;
import 'package:flutter_food_ordering/pages/user_profile.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';
import 'package:flutter_food_ordering/viewmodels/cart_viewmodel.dart';
import 'package:flutter_food_ordering/viewmodels/food_viewmodels.dart';
import 'package:flutter_food_ordering/viewmodels/shop_viewmodel.dart';
import 'package:flutter_food_ordering/widgets/cart_bottom_sheet.dart';
import 'package:flutter_food_ordering/widgets/center_loading.dart';
import 'package:flutter_food_ordering/widgets/food_card.dart';
import 'package:flutter_food_ordering/widgets/shop_card.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int value = 1;
  FoodViewModel foodViewModel;
  ShopViewModel shopViewModel;
  PageController pageController = PageController(keepPage: true);
  ValueNotifier<int> pageIndex = ValueNotifier(0);

  List get pages => [
        buildFoodList(),
        buildShopList(),
      ];

  showCart() {
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }

  viewProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserProfilePage()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => FoodViewModel()),
        ChangeNotifierProvider(builder: (context) => ShopViewModel()),
      ],
      child: Scaffold(
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (context, page, child) {
            return BottomNavigationBar(
              onTap: (index) {
                pageController.jumpToPage(index);
                pageIndex.value = index;
              },
              currentIndex: page,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.fastfood), title: Text('Foods')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), title: Text('Shop')),
              ],
            );
          },
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: <Widget>[
              buildAppBar(),
              buildFoodFilter(),
              Divider(),
              Expanded(
                child: PageView.builder(
                  itemCount: 2,
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    int items = 0;
    Provider.of<MyCartViewModel>(context).cartItems.forEach((cart) {
      items += cart.quantity;
    });
    return SafeArea(
      child: Row(
        children: <Widget>[
          Text('MENU', style: headerStyle),
          Spacer(),
          IconButton(icon: Icon(Icons.person), onPressed: viewProfile),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                foodViewModel.getAllFoods();
                shopViewModel.getAllShops();
              }),
          Stack(
            children: <Widget>[
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: showCart),
              Positioned(
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: mainColor),
                  child: Text(
                    '$items',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFoodFilter() {
    return Container(
      height: 50,
      //color: Colors.red,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: List.generate(FoodTypes.values.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              selectedColor: mainColor,
              labelStyle: TextStyle(
                  color: value == index ? Colors.white : Colors.black),
              label: Text(FoodTypes.values[index].toString().split('.').last),
              selected: value == index,
              onSelected: (selected) {
                setState(() {
                  value = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget buildFoodList() {
    return Consumer<FoodViewModel>(
      builder: (context, food, child) {
        foodViewModel = food;
        switch (food.state) {
          case ViewState.error:
            return CenterLoadingError(Text(food.errorMessage));
            break;
          case ViewState.loading:
            return CenterLoadingError(CircularProgressIndicator());
            break;
          case ViewState.ready:
            return GridView.count(
              childAspectRatio: 0.65,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: BouncingScrollPhysics(),
              children: food.foodResponse.foods.map((food) {
                return FoodCard(food);
              }).toList(),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }

  Widget buildShopList() {
    return Consumer<ShopViewModel>(
      builder: (context, shop, child) {
        shopViewModel = shop;
        switch (shop.state) {
          case ViewState.error:
            return CenterLoadingError(Text(shop.errorMessage));
            break;
          case ViewState.loading:
            return CenterLoadingError(CircularProgressIndicator());
            break;
          case ViewState.ready:
            return GridView.count(
              childAspectRatio: 0.65,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: BouncingScrollPhysics(),
              children: shop.shopResponse.shops.map((prefix0.Shop shop) {
                return ShopCard(shop);
              }).toList(),
            );
            break;
          default:
            return Container();
        }
      },
    );
  }
}
