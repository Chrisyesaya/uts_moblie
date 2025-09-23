import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/membership_provider.dart';
import '../providers/cart_provider.dart';
import '../models/membership.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Consumer<MembershipProvider>(
        builder: (context, membershipProvider, child) {
          return ListView.builder(
            itemCount: membershipProvider.memberships.length,
            itemBuilder: (context, index) {
              final membership = membershipProvider.memberships[index];
              return MembershipCard(membership: membership);
            },
          );
        },
      ),
    );
  }
}

class MembershipCard extends StatelessWidget {
  final Membership membership;

  const MembershipCard({required this.membership});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          // Placeholder untuk gambar
          Container(
            height: 150,
            color: Colors.grey[300],
            child: Icon(Icons.fitness_center, size: 50),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(membership.name, style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 10),
                Text(membership.description),
                SizedBox(height: 10),
                Text('\$${membership.price.toStringAsFixed(0)}', 
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(membership);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${membership.name} added to cart')),
                    );
                  },
                  child: Text('Pilih Membership'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}