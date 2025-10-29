import 'package:feda_flutter/src/constants/index.dart';
import 'package:feda_flutter/src/models/customers.dart';
import 'package:feda_flutter/src/models/customer_create.dart';

import '../core/models/api_response.dart';
import 'base_repository.dart';

class CustomersRepository extends BaseRepository {
  CustomersRepository(super.client);

  /// Lister tous les customers
  Future<ApiResponse<List<Customer>>> getCustomers() async {
    return safeCall(() async {
      final res = await client.get(CUSTOMERS_BASE_PATH);
      final data = (res.data as List)
          .map((json) => Customer.fromJson(json))
          .toList();

      return ApiResponse<List<Customer>>(
        data: data,
        statusCode: res.statusCode,
      );
    });
  }

  /// Récupérer un customer par id
  Future<ApiResponse<Customer>> getCustomer(int id) async {
    return safeCall(() async {
      final res = await client.get("$CUSTOMERS_BASE_PATH/$id");
      final customer = Customer.fromJson(res.data);
      return ApiResponse<Customer>(data: customer, statusCode: res.statusCode);
    });
  }

  /// Créer un customer
  ///
  /// Accepts either a [CustomerCreate] DTO or a raw `Map<String, dynamic>`
  /// payload. If passed a DTO it will be converted to the API shape
  /// (nested `phone_number`).
  Future<ApiResponse<Customer>> createCustomer(dynamic data) async {
    return safeCall(() async {
      final payload = data is CustomerCreate
          ? data.toJson()
          : data as Map<String, dynamic>;
      final res = await client.post(CUSTOMERS_BASE_PATH, data: payload);
      final customer = Customer.fromJson(res.data);
      return ApiResponse<Customer>(data: customer, statusCode: res.statusCode);
    });
  }

  /// Mettre à jour un customer
  ///
  /// Accepts either a [CustomerCreate] DTO or a raw `Map<String, dynamic>`
  /// payload. If passed a DTO it will be converted to the API shape
  /// (nested `phone_number`).
  Future<ApiResponse<Customer>> updateCustomer(int id, dynamic data) async {
    return safeCall(() async {
      final payload = data is CustomerCreate
          ? data.toJson()
          : data as Map<String, dynamic>;
      final res = await client.put('$CUSTOMERS_BASE_PATH/$id', data: payload);
      final customer = Customer.fromJson(res.data);
      return ApiResponse<Customer>(data: customer, statusCode: res.statusCode);
    });
  }

  /// Supprimer un customer
  Future<ApiResponse<dynamic>> deleteCustomer(int id) async {
    return safeCall(() async {
      return await client.delete("$CUSTOMERS_BASE_PATH/$id");
    });
  }
}
