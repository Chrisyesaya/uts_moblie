import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text('Pilih Metode Pembayaran:', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    RadioListTile(
                      title: Text('Cash'),
                      value: 'cash',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value.toString();
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text('Total: \$${cartProvider.totalPrice.toStringAsFixed(0)}',
                         style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    cartProvider.clearCart();
                    Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Terima kasih, pesanan telah kami terima')),
                    );
                  },
                  child: Text('Confirm'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}