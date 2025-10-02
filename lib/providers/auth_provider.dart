import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  final Map<String, String> _accounts = {
    "admin": "admin123",
  };

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  bool login(String username, String password) {
    if (_accounts.containsKey(username) && _accounts[username] == password) {
      _isLoggedIn = true;
      _username = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }

  bool register(String username, String password) {
    if (_accounts.containsKey(username)) {
      return false;
    }
    _accounts[username] = password;
    notifyListeners();
    return true;
  }
}