import 'package:feda_flutter/src/constants/index.dart';
import 'package:feda_flutter/src/models/payouts.dart';
import '../core/models/api_response.dart';
import 'base_repository.dart';

class PayoutsRepository extends BaseRepository {
  PayoutsRepository(super.client);

  /// List payouts (may return wrapped response with pagination meta)
  Future<ApiResponse<List<Payout>>> getPayouts() async {
    return safeCall(() async {
      final path = joinPath(PAYOUTS_BASE_PATH, 'search');
      final res = await client.get<Map<String, dynamic>>(path);
      final collection = PayoutCollection.fromApi(res.data);
      return ApiResponse<List<Payout>>(
          data: collection.payouts,
          statusCode: res.statusCode,
          meta: collection.meta?.toJson());
    });
  }

  /// Get a single payout by id
  Future<ApiResponse<Payout>> getPayout(int id) async {
    return safeCall(() async {
      final res = await client.get<Map<String, dynamic>>('$PAYOUTS_BASE_PATH/$id');
      final raw = normalizeApiData(res.data) as Map<String, dynamic>?;
      final payout = Payout.fromJson(raw ?? {});
      return ApiResponse<Payout>(data: payout, statusCode: res.statusCode);
    });
  }

  /// Create a payout
  Future<ApiResponse<Payout>> createPayout(Object data) async {
    return safeCall(() async {
      final payload =
          data is PayoutCreate ? data.toJson() : data as Map<String, dynamic>;
      final res = await client.post<Map<String, dynamic>>(PAYOUTS_BASE_PATH, data: payload);
      final raw = normalizeApiData(res.data) as Map<String, dynamic>?;
      final payout = Payout.fromJson(raw ?? {});
      return ApiResponse<Payout>(data: payout, statusCode: res.statusCode);
    });
  }

  /// Update a payout
  Future<ApiResponse<Payout>> updatePayout(int id, Object data) async {
    return safeCall(() async {
      final payload =
          data is PayoutCreate ? data.toJson() : data as Map<String, dynamic>;
      final res = await client.put<Map<String, dynamic>>('$PAYOUTS_BASE_PATH/$id', data: payload);
      final raw = normalizeApiData(res.data) as Map<String, dynamic>?;
      final payout = Payout.fromJson(raw ?? {});
      return ApiResponse<Payout>(data: payout, statusCode: res.statusCode);
    });
  }

  /// Delete a payout
  Future<ApiResponse<void>> deletePayout(int id) async {
    return safeCall(() async {
      final res = await client.delete<void>('$PAYOUTS_BASE_PATH/$id');
      return ApiResponse<void>(data: null, statusCode: res.statusCode);
    });
  }
}
