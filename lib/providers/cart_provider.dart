import 'package:flutter/foundation.dart';
import 'membership.dart';

class CartProvider with ChangeNotifier {
  final List<Membership> _items = [];
  List<Membership> get items => _items;
  
  String? selectedCard; 
  double basePrice = 0; 
  List<Map<String, dynamic>> selectedFacilities = []; 
  
  void addItem(Membership membership) {
    _items.clear(); 
    _items.add(membership);
    selectedCard = membership.name;
    basePrice = membership.price;
    notifyListeners();
  }

  void removeItem(String membershipId) {
    _items.removeWhere((item) => item.id == membershipId);
    selectedCard = null;
    basePrice = 0;
    notifyListeners();
  }
  
  void addFacility(Map<String, dynamic> facility) {
    
    if (!selectedFacilities.any((f) => f['name'] == facility['name'])) {
      selectedFacilities.add(facility);
      notifyListeners();
    }
  }

  void removeFacility(Map<String, dynamic> facility) {
    selectedFacilities.removeWhere((f) => f['name'] == facility['name']);
    notifyListeners();
  }
  
  double get totalPrice {
    double total = basePrice;
    for (var f in selectedFacilities) {
      total += f['price'];
    }
    return total;
  }

  void clearCart() {
    _items.clear();
    selectedCard = null;
    basePrice = 0;
    selectedFacilities.clear();
    notifyListeners();
  }
}
