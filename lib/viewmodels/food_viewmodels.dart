import 'package:flutter_food_ordering/model/foods_response.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';

class FoodViewModel extends BaseViewModel {
  FoodResponse foodResponse;
  FoodResponse foodShopResponse;

  FoodViewModel({String shopId}) {
    if (shopId != null) {
      getFoodsByShop(shopId);
    } else
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

  void getFoodsByShop(String shopId) async {
    setState(ViewState.loading);
    try {
      foodShopResponse = await apiProvider.fetchFoodsByShop(shopId);
      setState(ViewState.ready);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      setState(ViewState.error);
      notifyListeners();
    }
  }
}
