import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.updateProfileImage(pickedFile.path);
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileImage(AuthProvider auth, bool isDarkMode) {
    if (auth.profileImage == null) {
      return Icon(
        Icons.person,
        size: 60,
        color: isDarkMode ? Colors.white : Colors.black54,
      );
    }

    if (kIsWeb) {
      return Icon(
        Icons.person,
        size: 60,
        color: isDarkMode ? Colors.white : Colors.black54,
      );
    } else {
      return auth.profileImageFile != null
          ? Image.file(auth.profileImageFile!, fit: BoxFit.cover)
          : Icon(
              Icons.person,
              size: 60,
              color: isDarkMode ? Colors.white : Colors.black54,
            );
    }
  }

  Widget _buildUserInfo(AuthProvider auth, bool isDarkMode, Color primaryColor) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black87;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;

    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Pribadi',
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Username', auth.username ?? '-', Icons.person,
                textColor, secondaryTextColor),
            _buildInfoRow('Jenis Kelamin', auth.gender ?? '-', Icons.people,
                textColor, secondaryTextColor),
            _buildInfoRow(
              'Tanggal Lahir',
              auth.birthDate != null
                  ? '${auth.birthDate!.day}/${auth.birthDate!.month}/${auth.birthDate!.year}'
                  : '-',
              Icons.cake,
              textColor,
              secondaryTextColor,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.home, color: primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alamat',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        auth.address ?? '-',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      Color textColor, Color secondaryTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(
      membership, bool isDarkMode, Color primaryColor) {
    final Map<String, Map<String, dynamic>> membershipStyles = {
      'gold': {
        'colorLight': const Color(0xFFFFD700),
        'colorDark': const Color(0xFFB8860B),
        'textColor': Colors.black,
        'image': 'assets/gold.png',
      },
      'platinum': {
        'colorLight': const Color(0xFFB0C4DE),
        'colorDark': const Color(0xFF2F4F4F),
        'textColor': Colors.white,
        'image': 'assets/platinum.png',
      },
      'silver': {
        'colorLight': const Color(0xFFC0C0C0),
        'colorDark': const Color(0xFF808080),
        'textColor': Colors.black,
        'image': 'assets/silver.png',
      },
    };

    final style = membershipStyles[membership.name.toLowerCase()] ??
        membershipStyles['silver']!;
    final cardColor = isDarkMode ? style['colorDark'] : style['colorLight'];
    final textColor = style['textColor'];
    final imagePath = style['image'];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 50,
                    color: Colors.white,
                    child: Icon(Icons.credit_card, color: textColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membership.name.toUpperCase(),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${membership.duration} Bulan',
                      style: TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: textColor.withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(
            'Fasilitas yang didapat:',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          ...membership.benefits.map((benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✓ ',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        benefit,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAdditionalFacilities(
      List<Map<String, dynamic>> facilities, bool isDarkMode, Color primaryColor) {
    return Column(
      children: facilities
          .map((facility) => Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        facility['name'] ?? '',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildNoMembership(bool isDarkMode, Color primaryColor) {
    return Column(
      children: [
        Icon(Icons.credit_card_off,
            size: 60, color: isDarkMode ? Colors.grey : Colors.grey[600]),
        const SizedBox(height: 16),
        Text(
          'Belum memiliki membership',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan lakukan checkout untuk mendapatkan membership',
          style: TextStyle(
            color: isDarkMode ? Colors.grey : Colors.grey[600],
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showLogoutDialog(bool isDarkMode, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Logout',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin logout?',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[600],
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final auth = Provider.of<AuthProvider>(context);

    final membership = auth.userMembership;
    final facilities = auth.extraFacilities;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 3),
                  ),
                  child: ClipOval(child: _buildProfileImage(auth, isDarkMode)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              auth.username ?? 'User',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 24),
            _buildUserInfo(auth, isDarkMode, primaryColor),
            const SizedBox(height: 20),
            if (membership == null)
              _buildNoMembership(isDarkMode, primaryColor)
            else
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Detail Membership:',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMembershipCard(membership, isDarkMode, primaryColor),
                  const SizedBox(height: 20),
                  if (facilities.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fasilitas Tambahan:',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAdditionalFacilities(
                        facilities, isDarkMode, primaryColor),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(isDarkMode, primaryColor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}