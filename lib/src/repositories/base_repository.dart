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

  Future<ApiResponse<dynamic>> safeCall(
    Future<ApiResponse<dynamic>> Function() action,
  ) async {
    try {
      return await action();
    } catch (e) {
      throw _handleError(e);
    }
  }
}
