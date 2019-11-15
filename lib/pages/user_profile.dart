import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/order_response.dart';
import 'package:flutter_food_ordering/model/user_response.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  ApiProvider apiProvider = ApiProvider();
  Future<UserResponse> user;
  Future<OrderResponse> orders;

  @override
  void initState() {
    user = apiProvider.fetchUserData();
    orders = apiProvider.fetchUserOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('User Profile'),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<UserResponse>(
              future: user,
              builder: (BuildContext context, AsyncSnapshot<UserResponse> snapshot) {
                if (snapshot.hasData) {
                  return buildProfile(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            Text('Order History', style: titleStyle),
            buildUserOrderHistoryList(),
          ],
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
    return FutureBuilder<OrderResponse>(
      future: orders,
      builder: (BuildContext context, AsyncSnapshot<OrderResponse> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            primary: false,
            itemCount: snapshot.data.order.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Order order = snapshot.data.order[index];
              return buildOrderItem(order);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
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
          }).toList()
        ],
      ),
    );
  }
}
