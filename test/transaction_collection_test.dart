import 'package:test/test.dart';
import 'package:feda_flutter/src/models/transactions.dart';

void main() {
  test(
    'TransactionCollection.fromApi handles wrapped v1/transactions with meta',
    () {
      final payload = {
        'v1/transactions': [
          {
            'id': 373318,
            'reference': 'TX-1234',
            'amount': 5000,
            'description': 'Test',
            'customer_id': 70635,
            'created_at': '2023-10-10T12:00:00Z',
          },
        ],
        'meta': {
          'current_page': 1,
          'next_page': null,
          'prev_page': null,
          'per_page': 20,
          'total_pages': 1,
          'total_count': 1,
        },
      };

      final coll = TransactionCollection.fromApi(payload);
      expect(coll.transactions, isNotNull);
      expect(coll.transactions.length, 1);
      final t = coll.transactions.first;
      expect(t.id, 373318);
      expect(coll.meta, isNotNull);
      expect(coll.meta!.totalCount, 1);
    },
  );

  test('TransactionCollection.fromApi handles direct list', () {
    final payload = [
      {'id': 1, 'reference': 'A', 'amount': 100},
    ];

    final coll = TransactionCollection.fromApi(payload);
    expect(coll.transactions.length, 1);
    expect(coll.meta, isNull);
  });
}
