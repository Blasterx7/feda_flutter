import 'package:feda_flutter/src/core/models/api_response.dart';

abstract class IDioService {
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  });
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  });
}
