import 'package:feda_flutter/feda_flutter.dart';
import 'package:flutter/material.dart';

class Payment extends StatelessWidget {
  Payment({super.key});
  final TransactionCreate trans = TransactionCreate(
    description: "Nouvelle transaction pour le client x",
    amount: 2000,
    currency: CurrencyIso(iso: 'XOF'),
  );

  final FedaFlutter _fedaFlutter = FedaFlutter(
    apiKey: 'sk_sandbox_oRoKr1GM3bUyrI4x9m56UoUl',
    environment: ApiEnvironment.sandbox,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PayWidget(
        transactionToCreate: trans,
        onPaymentFailed: () {},
        onPaymentSuccess: () {},
        instance: _fedaFlutter,
      ),
    );
  }
}
