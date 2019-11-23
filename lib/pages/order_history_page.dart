import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
import 'package:flutter_food_ordering/constants/base_url.dart';
import 'package:flutter_food_ordering/model/order_response.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';
import 'package:flutter_food_ordering/viewmodels/order_viewmodel.dart';
import 'package:flutter_food_ordering/widgets/center_loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => OrderViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text('Order History'),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        body: Consumer<OrderViewModel>(
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
        ),
      ),
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
