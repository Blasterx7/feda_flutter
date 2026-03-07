import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/network/dio_service.dart';

class FakeDioService implements IDioService {
  final Map<String, dynamic> _responses;

  FakeDioService(this._responses);

  @override
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final data = _responses[endpoint];
    return ApiResponse<T>(data: data as T?, statusCode: 200);
  }

  @override
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    // If a canned response was provided for this endpoint use it,
    // otherwise fall back to echoing the provided payload (simulate
    // typical create behaviour in tests).
    final resp = _responses.containsKey(endpoint)
        ? _responses[endpoint]
        : (data ?? {});
    return ApiResponse<T>(data: resp as T?, statusCode: 201);
  }

  @override
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    return ApiResponse<T>(data: data as T?, statusCode: 200);
  }

  @override
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    return ApiResponse<T>(data: data as T?, statusCode: 200);
  }

  @override
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    return ApiResponse<T>(data: null, statusCode: 204);
  }
}
