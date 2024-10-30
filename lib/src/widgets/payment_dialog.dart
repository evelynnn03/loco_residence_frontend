import 'package:flutter/material.dart';
import 'package:loco_frontend/src/widgets/pop_up_window.dart';

class PaymentMethodDialog extends StatelessWidget {
  final double amount;
  final Function onPaymentComplete;

  const PaymentMethodDialog({
    Key? key,
    required this.amount,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Amount to Pay: \$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),
            _PaymentOption(
              title: 'Credit/Debit Card',
              icon: Icons.credit_card,
              onTap: () => _showPaymentConfirmation(context),
            ),
            const SizedBox(height: 15),
            _PaymentOption(
              title: 'Google Pay',
              icon: Icons.g_mobiledata,
              onTap: () => _showPaymentConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context) {
    Popup(
      title: 'Confirm Payment',
      content: Text('Process payment of \$${amount.toStringAsFixed(2)}?'),
      buttons: [
        ButtonConfig(text: 'Cancel', onPressed: () => Navigator.pop(context)),
        ButtonConfig(
          text: 'Make Payment',
          onPressed: () {
            Navigator.pop(context); // Close confirmation dialog
            Navigator.pop(context); // Close payment method dialog
            onPaymentComplete();
          },
        ),
      ],
    ).show(context);
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
