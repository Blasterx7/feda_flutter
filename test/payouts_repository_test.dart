import 'package:test/test.dart';
import 'package:feda_flutter/src/repositories/payouts_repository.dart';
import 'package:feda_flutter/src/models/payouts.dart';
import 'package:feda_flutter/src/network/dio_service.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/constants/index.dart';

class FakeDioService implements IDioService {
  final Map<String, dynamic> _responses;

  FakeDioService(this._responses);

  @override
  Future<ApiResponse<dynamic>> get(String endpoint, {Map<String, dynamic>? query}) async {
    final data = _responses[endpoint];
    return ApiResponse<dynamic>(data: data, statusCode: 200);
  }

  @override
  Future<ApiResponse<dynamic>> post(String endpoint, {Map<String, dynamic>? data}) async {
    final resp = _responses.containsKey(endpoint) ? _responses[endpoint] : (data ?? {});
    return ApiResponse<dynamic>(data: resp, statusCode: 201);
  }

  @override
  Future<ApiResponse<dynamic>> put(String endpoint, {Map<String, dynamic>? data}) async {
    return ApiResponse<dynamic>(data: data, statusCode: 200);
  }

  @override
  Future<ApiResponse<dynamic>> patch(String endpoint, {Map<String, dynamic>? data}) async {
    return ApiResponse<dynamic>(data: data, statusCode: 200);
  }

  @override
  Future<ApiResponse<dynamic>> delete(String endpoint, {Map<String, dynamic>? data}) async {
    return ApiResponse<dynamic>(data: null, statusCode: 204);
  }
}

void main() {
  final now = DateTime.now().toIso8601String();

  final samplePayout = {
    'id': 123,
    'reference': 'payout_123',
    'amount': 1500,
    'status': 'pending',
    'customer_id': 70635,
    'currency_id': 1,
    'mode': 'moov',
    'last_error_code': null,
    'commission': 0,
    'fees': 0,
    'fixed_commission': 0,
    'amount_transferred': null,
    'amount_debited': 1500,
    'created_at': now,
    'updated_at': now,
    'scheduled_at': null,
    'sent_at': null,
    'failed_at': null,
    'deleted_at': null,
    'metadata': {},
    'custom_metadata': {},
    'payment_method_id': null,
    'transaction_key': 'tk_abc',
    'merchant_reference': 'mref_1',
    'account_id': 6105,
    'balance_id': 42,
  };

  group('PayoutsRepository', () {
    late PayoutsRepository repo;

    setUp(() {
      final listKey = PAYOUTS_BASE_PATH.endsWith('/') ? '${PAYOUTS_BASE_PATH}search' : '$PAYOUTS_BASE_PATH/search';
      final getKey = PAYOUTS_BASE_PATH.endsWith('/') ? '${PAYOUTS_BASE_PATH}123' : '$PAYOUTS_BASE_PATH/123';

      final fake = FakeDioService({
        listKey: [samplePayout],
        getKey: samplePayout,
      });

      repo = PayoutsRepository(fake);
    });

    test('getPayouts returns list of payouts', () async {
      final res = await repo.getPayouts();
      expect(res, isA<ApiResponse<List<Payout>>>());
      expect(res.data, isNotNull);
      expect(res.data!.length, 1);
      expect(res.data!.first.id, 123);
    });

    test('getPayout returns a single payout', () async {
      final res = await repo.getPayout(123);
      expect(res, isA<ApiResponse<Payout>>());
      expect(res.data, isA<Payout>());
      expect(res.data!.id, 123);
      expect(res.data!.reference, 'payout_123');
    });

    test('createPayout accepts PayoutCreate and returns created payout', () async {
      final payload = {
        'amount': 2000,
        'currency': {'iso': 'XOF'},
        'customer': {
          'firstname': 'John',
          'lastname': 'Doe',
          'email': 'john@example.com',
          'phone_number': {'number': '221771234567', 'country': 'SN'},
        },
        'mode': 'moov',
      };

      final res = await repo.createPayout(payload);
      expect(res, isA<ApiResponse<Payout>>());
      expect(res.data, isA<Payout>());
      expect(res.data!.amount, 2000);
    });
  });
}
