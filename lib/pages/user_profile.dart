import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_food_ordering/constants/base_url.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
import 'package:flutter_food_ordering/main.dart';
import 'package:flutter_food_ordering/model/order_response.dart';
import 'package:flutter_food_ordering/model/user_response.dart';
import 'package:flutter_food_ordering/pages/select_map.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';
import 'package:flutter_food_ordering/viewmodels/order_viewmodel.dart';
import 'package:flutter_food_ordering/viewmodels/user_viewmodel.dart';
import 'package:flutter_food_ordering/widgets/center_loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class UserProfilePage extends StatelessWidget {
  UserResponse userResponse;
  ApiProvider apiProvider = getIt<ApiProvider>();

  void changeProfileImage(context, UserViewModel user) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);
    if (image != null) {
      apiProvider.updateUserInfo(image: image).then((newImage) {
        if (newImage != null) {
          Toast.show('Update success', context);
          user.updateImage(newImage);
        } else {}
      }).catchError((err) {
        Toast.show(err.toString(), context);
      });
    }
  }

  void changeDeliveryLocation(context, user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DeliveryLocationPage(
                lat: userResponse.user.location?.latitude ?? null,
                lng: userResponse.user.location?.longitude ?? null,
              )),
    );
    user.getUserInfo();
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              //   child: Text('User Info', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              // ),
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
                      return buildProfile(userResponse, user, context);
                      break;
                    default:
                      return Container();
                  }
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Text('Order History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              buildUserOrderHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfile(UserResponse userResponse, UserViewModel user, context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => changeProfileImage(context, user),
              child: CachedNetworkImage(
                width: 150,
                height: 150,
                imageUrl: '$BASE_URL/uploads/${userResponse.user.profileImg}',
                fit: BoxFit.fitWidth,
                fadeInDuration: Duration(milliseconds: 50),
                errorWidget: (context, _, obj) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Name'),
              subtitle: Text(userResponse.user.name),
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
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
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
            ),
          ),
          Card(
            child: ListTile(
              isThreeLine: true,
              onTap: () => changeDeliveryLocation(context, user),
              leading: Icon(Icons.my_location),
              title: Text('Delivery Location'),
              subtitle: Text(userResponse.user.location.toString()),
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: null),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserOrderHistoryList() {
    return Consumer<OrderViewModel>(
      builder: (context, order, child) {
        switch (order.state) {
          case ViewState.error:
            return CenterLoadingError(Text(order.errorMessage));
            break;
          case ViewState.loading:
            return CenterLoadingError(CircularProgressIndicator());
            break;
          case ViewState.ready:
            order.orderResponse.order = order.orderResponse.order.reversed.toList();
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: order.orderResponse.order.length,
              itemBuilder: (BuildContext context, int index) {
                return buildOrderItem(order.orderResponse.order[index], context);
              },
            );
            break;
          default:
            return Container();
        }
      },
    );
  }

  Widget buildOrderItem(Order order, context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      shape: RoundedRectangleBorder(side: BorderSide(width: 0.1, color: Colors.black12), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Order Date: ' + DateFormat().format(order.orderDate.toLocal()), style: titleStyle),
          ),
          ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: order.items.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              var item = order.items[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('$BASE_URL/uploads/${item.food.image}'),
                ),
                trailing: Text('Price: ${item.food.price.toDouble()} \$'),
                isThreeLine: false,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(item.food.name),
                ),
                subtitle: Text('Quantity: ${item.quantity}'),
              );
            },
          ),
          Divider(thickness: 1.5),
          ListTile(
            title: Text('Total price: ', style: titleStyle),
            trailing: Text('${order.totalPrice.toDouble()} \$', style: titleStyle),
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
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            user.getUserInfo();
            order.getAllOrdersByUser();
          },
        ),
      ],
    );
  }
}
