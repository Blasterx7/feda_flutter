/// The `feda_flutter` library provides a Dart/Flutter SDK for integrating
/// [FedaPay](https://fedapay.com) payments into your mobile application.
///
/// ## Getting started
///
/// ### 1. Frontend-only Integration (Recommended for Production)
/// For maximum security, do not embed your FedaPay secret key in your app.
/// Create transactions from your backend, fetch the transaction token, and
/// pass it directly to `PayWidget`:
///
/// ```dart
/// PayWidget(
///   transactionToken: 'token_from_your_backend',
///   onPaymentSuccess: () => print('Success!'),
///   onPaymentFailed: () => print('Failed!'),
/// )
/// ```
/// (No need to initialize `FedaFlutter` at startup).
///
/// ### 2. Full Integration (Prototyping / Internal apps)
/// If you need the SDK to create transactions directly, initialize the SDK
/// once at app startup with your secret key:
///
/// ```dart
/// FedaFlutter.applyConfig(
///   apiKey: 'sk_sandbox_your_key_here',
///   environment: ApiEnvironment.sandbox,
/// );
/// ```
///
/// Then access the repositories via the singleton:
///
/// ```dart
/// final res = await FedaFlutter.instance.transactions.createTransaction(...);
/// ```
library;

export 'package:feda_flutter/src/exports/index.dart';
