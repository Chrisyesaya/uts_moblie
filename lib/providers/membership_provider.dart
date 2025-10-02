// providers/membership_provider.dart
import 'package:flutter/foundation.dart';
import '../models/membership.dart';

class MembershipProvider with ChangeNotifier {
  final List<Membership> _memberships = [
    Membership(
      id: '1',
      name: 'Silver',
      description: 'Paket 3 bulan dengan akses terbatas',
      price: 600000,
      duration: 3,
      image: 'assets/silver.png',
      category: 'Basic',
      benefits: [
        'Akses area gym dasar',
        'Fitness equipment terbatas',
        'Locker room',
        'Area billiard (2 jam/minggu)',
        'Tenis meja (1 jam/minggu)',
        'Free mineral water',
      ],
    ),
    Membership(
      id: '2',
      name: 'Gold',
      description: 'Paket 6 bulan dengan akses lebih lengkap',
      price: 1000000,
      duration: 6,
      image: 'assets/gold.png',
      category: 'Premium',
      benefits: [
        'Akses semua area gym',
        'Semua fitness equipment',
        'Kelas grup (yoga, pilates)',
        'Area billiard (5 jam/minggu)',
        'Tenis meja (3 jam/minggu)',
        'Area badminton (2 jam/minggu)',
        'Free towel service',
        'Diskon 15% di kafe',
        'Nutrition consultation',
      ],
    ),
    Membership(
      id: '3',
      name: 'Platinum',
      description: 'Paket 12 bulan dengan fasilitas premium',
      price: 1800000,
      duration: 12,
      image: 'assets/platinum.png',
      category: 'VIP',
      benefits: [
        'Akses unlimited semua fasilitas',
        'Personal trainer 4x/bulan',
        'Area billiard unlimited',
        'Tenis meja unlimited',
        'Area badminton unlimited',
        'Squash court access',
        'Free massage 1x/bulan',
        'Premium locker',
        'Free smoothie bar',
        'Priority booking',
        'Guest pass 2x/bulan',
        'Annual health checkup',
      ],
    ),
  ];

  List<Membership> get memberships => _memberships;

  // Untuk mendapatkan membership berdasarkan kategori
  List<Membership> getMembershipsByCategory(String category) {
    return _memberships.where((m) => m.category == category).toList();
  }
}