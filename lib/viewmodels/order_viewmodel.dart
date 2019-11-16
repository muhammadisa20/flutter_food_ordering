import 'package:flutter_food_ordering/model/order_response.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';

class OrderViewModel extends BaseViewModel {
  OrderResponse orderResponse;

  OrderViewModel() {
    getAllOrdersByUser();
  }

  void getAllOrdersByUser() async {
    setState(ViewState.loading);
    try {
      orderResponse = await apiProvider.fetchUserOrderHistory();
      setState(ViewState.ready);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      setState(ViewState.error);
      notifyListeners();
    }
  }
}
