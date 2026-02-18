import 'package:feda_flutter/src/constants/index.dart';

/// The API environment to use for FedaPay requests.
///
/// Use [ApiEnvironment.sandbox] during development and testing.
/// Switch to [ApiEnvironment.live] for production.
///
/// ```dart
/// FedaFlutter.applyConfig(
///   apiKey: 'sk_sandbox_...',
///   environment: ApiEnvironment.sandbox,
/// );
/// ```
enum ApiEnvironment {
  /// Sandbox environment — no real money is moved.
  /// Use this for development and integration testing.
  sandbox,

  /// Live environment — real payments are processed.
  /// Only use this in production with a verified FedaPay account.
  live;

  /// Returns the base URL for this environment, including the API version path.
  String get baseUrl {
    switch (this) {
      case ApiEnvironment.sandbox:
        return FEDA_SANDBOX_API_URL + FEDA_API_VERSION_V1;
      case ApiEnvironment.live:
        return FEDA_API_URL + FEDA_API_VERSION_V1;
    }
  }
}
