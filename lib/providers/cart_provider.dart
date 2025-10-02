// providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/membership.dart';

class CartProvider with ChangeNotifier {
  final List<Membership> _items = [];

  List<Membership> get items => _items;

  void addItem(Membership membership) {
    _items.add(membership);
    notifyListeners();
  }

  void removeItem(String membershipId) {
    _items.removeWhere((item) => item.id == membershipId);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (total, item) => total + item.price);
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}