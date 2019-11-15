import 'package:flutter/cupertino.dart';
import 'package:flutter_food_ordering/main.dart';
import 'package:flutter_food_ordering/model/foods_response.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';

class FoodViewModel extends BaseViewModel {
  FoodResponse foodResponse;
  String errorMessage;
  ApiProvider apiProvider = getIt<ApiProvider>();

  FoodViewModel() {
    getAllFoods();
  }

  void getAllFoods() async {
    setState(ViewState.loading);
    try {
      foodResponse = await apiProvider.fetchAllFoods();
      setState(ViewState.ready);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      setState(ViewState.error);
      notifyListeners();
    }
  }
}
