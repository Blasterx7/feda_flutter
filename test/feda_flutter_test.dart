import 'package:feda_flutter/src/core/env/api_environment.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:feda_flutter/feda_flutter.dart';

void main() {
  // initialize FedaFlutter instance
  final feda = FedaFlutter(
    apiKey: 'test_api_key',
    environment: ApiEnvironment.sandbox,
  );

  test('FedaFlutter instance should be created', () {
    expect(feda.apiKey, 'test_api_key');
    expect(feda.environment, ApiEnvironment.sandbox);
  });
}
