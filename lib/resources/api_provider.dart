import 'package:dio/dio.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/foods_response.dart';
import 'package:flutter_food_ordering/model/order_response.dart';
import 'package:flutter_food_ordering/model/user_response.dart';

class ApiProvider {
  Future<FoodResponse> fetchAllFoods() async {
    var dio = Dio()..options.connectTimeout = 10000;
    Response response;
    try {
      response = await dio.get('$BASE_URL/api/foods');
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

  Future<UserResponse> fetchUserData() async {
    try {
      var response = await Dio().get('$BASE_URL/api/user/info/$userId');
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
      var response = await Dio().get('$BASE_URL/api/order/user', queryParameters: {"token": token});
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

  void handleExceptionError(error) {
    if (error.message.contains('timed out')) {
      throw 'Error Connecting to server!!';
    } else if (error.message.contains('SocketException')) {
      throw 'No internet connection!!';
    }
    throw error.message;
  }
}
