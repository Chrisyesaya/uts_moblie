import 'package:flutter/foundation.dart';
import '../models/membership.dart';

class MembershipProvider with ChangeNotifier {
  final List<Membership> _memberships = [
    Membership(
      id: '1',
      name: 'Silver',
      description: 'Akses terbatas ke fasilitas gym',
      price: 199000,
      image: 'assets/silver.png',
    ),
    Membership(
      id: '2',
      name: 'Gold',
      description: 'Akses penuh ke fasilitas gym + kelas grup',
      price: 399000,
      image: 'assets/gold.png',
    ),
    Membership(
      id: '3',
      name: 'Platinum',
      description: 'Akses premium + personal trainer',
      price: 799000,
      image: 'assets/platinum.png',
    ),
  ];

  List<Membership> get memberships => _memberships;
}
