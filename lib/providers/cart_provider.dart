// providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/membership.dart';

class CartProvider with ChangeNotifier {
  // ===== DATA KARTU UTAMA =====
  final List<Membership> _items = [];
  List<Membership> get items => _items;

  // ===== DATA TAMBAHAN =====
  String? selectedCard; // Nama kartu: Bronze, Silver, Gold
  double basePrice = 0; // Harga kartu utama
  List<Map<String, dynamic>> selectedFacilities = []; // Fasilitas tambahan

  // ====== KARTU ======
  void addItem(Membership membership) {
    _items.clear(); // hanya satu kartu aktif di keranjang
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

  // ====== FASILITAS TAMBAHAN ======
  void addFacility(Map<String, dynamic> facility) {
    // hindari fasilitas duplikat
    if (!selectedFacilities.any((f) => f['name'] == facility['name'])) {
      selectedFacilities.add(facility);
      notifyListeners();
    }
  }

  void removeFacility(Map<String, dynamic> facility) {
    selectedFacilities.removeWhere((f) => f['name'] == facility['name']);
    notifyListeners();
  }

  // ====== TOTAL HARGA ======
  double get totalPrice {
    double total = basePrice;
    for (var f in selectedFacilities) {
      total += f['price'];
    }
    return total;
  }

  // ====== HAPUS SEMUA ======
  void clearCart() {
    _items.clear();
    selectedCard = null;
    basePrice = 0;
    selectedFacilities.clear();
    notifyListeners();
  }
}
