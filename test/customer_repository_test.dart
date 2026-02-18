import 'package:test/test.dart';
import 'package:feda_flutter/src/repositories/customer_repository.dart';
import 'package:feda_flutter/src/models/customers.dart';
import 'package:feda_flutter/src/models/customer_create.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';
import 'utils/fake_dio_service.dart';

void main() {
  // Generic sample customer JSON. Replace values as needed.
  final sampleCustomer = {
    'id': 1,
    'firstname': 'Jane',
    'lastname': 'Doe',
    'full_name': 'Jane Doe',
    'email': 'jane@example.com',
    'account_id': 123,
    'phone_number_id': 456,
    'created_at': DateTime.now().toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
    'deleted_at': null,
  };

  group('CustomersRepository', () {
    late CustomersRepository repo;

    setUp(() {
      final fake = FakeDioService({
        '/customers': [sampleCustomer],
        '/customers/1': sampleCustomer,
      });

      repo = CustomersRepository(fake);
    });

    test(
      'getCustomers returns a list of Customer wrapped in ApiResponse',
      () async {
        final res = await repo.getCustomers();

        expect(res, isA<ApiResponse<List<Customer>>>());
        expect(res.data, isNotNull);
        expect(res.data, isA<List<Customer>>());
        expect(res.data!.isNotEmpty, true);
      },
    );

    test(
      'getCustomer returns a single Customer wrapped in ApiResponse',
      () async {
        final res = await repo.getCustomer(1);

        expect(res, isA<ApiResponse<Customer>>());
        expect(res.data, isA<Customer>());
        expect(res.data!.id, 1);
      },
    );

    test('createCustomer accepts CustomerCreate DTO', () async {
      final dto = CustomerCreate(
        firstname: 'DTO',
        lastname: 'Test',
        email: 'dto@test.com',
        phoneNumber: PhoneNumber(number: '99887766', country: 'BJ'),
      );

      final fake = FakeDioService({
        '/customers': {
          ...sampleCustomer,
          'firstname': 'DTO',
          'lastname': 'Test',
        },
      });
      repo = CustomersRepository(fake);

      final res = await repo.createCustomer(dto);

      expect(res.data!.firstname, 'DTO');
      expect(res.data!.lastname, 'Test');
    });
  });
}
