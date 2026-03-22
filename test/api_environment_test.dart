import 'package:feda_flutter/src/core/env/api_environment.dart';
import 'package:test/test.dart';

void main() {
  group('ApiEnvironment', () {
    test('baseUrl should end with a slash', () {
      expect(ApiEnvironment.sandbox.baseUrl, endsWith('v1/'));
      expect(ApiEnvironment.live.baseUrl, endsWith('v1/'));
    });

    test('baseUrl should be correctly constructed', () {
      expect(ApiEnvironment.sandbox.baseUrl, 'https://sandbox-api.fedapay.com/v1/');
      expect(ApiEnvironment.live.baseUrl, 'https://api.fedapay.com/v1/');
    });
  });
}
