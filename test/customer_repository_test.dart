import 'package:test/test.dart';
import 'package:feda_flutter/src/repositories/customer_repository.dart';
import 'package:feda_flutter/src/models/customers.dart';
import 'package:feda_flutter/src/network/dio_service.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';

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
    return ApiResponse<dynamic>(data: data, statusCode: 201);
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
  });
}
