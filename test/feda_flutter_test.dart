import 'package:feda_flutter/src/exports/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // initialize FedaFlutter instance
  final feda = FedaFlutter(
    environment: ApiEnvironment.sandbox,
    apiKey: 'test_api_key',
  );

  test('FedaFlutter instance should be created', () {
    expect(feda.apiKey, 'test_api_key');
    expect(feda.environment, ApiEnvironment.sandbox);
  });
}
