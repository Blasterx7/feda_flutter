import 'package:feda_flutter/src/exports/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FedaFlutter instance should be created', () {
    FedaFlutter.applyConfig(
      environment: ApiEnvironment.sandbox,
      apiKey: 'test_api_key',
    );
    final feda = FedaFlutter.instance;
    expect(feda.apiKey, 'test_api_key');
    expect(feda.environment, ApiEnvironment.sandbox);
  });
}
