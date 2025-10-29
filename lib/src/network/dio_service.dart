import 'package:feda_flutter/src/core/models/api_response.dart';

abstract class IDioService {
  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? query,
  });
  Future<ApiResponse<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<ApiResponse<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<ApiResponse<dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<ApiResponse<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
  });
}
