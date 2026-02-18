import 'package:test/test.dart';
import 'package:feda_flutter/src/repositories/payouts_repository.dart';
import 'package:feda_flutter/src/models/payouts.dart';
import 'package:feda_flutter/src/models/customer_create.dart';
import 'package:feda_flutter/src/models/transactions.dart'; // For CurrencyIso
import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/constants/index.dart';
import 'utils/fake_dio_service.dart';

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
      final listKey = PAYOUTS_BASE_PATH.endsWith('/')
          ? '${PAYOUTS_BASE_PATH}search'
          : '$PAYOUTS_BASE_PATH/search';
      final getKey = PAYOUTS_BASE_PATH.endsWith('/')
          ? '${PAYOUTS_BASE_PATH}123'
          : '$PAYOUTS_BASE_PATH/123';

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

    test('createPayout accepts PayoutCreate DTO', () async {
      final dto = PayoutCreate(
        amount: 3000,
        currency: CurrencyIso(iso: 'XOF'),
        customer: CustomerCreate(
          firstname: 'Payout',
          lastname: 'Receiver',
          email: 'payout@test.com',
          phoneNumber: PhoneNumber(number: '221770000000', country: 'SN'),
        ),
        mode: 'moov',
      );

      final fake = FakeDioService({
        // Echo creation for payout doesn't usually return the exact same object shape
        // as the input but simplified for testing:
        PAYOUTS_BASE_PATH: {...samplePayout, 'amount': 3000, 'mode': 'moov'},
      });
      repo = PayoutsRepository(fake);

      final res = await repo.createPayout(dto);
      expect(res, isA<ApiResponse<Payout>>());
      expect(res.data, isA<Payout>());
      expect(res.data!.amount, 3000);
      expect(res.data!.mode, 'moov');
    });
  });
}
