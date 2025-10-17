import 'package:flutter/foundation.dart';
import 'membership.dart';

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
        'Akses semua fasilitas gym',
        'Fitness equipment terbatas',
        'Locker room',
        'Free mineral water',
      ],
    ),
    Membership(
      id: '2',
      name: 'Gold',
      description: 'Paket 5 bulan + Free 1 bulan dengan akses lebih lengkap',
      price: 1000000,
      duration: 6,
      image: 'assets/gold.png',
      category: 'Premium',
      benefits: [
        'Akses semua fasilitas gym',
        'Semua fitness equipment',
        'Locker room',
        'Kelas grup (yoga, pilates)',
        'Free towel service',
        'Diskon 15% di kafe',
        'Free mineral water',
      ],
    ),
    Membership(
      id: '3',
      name: 'Platinum',
      description: 'Paket 9 bulan + free 3 bulan dengan fasilitas premium',
      price: 1800000,
      duration: 12,
      image: 'assets/platinum.png',
      category: 'VIP',
      benefits: [
        'Akses semua fasilitas',
        'Personal trainer',
        'Semua fitness equipment',
        'Kelas grup (yoga, pilates)',
        'Free massage 2x/bulan',
        'Premium locker',
        'Diskon 15% di kafe',
        'Priority booking',
        'Annual health checkup',
        'Diskon 25% di kafe',
        'Free mineral water',
      ],
    ),
  ];

  List<Membership> get memberships => _memberships;

  List<Membership> getMembershipsByCategory(String category) {
    return _memberships.where((m) => m.category == category).toList();
  }
}