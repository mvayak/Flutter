import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading {
    return _isLoading;
  }

  bool _isPwdVisible = false;
  bool get isPwdVisible {
    return _isPwdVisible;
  }

  updateIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  updatePwdVisible(bool visible) {
    _isPwdVisible = visible;
    notifyListeners();
  }
}
