import 'package:test/test.dart';
import 'package:feda_flutter/src/repositories/transactions_repository.dart';
import 'package:feda_flutter/src/models/transactions.dart';
import 'package:feda_flutter/src/models/customer_create.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/constants/index.dart';
import 'utils/fake_dio_service.dart';

void main() {
  final now = DateTime.now().toIso8601String();

  final sampleTransaction = {
    'id': 1,
    'reference': 'ref_123',
    'amount': 4200,
    'description': 'Test payment',
    'callback_url': 'https://example.com/callback',
    'status': 'pending',
    'customer_id': 2,
    'currency_id': 1,
    'mode': 'card',
    'metadata': {},
    'commission': 10,
    'fees': 5,
    'fixed_commission': 0,
    'amount_transferred': 4185,
    'created_at': now,
    'updated_at': now,
    'approved_at': null,
    'canceled_at': null,
    'declined_at': null,
    'refunded_at': null,
    'transferred_at': null,
    'deleted_at': null,
    'last_error_code': null,
    'custom_metadata': {},
    'amount_debited': 4200,
    'receipt_url': null,
    'payment_method_id': null,
    'sub_accounts_commissions': [],
    'transaction_key': 'tk_123',
    'merchant_reference': 'mref_1',
    'account_id': 5,
    'balance_id': 6,
  };

  group('TransactionsRepository', () {
    late TransactionsRepository repo;

    setUp(() {
      final listKey = TRANSACTIONS_BASE_PATH.endsWith('/')
          ? '${TRANSACTIONS_BASE_PATH}search'
          : '$TRANSACTIONS_BASE_PATH/search';
      final getKey = TRANSACTIONS_BASE_PATH.endsWith('/')
          ? '${TRANSACTIONS_BASE_PATH}1'
          : '$TRANSACTIONS_BASE_PATH/1';

      final fake = FakeDioService({
        listKey: [sampleTransaction],
        getKey: sampleTransaction,
      });

      repo = TransactionsRepository(fake);
    });

    test(
      'getTransactions returns a list of Transaction wrapped in ApiResponse',
      () async {
        final res = await repo.getTransactions();

        expect(res, isA<ApiResponse<List<Transaction>>>());
        expect(res.data, isNotNull);
        expect(res.data, isA<List<Transaction>>());
        expect(res.data!.isNotEmpty, true);
      },
    );

    test(
      'getTransaction returns a single Transaction wrapped in ApiResponse',
      () async {
        final res = await repo.getTransaction(1);

        expect(res, isA<ApiResponse<Transaction>>());
        expect(res.data, isA<Transaction>());
        expect(res.data!.id, 1);
        expect(res.data!.reference, 'ref_123');
      },
    );

    test('createTransaction accepts a Map payload', () async {
      final payload = {
        'id': 2,
        'description': 'Create test',
        'amount': 100,
        'currency': {'iso': 'XOF'},
      };

      final res = await repo.createTransaction(payload);

      expect(res, isA<ApiResponse<Transaction>>());
      expect(res.data!.id, 2);
      expect(res.data!.description, 'Create test');
    });

    test('createTransaction accepts a TransactionCreate DTO', () async {
      final dto = TransactionCreate(
        description: 'DTO Test',
        amount: 5000,
        currency: CurrencyIso(iso: 'XOF'),
        customer: CustomerCreate(
          firstname: 'John',
          lastname: 'Doe',
          email: 'john@doe.com',
          phoneNumber: PhoneNumber(number: '123456', country: 'BJ'),
        ),
      );

      // FakeDioService echoes the payload.
      // We expect the repo converts DTO -> JSON -> sends to FakeDio -> echoes back -> normalized -> Transaction
      // Since sampleTransaction has 'id', but echo won't unless we mock it specifically or the normalize handles it.
      // normalizeApiData just returns data if it's a map.
      // Transaction.fromJson handles missing 'id' (defaults to 0).

      final res = await repo.createTransaction(dto);

      expect(res, isA<ApiResponse<Transaction>>());
      expect(res.data!.description, 'DTO Test');
      expect(res.data!.amount, 5000);
      // id defaults to 0 if not present in echo
      expect(res.data!.id, 0);
    });

    test('directPayment accepts a TransactionDirectPayment DTO', () async {
      final path = '$TRANSACTIONS_BASE_PATH?mode=mtn';
      final fake = FakeDioService({
        // Mock response for direct payment
        path: {
          ...sampleTransaction,
          'payment_token': 'pay_token_123',
          'payment_url': 'https://pay.com/123',
        },
      });
      repo = TransactionsRepository(fake);

      final dto = TransactionDirectPayment(
        currency: CurrencyIso(iso: 'XOF'),
        description: 'Direct Payment DTO',
        amount: 2000,
        token: 'tk_123',
        phoneNumber: PhoneNumber(number: '654321', country: 'BJ'),
      );

      final res = await repo.directPayment(dto, mode: 'mtn');

      expect(res.data!.paymentToken, 'pay_token_123');
      expect(res.data!.paymentUrl, 'https://pay.com/123');
    });
  });
}
