import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/network/dio_service.dart';

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
    // If a canned response was provided for this endpoint use it,
    // otherwise fall back to echoing the provided payload (simulate
    // typical create behaviour in tests).
    final resp = _responses.containsKey(endpoint)
        ? _responses[endpoint]
        : (data ?? {});
    return ApiResponse<dynamic>(data: resp, statusCode: 201);
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
