import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class CheckoutPage extends StatelessWidget {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Transfer Bank (BCA / Mandiri / BNI)', 'icon': Icons.account_balance},
    {'name': 'E-Wallet (GoPay, OVO, Dana)', 'icon': Icons.phone_iphone},
    {'name': 'Cash (Tunai)', 'icon': Icons.money},
  ];

  Color _getCardColor(String name, bool isDarkMode) {
    switch (name.toLowerCase()) {
      case 'silver':
        return isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
      case 'gold':
        return isDarkMode ? Colors.amber[700]! : Colors.amber[600]!;
      case 'platinum':
        return isDarkMode ? Colors.blueGrey[700]! : Colors.blueGrey[500]!;
      default:
        return isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
    }
  }

  Color _getCardTextColor(String name) {
    switch (name.toLowerCase()) {
      case 'silver':
        return Colors.black;
      case 'gold':
        return Colors.black;
      case 'platinum':
        return Colors.white;
      default:
        return Colors.black;
    }
  }

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
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: onPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final card = cartProvider.items.isNotEmpty ? cartProvider.items.first : null;
          final facilities = cartProvider.selectedFacilities;
          double total = cartProvider.totalPrice;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== KARTU MEMBERSHIP ======
                if (card != null)
                  Container(
                    decoration: BoxDecoration(
                      color: _getCardColor(card.name, isDarkMode),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/${card.name.toLowerCase()}.png',
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.credit_card, size: 60, color: _getCardTextColor(card.name)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card.name.toUpperCase(),
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      color: _getCardTextColor(card.name),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currencyFormat.format(card.price),
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: _getCardTextColor(card.name).withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${card.duration} Bulan',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: _getCardTextColor(card.name).withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: _getCardTextColor(card.name).withOpacity(0.3)),
                        Text(
                          'Fasilitas yang didapat:',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: _getCardTextColor(card.name),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...card.benefits.map<Widget>((f) => Row(
                              children: [
                                Icon(Icons.check, color: _getCardTextColor(card.name), size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    f, 
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: _getCardTextColor(card.name).withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // ====== FASILITAS TAMBAHAN ======
                Text(
                  'Fasilitas Tambahan:',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                ...facilities.map((f) => Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.star, color: primaryColor, size: 20),
                    title: Text(
                      f['name'], 
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                    ),
                    trailing: Text(
                      currencyFormat.format(f['price']),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),

                if (facilities.isEmpty)
                  Text(
                    'Tidak ada fasilitas tambahan',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),

                Divider(color: primaryColor.withOpacity(0.5), height: 30),

                // ====== METODE PEMBAYARAN ======
                Text(
                  'Pilih Metode Pembayaran:',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                _PaymentMethodSelector(
                  paymentMethods: paymentMethods,
                  isDarkMode: isDarkMode,
                  primaryColor: primaryColor,
                  onPrimaryColor: onPrimaryColor,
                  textColor: textColor,
                ),

                Divider(color: primaryColor.withOpacity(0.5), height: 30),

                // ====== TOTAL ======
                Container(
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
                        currencyFormat.format(total),
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ====== TOMBOL KONFIRMASI ======
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final paymentMethod = _PaymentMethodSelectorState.selectedPayment;
                      if (paymentMethod == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Silakan pilih metode pembayaran terlebih dahulu',
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

                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            'Konfirmasi Pembayaran',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: primaryColor,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (card != null)
                                Text(
                                  'Kartu: ${card.name.toUpperCase()} (${currencyFormat.format(card.price)})',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: textColor,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              if (facilities.isNotEmpty) ...[
                                Text(
                                  'Fasilitas Tambahan:',
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: primaryColor,
                                  ),
                                ),
                                ...facilities.map((f) => Text(
                                      '- ${f['name']} (${currencyFormat.format(f['price'])})',
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: textColor,
                                      ),
                                    )),
                              ],
                              const SizedBox(height: 10),
                              Text(
                                'Metode Pembayaran: $paymentMethod',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: textColor,
                                ),
                              ),
                              Divider(color: primaryColor.withOpacity(0.5)),
                              Text(
                                'Total: ${currencyFormat.format(total)}',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Batal', 
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // ✅ SIMPAN DATA KE AUTH PROVIDER
                                final authProvider =
                                    Provider.of<AuthProvider>(context, listen: false);
                                if (card != null) {
                                  authProvider.setMembership(card, facilities);
                                }

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pembayaran berhasil! 🎉',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                // ✅ Setelah bayar, kembali ke halaman sebelumnya
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Bayar Sekarang',
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  color: onPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: onPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Konfirmasi & Bayar',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ======= PEMILIH METODE PEMBAYARAN =======
class _PaymentMethodSelector extends StatefulWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final bool isDarkMode;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color textColor;

  const _PaymentMethodSelector({
    required this.paymentMethods,
    required this.isDarkMode,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.textColor,
  });

  @override
  State<_PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<_PaymentMethodSelector> {
  static String? selectedPayment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.paymentMethods.map((method) {
        bool isSelected = selectedPayment == method['name'];
        return GestureDetector(
          onTap: () {
            setState(() => selectedPayment = method['name']);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? widget.primaryColor 
                  : (widget.isDarkMode ? Colors.grey[800] : Colors.grey[100]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? widget.primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  method['icon'],
                  color: isSelected ? widget.onPrimaryColor : widget.textColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    method['name'],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected ? widget.onPrimaryColor : widget.textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: widget.onPrimaryColor),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}