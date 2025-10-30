import 'package:feda_flutter/src/core/exceptions/network_exception.dart';
import 'package:flutter/material.dart';
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
      debugPrint("BaseRepository: safeCall error: ${e.toString()}");
      throw _handleError(e);
    }
  }

  /// Normalize API payloads.
  /// Some Fedapay endpoints return a wrapped JSON like {"v1/customers": [...]}
  /// or {"v1/customer": {...}}. This helper unwraps a single-key map to its
  /// inner value so repositories can handle both wrapped and unwrapped shapes.
  @protected
  dynamic normalizeApiData(dynamic data) {
    if (data is Map && data.length == 1) {
      try {
        final key = data.keys.first;
        final value = data.values.first;
        // Debug info for wrapped responses
        // ignore: avoid_print
        print(
          'BaseRepository: unwrapped API payload key="$key" -> ${value.runtimeType}',
        );
        return value;
      } catch (_) {
        return data;
      }
    }
    return data;
  }

  /// Safely join a base path and a suffix (eg. base="/transactions" and
  /// suffix="search" -> "/transactions/search"). This avoids duplicating
  /// or missing slashes regardless of whether `base` already contains a
  /// trailing slash.
  @protected
  String joinPath(String base, String suffix) {
    if (base.endsWith('/')) return '$base$suffix';
    return '$base/$suffix';
  }
}
