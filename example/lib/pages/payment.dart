import 'package:feda_flutter/feda_flutter.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _fedaFlutter.initialize();
  }

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
