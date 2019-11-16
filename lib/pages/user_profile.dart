import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/order_response.dart';
import 'package:flutter_food_ordering/model/user_response.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';
import 'package:flutter_food_ordering/viewmodels/order_viewmodel.dart';
import 'package:flutter_food_ordering/viewmodels/user_viewmodel.dart';
import 'package:flutter_food_ordering/widgets/center_loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserProfilePage extends StatelessWidget {
  UserResponse userResponse;
  OrderResponse orderResponse;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => UserViewModel()),
        ChangeNotifierProvider(builder: (_) => OrderViewModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text('User Profile'),
          centerTitle: true,
          actions: <Widget>[AppBarAction()],
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Consumer<UserViewModel>(
                builder: (context, user, child) {
                  userResponse = user.userResponse;
                  switch (user.state) {
                    case ViewState.error:
                      return CenterLoadingError(Text(user.errorMessage));
                      break;
                    case ViewState.loading:
                      return CenterLoadingError(CircularProgressIndicator());
                      break;
                    case ViewState.ready:
                      return buildProfile(userResponse);
                      break;
                    default:
                      return Container();
                  }
                },
              ),
              SizedBox(height: 32),
              Text('Order History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              buildUserOrderHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfile(UserResponse userResponse) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('$BASE_URL/uploads/${userResponse.user.profileImg}'),
              ),
            ),
          ),
          SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Name'),
              subtitle: Text(userResponse.user.name),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(userResponse.user.email),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.call),
              title: Text('Phone Number'),
              subtitle: Text(userResponse.user.phoneNumber),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserOrderHistoryList() {
    return Consumer<OrderViewModel>(
      builder: (context, order, child) {
        orderResponse = order.orderResponse;
        switch (order.state) {
          case ViewState.error:
            return CenterLoadingError(Text(order.errorMessage));
            break;
          case ViewState.loading:
            return CenterLoadingError(CircularProgressIndicator());
            break;
          case ViewState.ready:
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: order.orderResponse.order.length,
              itemBuilder: (BuildContext context, int index) {
                return buildOrderItem(order.orderResponse.order[index]);
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }

  Widget buildOrderItem(Order order) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text('Order Date: ' + DateFormat().format(order.orderDate.toLocal()), style: titleStyle2),
          ),
          ...order.items.map((item) {
            return ListTile(
              leading: Icon(Icons.fastfood),
              trailing: Text('Price: ${item.food.price} \$'),
              title: Text(item.food.name),
              subtitle: Text('Quantity: ${item.quantity}'),
            );
          }).toList(),
          Divider(),
          ListTile(
            title: Text('Total price: '),
            trailing: Text('${order.totalPrice} \$'),
          )
        ],
      ),
    );
  }
}

class AppBarAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserViewModel>(context);
    var order = Provider.of<OrderViewModel>(context);

    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {
        user.getUserInfo();
        order.getAllOrdersByUser();
      },
    );
  }
}
