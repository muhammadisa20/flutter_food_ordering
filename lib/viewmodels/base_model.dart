import 'package:flutter/cupertino.dart';
import 'package:flutter_food_ordering/main.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';

enum ViewState { loading, ready, error }

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.loading;
  ApiProvider apiProvider = getIt<ApiProvider>();
  String errorMessage;
  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
