import 'package:flutter_food_ordering/model/foods_response.dart';
import 'package:flutter_food_ordering/model/shop_response.dart' as prefix0;
import 'package:flutter_food_ordering/viewmodels/base_model.dart';

class ShopViewModel extends BaseViewModel {
  prefix0.ShopResponse shopResponse;

  ShopViewModel() {
    getAllShops();
  }

  void getAllShops() async {
    setState(ViewState.loading);
    try {
      shopResponse = await apiProvider.fetchAllShops();
      setState(ViewState.ready);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      setState(ViewState.error);
      notifyListeners();
    }
  }
}
