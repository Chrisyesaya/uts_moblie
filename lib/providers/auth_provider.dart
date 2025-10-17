import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/membership.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _profileImagePath;
  Membership? _userMembership;
  List<Map<String, dynamic>> _extraFacilities = [];

  String? _gender;
  String? _address;
  DateTime? _birthDate;

  final Map<String, Map<String, dynamic>> _accounts = {
    "admin": {
      "password": "admin123",
      "gender": "Laki-laki",
      "address":
          "UBM Tower, Alam Sutera, Jl. Jalur Sutera Bar. No.Kav.7-9, Kota Tangerang, Banten 15143",
      "birthDate": "1990-01-01",
    },
  };

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get profileImage => _profileImagePath;
  File? get profileImageFile {
    if (_profileImagePath == null || kIsWeb) return null;
    return File(_profileImagePath!);
  }

  String? get gender => _gender;
  String? get address => _address;
  DateTime? get birthDate => _birthDate;

  Membership? get userMembership => _userMembership;
  List<Map<String, dynamic>> get extraFacilities => _extraFacilities;

  bool login(String username, String password) {
    if (_accounts.containsKey(username) &&
        _accounts[username]!["password"] == password) {
      _isLoggedIn = true;
      _username = username;
  
      final userData = _accounts[username]!;
      _gender = userData["gender"];
      _address = userData["address"];
      _birthDate = DateTime.tryParse(userData["birthDate"] ?? "");

      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    _profileImagePath = null;
    _userMembership = null;
    _extraFacilities = [];
    _gender = null;
    _address = null;
    _birthDate = null;
    notifyListeners();
  }
  
  bool register({
    required String username,
    required String password,
    required String gender,
    required String address,
    required DateTime birthDate,
  }) {
    if (_accounts.containsKey(username)) return false;

    _accounts[username] = {
      "password": password,
      "gender": gender,
      "address": address,
      "birthDate": birthDate.toIso8601String().split('T')[0],
    };

    notifyListeners();
    return true;
  }
  
  Future<void> updateProfileImage(String imagePath) async {
    _profileImagePath = imagePath;
    notifyListeners();
  }
  
  void setMembership(
      Membership membership, List<Map<String, dynamic>> facilities) {
    _userMembership = membership;
    _extraFacilities = facilities;
    notifyListeners();
  }
  
  void updateProfile({
    String? gender,
    String? address,
    DateTime? birthDate,
  }) {
    if (gender != null) _gender = gender;
    if (address != null) _address = address;
    if (birthDate != null) _birthDate = birthDate;

    if (_username != null && _accounts.containsKey(_username)) {
      _accounts[_username]!["gender"] = _gender;
      _accounts[_username]!["address"] = _address;
      _accounts[_username]!["birthDate"] = _birthDate?.toIso8601String().split('T')[0];
    }

    notifyListeners();
  }
}
