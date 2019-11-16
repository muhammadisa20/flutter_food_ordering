import 'package:flutter_food_ordering/main.dart';
import 'package:flutter_food_ordering/model/user_response.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:flutter_food_ordering/viewmodels/base_model.dart';

class UserViewModel extends BaseViewModel {
  UserResponse userResponse;

  UserViewModel() {
    getUserInfo();
  }

  void getUserInfo() async {
    setState(ViewState.loading);
    try {
      userResponse = await apiProvider.fetchUserData();
      setState(ViewState.ready);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      setState(ViewState.error);
      notifyListeners();
    }
  }
}
