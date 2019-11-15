import 'package:flutter/cupertino.dart';

enum ViewState { loading, ready, error }

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.loading;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
