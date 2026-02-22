import 'package:app/pages/failed.dart';
import 'package:app/pages/success.dart';
import 'package:feda_flutter/feda_flutter.dart';
import 'package:flutter/material.dart';

class PaymentWithToken extends StatelessWidget {
  final String token;

  const PaymentWithToken({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment (Frontend Only)'),
      ),
      body: PayWidget(
        transactionToken: token,
        onPaymentFailed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const FailedPay()),
        ),
        onPaymentSuccess: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const SuccessPay()),
        ),
      ),
    );
  }
}
