import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? selectedFacility;

  final List<Map<String, dynamic>> facilities = [
    {'name': 'Kolam Renang', 'price': 200000},
    {'name': 'Billiard + Tenis Meja', 'price': 150000},
    {'name': 'Muaythai + Taekwondo', 'price': 300000},
    {'name': 'Badminton Court', 'price': 250000},
    {'name': 'Yoga Studio', 'price': 100000},
    {'name': 'Squash Court', 'price': 75000},
  ];

  // Formatter untuk ubah angka ke format Rupiah
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Keranjang',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: onPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: onPrimaryColor,
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final selectedCard = cartProvider.selectedCard;
          final selectedFacilities = cartProvider.selectedFacilities;
          double totalPrice = cartProvider.totalPrice;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ==== GAMBAR KARTU ====
                if (selectedCard != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Kartu Anda:',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/${selectedCard.trim().toLowerCase()}.png',
                          height: 250,
                          errorBuilder: (context, error, stackTrace) =>
                            Text(
                              '⚠️ Gambar tidak ditemukan di assets/',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${selectedCard.toUpperCase()} - ${currencyFormat.format(cartProvider.basePrice)}',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Belum ada kartu yang dipilih.',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ),

                Divider(color: primaryColor.withOpacity(0.5)), 

                // ==== FASILITAS TAMBAHAN ====
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambahkan Fasilitas:',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          hint: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Pilih Fasilitas Tambahan',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                          value: selectedFacility,
                          isExpanded: true,
                          dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: textColor,
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              final facility = facilities.firstWhere(
                                  (f) => f['name'] == value);
                              cartProvider.addFacility(facility);
                              setState(() => selectedFacility = null);
                            }
                          },
                          items: facilities
                              .map((f) => DropdownMenuItem<String>(
                                    value: f['name'],
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        '${f['name']} (+${currencyFormat.format(f['price'])})',
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // List fasilitas yang dipilih
                      if (selectedFacilities.isNotEmpty)
                        Text(
                          'Fasilitas Terpilih:',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: textColor,
                          ),
                        ),

                      ...selectedFacilities.map((f) => Card(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            f['name'],
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            currencyFormat.format(f['price']),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cartProvider.removeFacility(f);
                            },
                          ),
                        ),
                      )),
                    ],
                  ),
                ),

                Divider(color: primaryColor.withOpacity(0.5)), 

                // ==== TOTAL ====
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: textColor,
                          ),
                        ),
                        Text(
                          currencyFormat.format(totalPrice),
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==== TOMBOL AKSI ====
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tombol Hapus Pesanan
                      ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Konfirmasi',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              content: Text(
                                'Yakin ingin menghapus semua pesanan dan fasilitas tambahan?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    'Batal',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text(
                                    'Hapus',
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            cartProvider.clearCart();
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Semua pesanan dan fasilitas berhasil dihapus',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.red[700] : Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Hapus Pesanan',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),

                      // Tombol Checkout
                      ElevatedButton(
                        onPressed: () {
                          if (cartProvider.selectedCard == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Silakan pilih kartu terlebih dahulu',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          Navigator.pushNamed(context, '/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: onPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}