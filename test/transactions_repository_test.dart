import 'package:test/test.dart';
import 'package:feda_flutter/src/repositories/transactions_repository.dart';
import 'package:feda_flutter/src/models/transactions.dart';
import 'package:feda_flutter/src/network/dio_service.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/constants/index.dart';

class FakeDioService implements IDioService {
  final Map<String, dynamic> _responses;

  FakeDioService(this._responses);

  @override
  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final data = _responses[endpoint];
    return ApiResponse<dynamic>(data: data, statusCode: 200);
  }

  @override
  Future<ApiResponse<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    // Simulate server returning created resource — if caller provided an
    // `id` in the payload we return it, otherwise return payload as-is.
    final resp = data ?? {};
    return ApiResponse<dynamic>(data: resp, statusCode: 201);
  }

  @override
  Future<ApiResponse<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    return ApiResponse<dynamic>(data: data, statusCode: 200);
  }

  @override
  Future<ApiResponse<dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    return ApiResponse<dynamic>(data: data, statusCode: 200);
  }

  @override
  Future<ApiResponse<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    return ApiResponse<dynamic>(data: null, statusCode: 204);
  }
}

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
      // Build keys the same way as repository (handle trailing slash if any)
      final listKey = TRANSACTIONS_BASE_PATH.endsWith('/')
          ? TRANSACTIONS_BASE_PATH + 'search'
          : TRANSACTIONS_BASE_PATH + '/search';
      final getKey = TRANSACTIONS_BASE_PATH.endsWith('/')
          ? TRANSACTIONS_BASE_PATH + '1'
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
      'getTransactions returns meta when API payload includes pagination',
      () async {
        final listKey = TRANSACTIONS_BASE_PATH.endsWith('/')
            ? TRANSACTIONS_BASE_PATH + 'search'
            : TRANSACTIONS_BASE_PATH + '/search';

        final wrapped = {
          'v1/transactions': [sampleTransaction],
          'meta': {
            'current_page': 1,
            'next_page': null,
            'prev_page': null,
            'per_page': 20,
            'total_pages': 1,
            'total_count': 1,
          },
        };

        final fakeWithMeta = FakeDioService({listKey: wrapped});
        final repoWithMeta = TransactionsRepository(fakeWithMeta);

        final res = await repoWithMeta.getTransactions();

        expect(res, isA<ApiResponse<List<Transaction>>>());
        expect(res.meta, isNotNull);
        expect(res.meta!['total_count'], 1);
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

    test(
      'createTransaction accepts a Map payload and returns Transaction-like result',
      () async {
        // Simulate a client create payload that includes an id (server response)
        final payload = {
          'id': 2,
          'description': 'Create test',
          'amount': 100,
          'currency': {'iso': 'XOF'},
          'callback_url': 'https://example.com/cb',
          'customer': {'id': 3},
        };

        final res = await repo.createTransaction(payload);

        expect(res, isA<ApiResponse<Transaction>>());
        expect(res.data, isA<Transaction>());
        expect(res.data!.id, 2);
        expect(res.data!.description, 'Create test');
      },
    );
  });
}
