import 'package:feda_flutter/src/exports/index.dart';

/// The main entry point for the `feda_flutter` SDK.
///
/// Use [applyConfig] once at app startup (typically in `main()`) to
/// initialize the singleton, then access repositories via [instance].
///
/// ## Example
///
/// ```dart
/// void main() {
///   FedaFlutter.applyConfig(
///     apiKey: 'your_api_key',
///     environment: ApiEnvironment.sandbox,
///   );
///   runApp(const MyApp());
/// }
///
/// // Later, anywhere in your app:
/// final res = await FedaFlutter.instance.transactions.createTransaction(...);
/// ```
class FedaFlutter {
  /// The FedaPay API key used to authenticate requests.
  final String apiKey;

  /// The environment (sandbox or live) this instance targets.
  final ApiEnvironment environment;

  late IDioService _api;

  static FedaFlutter? _instance;

  /// Returns the initialized [FedaFlutter] singleton.
  ///
  /// Throws an [Exception] if [applyConfig] has not been called yet.
  static FedaFlutter get instance {
    if (_instance == null) {
      throw Exception(
        "FedaFlutter is not initialized. Please call FedaFlutter.applyConfig() first.",
      );
    }
    return _instance!;
  }

  /// Initializes the [FedaFlutter] singleton with the given [apiKey] and
  /// [environment].
  ///
  /// Call this once in `main()` before using any repository.
  ///
  /// ```dart
  /// FedaFlutter.applyConfig(
  ///   apiKey: 'sk_sandbox_...',
  ///   environment: ApiEnvironment.sandbox,
  /// );
  /// ```
  static void applyConfig({
    required String apiKey,
    required ApiEnvironment environment,
  }) {
    _instance = FedaFlutter(apiKey: apiKey, environment: environment);
    _instance!.initialize();
  }

  /// Provides access to the [CustomersRepository] for managing FedaPay customers.
  CustomersRepository get customers => CustomersRepository(_api);

  /// Provides access to the [TransactionsRepository] for creating and managing
  /// FedaPay transactions.
  TransactionsRepository get transactions => TransactionsRepository(_api);

  /// Provides access to the [PayoutsRepository] for managing FedaPay payouts.
  PayoutsRepository get payouts => PayoutsRepository(_api);

  /// Creates a [FedaFlutter] instance. Prefer using [applyConfig] instead.
  FedaFlutter({required this.apiKey, required this.environment});

  /// Initializes the internal HTTP client. Called automatically by [applyConfig].
  void initialize() {
    _api = DioServiceImpl(environment, apiKey);
  }
}
