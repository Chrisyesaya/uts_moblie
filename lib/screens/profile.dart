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
          behavior: SnackBarBehavior.floating,
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

  Widget _buildUserInfoSection(
      AuthProvider auth, bool isDarkMode, Color primaryColor) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Informasi Pribadi',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Username
            _buildInfoRow(
              icon: Icons.account_circle,
              label: 'Username',
              value: auth.username ?? '-',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),

            // Jenis Kelamin
            _buildInfoRow(
              icon: Icons.person_outline,
              label: 'Jenis Kelamin',
              value: auth.gender ?? '-',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),

            // Tanggal Lahir
            _buildInfoRow(
              icon: Icons.cake,
              label: 'Tanggal Lahir',
              value: auth.birthDate != null
                  ? '${auth.birthDate!.day}/${auth.birthDate!.month}/${auth.birthDate!.year}'
                  : '-',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),

            // Alamat
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: secondaryTextColor),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.address ?? '-',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: textColor),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
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
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: secondaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== MEMBERSHIP =====================

  Widget _buildMembershipCard(membership, bool isDarkMode, Color primaryColor) {
    final cardColor = _getCardColor(membership.name, isDarkMode);
    final textColor = _getCardTextColor(membership.name);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _getCardImage(membership.name),
                  width: 80,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membership.name.toUpperCase(),
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${membership.duration} Bulan',
                      style:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: textColor.withOpacity(0.8),
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
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          ...membership.benefits.map(
            (benefit) => Padding(
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
                      style: TextStyle(color: textColor, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
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
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.credit_card_off,
                size: 60, color: isDarkMode ? Colors.grey : Colors.grey[600]),
            const SizedBox(height: 16),
            Text('Belum memiliki membership',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ===================== MAIN BUILD =====================

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final auth = Provider.of<AuthProvider>(context);
    final membership = auth.userMembership;
    final facilities = auth.extraFacilities;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Profil', style: TextStyle(color: onPrimaryColor)),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: onPrimaryColor),
      ),
      body: auth.isLoggedIn
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Foto Profil
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
                                color: primaryColor, shape: BoxShape.circle),
                            child: Icon(Icons.camera_alt,
                                size: 20, color: onPrimaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(auth.username ?? 'User',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: isDarkMode ? Colors.white : Colors.black)),
                  const SizedBox(height: 24),

                  _buildUserInfoSection(auth, isDarkMode, primaryColor),
                  const SizedBox(height: 20),

                  if (membership == null)
                    _buildNoMembership(isDarkMode, primaryColor)
                  else
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Detail Membership:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: primaryColor)),
                        ),
                        const SizedBox(height: 12),
                        _buildMembershipCard(
                            membership, isDarkMode, primaryColor),
                        const SizedBox(height: 20),
                        if (facilities.isNotEmpty) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Fasilitas Tambahan:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: primaryColor)),
                          ),
                          const SizedBox(height: 12),
                          _buildAdditionalFacilities(
                              facilities, isDarkMode, primaryColor),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                ],
              ),
            )
          : Center(
              child: Text("Silakan login terlebih dahulu",
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black))),
    );
  }

  // ===================== HELPER CARD COLOR =====================
  Color _getCardColor(String name, bool isDarkMode) {
    switch (name.toLowerCase()) {
      case 'gold':
        return isDarkMode ? Colors.amber[700]! : Colors.amber[600]!;
      case 'platinum':
        return isDarkMode ? Colors.blueGrey[700]! : Colors.blueGrey[500]!;
      case 'silver':
        return isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
      default:
        return isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
    }
  }

  Color _getCardTextColor(String name) {
    switch (name.toLowerCase()) {
      case 'gold':
        return Colors.black;
      case 'platinum':
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  String _getCardImage(String name) {
    switch (name.toLowerCase()) {
      case 'gold':
        return 'assets/gold.png';
      case 'platinum':
        return 'assets/platinum.png';
      case 'silver':
        return 'assets/silver.png';
      default:
        return 'assets/silver.png';
    }
  }
}
