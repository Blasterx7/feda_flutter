import 'package:feda_flutter/src/constants/index.dart';
import 'package:feda_flutter/src/models/transactions.dart';
import 'package:feda_flutter/src/network/dio_service_impl.dart';
import 'package:feda_flutter/src/core/exceptions/network_exception.dart';

import '../core/models/api_response.dart';
import 'base_repository.dart';

class TransactionsRepository extends BaseRepository {
  TransactionsRepository(super.client);

  /// Lister toutes les transactions
  Future<ApiResponse<List<Transaction>>> getTransactions() async {
    return safeCall(() async {
      // Build the search path safely (handles whether TRANSACTIONS_BASE_PATH
      // contains a trailing slash or not).
      final path = joinPath(TRANSACTIONS_BASE_PATH, 'search');
      final res = await client.get(path);
      // Use TransactionCollection to handle wrapped responses that include
      // a list under a key like "v1/transactions" and optional meta.
      final collection = TransactionCollection.fromApi(res.data);
      final data = collection.transactions;

      return ApiResponse<List<Transaction>>(
        data: data,
        statusCode: res.statusCode,
        meta: collection.meta?.toJson(),
      );
    });
  }

  /// Récupérer une transaction par id
  Future<ApiResponse<Transaction>> getTransaction(int id) async {
    return safeCall(() async {
      final res = await client.get("$TRANSACTIONS_BASE_PATH/$id");
      final raw = normalizeApiData(res.data);
      final transaction = Transaction.fromJson(raw);
      return ApiResponse<Transaction>(
        data: transaction,
        statusCode: res.statusCode,
      );
    });
  }

  /// Récupérer le token de paiement pour une transaction
  /// Répond à : GET /transactions/{id}/token -> { token: string, url: string }
  Future<ApiResponse<TransactionToken>> getTransactionToken(int id) async {
    return safeCall(() async {
      final path = joinPath(TRANSACTIONS_BASE_PATH, '$id/token');
      final res = await client.get(path);
      final raw = normalizeApiData(res.data);
      final token = TransactionToken.fromJson(raw);
      return ApiResponse<TransactionToken>(
        data: token,
        statusCode: res.statusCode,
      );
    });
  }

  /// Créer une transaction
  ///
  /// Accepts either a [TransactionCreate] DTO or a raw `Map<String, dynamic>`
  /// payload. If passed a DTO it will be converted to the API shape.
  Future<ApiResponse<Transaction>> createTransaction(dynamic data) async {
    return safeCall(() async {
      final payload = data is TransactionCreate
          ? data.toJson()
          : data as Map<String, dynamic>;
      final res = await client.post(TRANSACTIONS_BASE_PATH, data: payload);
      final raw = normalizeApiData(res.data);
      final transaction = Transaction.fromJson(raw);
      return ApiResponse<Transaction>(
        data: transaction,
        statusCode: res.statusCode,
      );
    });
  }

  /// Perform a direct payment using an existing transaction token.
  /// The Fedapay API requires this to be executed against the live API.
  ///
  /// The method accepts a [TransactionDirectPayment] DTO or a raw map.
  Future<ApiResponse<Transaction>> directPayment(
    dynamic data, {
    String mode = 'moov',
  }) async {
    return safeCall(() async {
      // If we have a concrete DioServiceImpl we can check the baseUrl to
      // ensure we're hitting the live API. Fake or test clients will not be
      // DioServiceImpl and will therefore be allowed (so tests can run).
      final isLive = client is DioServiceImpl
          ? (client as DioServiceImpl).client.options.baseUrl.startsWith(
                FEDA_API_URL,
              )
          : true;

      if (!isLive) {
        throw NetworkException(
          'directPayment is only allowed when using the live API environment',
        );
      }

      final payload = data is TransactionDirectPayment
          ? data.toJson()
          : data as Map<String, dynamic>;

      final path = '$TRANSACTIONS_BASE_PATH?mode=$mode';
      final res = await client.post(path, data: payload);
      final raw = normalizeApiData(res.data);
      final transaction = Transaction.fromJson(raw);
      return ApiResponse<Transaction>(
        data: transaction,
        statusCode: res.statusCode,
      );
    });
  }

  /// Mettre à jour une transaction
  ///
  /// Accepts either a [TransactionCreate] DTO or a raw `Map<String, dynamic>`
  /// payload.
  Future<ApiResponse<Transaction>> updateTransaction(
    int id,
    dynamic data,
  ) async {
    return safeCall(() async {
      final payload = data is TransactionCreate
          ? data.toJson()
          : data as Map<String, dynamic>;
      final res = await client.put(
        '$TRANSACTIONS_BASE_PATH/$id',
        data: payload,
      );
      final raw = normalizeApiData(res.data);
      final transaction = Transaction.fromJson(raw);
      return ApiResponse<Transaction>(
        data: transaction,
        statusCode: res.statusCode,
      );
    });
  }

  /// Supprimer une transaction
  Future<ApiResponse<dynamic>> deleteTransaction(int id) async {
    return safeCall(() async {
      return await client.delete("$TRANSACTIONS_BASE_PATH/$id");
    });
  }
}
