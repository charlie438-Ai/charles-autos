import 'package:flutter/material.dart';

class PaymentOptionsSheet extends StatelessWidget {
  final double amount;

  const PaymentOptionsSheet({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Total Amount: \$${amount.toInt()}',
            style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildPaymentOption(context, Icons.account_balance, 'Bank Transfer', 'Direct wire transfer to Charles Autos'),
          _buildPaymentOption(context, Icons.money, 'Cash App', '\$CharlesAutos'),
          _buildPaymentOption(context, Icons.paypal, 'PayPal', 'charles_autos@gmail.com'),
          _buildPaymentOption(context, Icons.phone_android, 'Mobile Money', 'Available in select regions'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected $title as payment method.')),
          );
        },
      ),
    );
  }
}
