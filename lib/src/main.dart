import 'package:feda_flutter/src/exports/index.dart';
import 'package:feda_flutter/src/repositories/customer_repository.dart';
import 'package:feda_flutter/src/repositories/transactions_repository.dart';

class FedaFlutter {
  final String apiKey;
  final ApiEnvironment environment;
  late IDioService _api;

  CustomersRepository get customers => CustomersRepository(_api);

  TransactionsRepository get transactions => TransactionsRepository(_api);
  
  FedaFlutter({required this.apiKey, required this.environment});

  void initialize() async {
    _api = DioServiceImpl(environment, apiKey);
  }
}
