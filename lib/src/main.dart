import 'package:feda_flutter/src/exports/index.dart';

class FedaFlutter {
  final String apiKey;
  final ApiEnvironment environment;
  late IDioService _api;

  static FedaFlutter? _instance;

  static FedaFlutter get instance {
    if (_instance == null) {
      throw Exception(
        "FedaFlutter is not initialized. Please call FedaFlutter.applyConfig() first.",
      );
    }
    return _instance!;
  }

  static void applyConfig({
    required String apiKey,
    required ApiEnvironment environment,
  }) {
    _instance = FedaFlutter(apiKey: apiKey, environment: environment);
    _instance!.initialize();
  }

  CustomersRepository get customers => CustomersRepository(_api);

  TransactionsRepository get transactions => TransactionsRepository(_api);

  FedaFlutter({required this.apiKey, required this.environment});

  void initialize() {
    _api = DioServiceImpl(environment, apiKey);
  }
}
