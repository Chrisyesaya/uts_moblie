import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/membership_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/membership.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.username ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: ClipOval(
                    child: Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ClipOval(
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 24,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'SportClub - $username',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(context),
            _buildGallerySection(context),
            _buildMembershipSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Aplikasi',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'SportClub adalah aplikasi membership gym yang menyediakan berbagai paket membership dengan durasi dan fasilitas berbeda.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 4),
          Text(
            'Aplikasi ini dibuat oleh: \n- Vincent Pratama / 32230011\n- Christopher Yesaya / 32230031',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context) {
    final List<Map<String, String>> galleryItems = [
      {
        'image': 'assets/1.jpg',
        'title': 'Area Gym Premium',
        'description': 'Equipment modern dengan trainer berpengalaman',
      },
      {
        'image': 'assets/2.jpg',
        'title': 'Billiard Lounge',
        'description': 'Meja billiard profesional untuk waktu santai',
      },
      {
        'image': 'assets/3.jpg',
        'title': 'Tenis Meja',
        'description': 'Area tenis meja untuk pertandingan seru',
      },
      {
        'image': 'assets/4.jpg',
        'title': 'Badminton Court',
        'description': 'Lapangan badminton standar nasional',
      },
      {
        'image': 'assets/5.jpg',
        'title': 'Yoga Studio',
        'description': 'Studio yoga dengan instruktur bersertifikat',
      },
      {
        'image': 'assets/6.jpg',
        'title': 'Squash Court',
        'description': 'Court squash dengan pencahayaan optimal',
      },
    ];

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Galeri Fasilitas',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jelajahi berbagai fasilitas sport premium yang kami sediakan.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          Container(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: galleryItems
                  .map(
                    (item) => _buildGalleryItem(
                      context,
                      item['image']!,
                      item['title']!,
                      item['description']!,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(
    BuildContext context,
    String imagePath,
    String title,
    String description,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    child: Icon(
                      Icons.fitness_center,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipSection(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (context, membershipProvider, child) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Membership',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tingkatkan pengalaman olahraga Anda dengan membership terbaik.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              ...membershipProvider.memberships
                  .map(
                    (membership) => _buildMembershipCard(context, membership),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembershipCard(BuildContext context, Membership membership) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isPlatinum = membership.name == 'Platinum';

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: isPlatinum
            ? Border.all(color: Theme.of(context).primaryColor, width: 2)
            : null,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: _getCardGradient(membership.name, isDarkMode),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      membership.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${membership.duration} Bulan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  membership.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Rp ${_formatPrice(membership.price)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'Rp ${_formatPrice(membership.price / membership.duration)}/bulan',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fasilitas yang didapat:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                ...membership.benefits
                    .map(
                      (benefit) => Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(
                    context,
                    listen: false,
                  ).addItem(membership);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${membership.name} ditambahkan ke keranjang',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(membership.name, isDarkMode),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Pilih Membership',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: _getButtonTextColor(membership.name, isDarkMode),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getCardGradient(String membershipName, bool isDarkMode) {
    switch (membershipName) {
      case 'Silver':
        return isDarkMode
            ? [Colors.grey[600]!, Colors.grey[500]!]
            : [Colors.grey[600]!, Colors.grey[500]!];
      case 'Gold':
        return isDarkMode
            ? [Colors.amber[700]!, Colors.amber[600]!]
            : [Colors.purple[700]!, Colors.purple[500]!];
      case 'Platinum':
        return isDarkMode
            ? [Colors.purple[700]!, Colors.purple[500]!]
            : [Colors.deepPurple[700]!, Colors.deepPurple[500]!];
      default:
        return isDarkMode
            ? [Colors.blue, Colors.lightBlue]
            : [Colors.blue, Colors.lightBlue];
    }
  }

  Color _getButtonColor(String membershipName, bool isDarkMode) {
    switch (membershipName) {
      case 'Silver':
        return isDarkMode ? Colors.grey[400]! : Colors.grey[500]!;
      case 'Gold':
        return isDarkMode ? Colors.amber[700]! : Colors.purple;
      case 'Platinum':
        return isDarkMode ? Colors.purple[400]! : Colors.deepPurple;
      default:
        return isDarkMode ? Colors.amber[700]! : Colors.purple;
    }
  }

  Color _getButtonTextColor(String membershipName, bool isDarkMode) {
    switch (membershipName) {
      case 'Silver':
        return Colors.black;
      case 'Gold':
        return isDarkMode ? Colors.black : Colors.white;
      case 'Platinum':
        return isDarkMode ? Colors.black : Colors.white;
      default:
        return isDarkMode ? Colors.black : Colors.white;
    }
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
