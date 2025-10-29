import 'package:feda_flutter/src/core/exceptions/network_exception.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';

import '../network/dio_service.dart';

abstract class BaseRepository {
  final IDioService client;
  BaseRepository(this.client);

  NetworkException _handleError(dynamic e) {
    return e is NetworkException
        ? e
        : NetworkException("Unexpected repository error");
  }

  /// Safe call wrapper for repository actions.
  ///
  /// Accepts an action that may return either a raw value `T` or an
  /// `ApiResponse<T>`. If the action returns a raw `T`, it will be wrapped
  /// into an `ApiResponse<T>` with a null `statusCode`. If the action
  /// already returns `ApiResponse<T>`, it will be returned as-is.
  Future<ApiResponse<T>> safeCall<T>(Future<dynamic> Function() action) async {
    try {
      final result = await action();

      if (result is ApiResponse<T>) {
        return result;
      }

      // Wrap raw result into ApiResponse<T>
      return ApiResponse<T>(data: result as T?, statusCode: null);
    } catch (e) {
      throw _handleError(e);
    }
  }
}
