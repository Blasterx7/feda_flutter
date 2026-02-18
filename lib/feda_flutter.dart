/// The `feda_flutter` library provides a Dart/Flutter SDK for integrating
/// [FedaPay](https://fedapay.com) payments into your mobile application.
///
/// ## Getting started
///
/// Initialize the SDK once at app startup:
///
/// ```dart
/// FedaFlutter.applyConfig(
///   apiKey: 'your_api_key',
///   environment: ApiEnvironment.sandbox,
/// );
/// ```
///
/// Then access the repositories via the singleton:
///
/// ```dart
/// final tx = await FedaFlutter.instance.transactions.createTransaction(...);
/// ```
///
/// See the [FedaFlutter] class for full usage details.
library;

export 'package:feda_flutter/src/exports/index.dart';
