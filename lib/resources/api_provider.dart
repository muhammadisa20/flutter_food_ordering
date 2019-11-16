import 'package:dio/dio.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/foods_response.dart';
import 'package:flutter_food_ordering/model/order_response.dart';
import 'package:flutter_food_ordering/model/shop_response.dart';
import 'package:flutter_food_ordering/model/user_response.dart';
import 'package:flutter_food_ordering/viewmodels/cart_viewmodel.dart';

class ApiProvider {
  var dio = Dio()..options.connectTimeout = 10000;
  Future<FoodResponse> fetchAllFoods() async {
    Response response;
    try {
      response = await dio.get('$BASE_URL/api/foods');
      print('fetch all foods');
      if (response.data['status'] == 1) {
        return FoodResponse.fromJson(response.data);
      } else {
        throw response.data['message'];
      }
    } on DioError catch (error) {
      handleExceptionError(error);
      return null;
    }
  }

  Future<ShopResponse> fetchAllShops() async {
    Response response;
    try {
      response = await dio.get('$BASE_URL/api/shop/allShops');
      print('fetch all shops');
      if (response.data['status'] == 1) {
        return ShopResponse.fromJson(response.data);
      } else {
        throw response.data['message'];
      }
    } on DioError catch (error) {
      handleExceptionError(error);
      return null;
    }
  }

  Future<UserResponse> fetchUserData() async {
    try {
      var response = await dio.get('$BASE_URL/api/user/info/$userId');
      print('fetch user data');
      if (response.data['status'] == 1) {
        return UserResponse.fromJson(response.data);
      } else {
        throw response.data['message'];
      }
    } on DioError catch (error) {
      handleExceptionError(error);
      return null;
    }
  }

  Future<OrderResponse> fetchUserOrderHistory() async {
    try {
      var response = await dio.get('$BASE_URL/api/order/user', queryParameters: {"token": token});
      print('fetch user order');
      if (response.data['status'] == 1) {
        return OrderResponse.fromJson(response.data);
      } else {
        throw response.data['message'];
      }
    } on DioError catch (error) {
      handleExceptionError(error);
      return null;
    }
  }

  Future<bool> orderFood(MyCartViewModel cart) async {
    try {
      List<Map> data = List.generate(cart.cartItems.length, (index) {
        return {"id": cart.cartItems[index].food.id, "quantity": cart.cartItems[index].quantity};
      }).toList();

      var response = await dio.post('$BASE_URL/api/order/food', queryParameters: {"token": token}, data: data);
      if (response.data['status'] == 1) {
        cart.clearCart();
        return true;
      } else {
        handleExceptionError(response.data['message']);
        return null;
      }
    } on DioError catch (error) {
      handleExceptionError(error);
      return null;
    }
  }

  void handleExceptionError(DioError error) {
    print(error.message);
    if (error.message.contains('timed out')) {
      throw 'Error Connecting to server!!';
    } else if (error.message.contains('SocketException')) {
      throw error.error.message;
    }
    throw error.message;
  }
}
