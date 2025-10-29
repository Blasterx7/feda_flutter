import 'package:dio/dio.dart';
import 'package:feda_flutter/src/core/env/api_environment.dart';
import 'package:feda_flutter/src/core/exceptions/network_exception.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/network/dio_service.dart';

class DioServiceImpl implements IDioService {
  final Dio _dio;

  Dio get client => _dio;

  DioServiceImpl(ApiEnvironment environment, String apiKey)
    : _dio = Dio(
        BaseOptions(
          baseUrl: environment.baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {"Authorization": "Bearer $apiKey"},
        ),
      ) {
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true, error: true),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Exemple : ajouter un header custom pour toutes les requêtes
          options.headers['X-App-Version'] = '1.0.0';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Exemple : traitement global des réponses
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: NetworkException(e.message ?? "An error occurred"),
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    ]);
  }

  @override
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get(endpoint, queryParameters: query);
      return ApiResponse<dynamic>(data: res.data, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _dio.post(endpoint, data: data);
      return ApiResponse<dynamic>(data: res.data, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final res = await _dio.put(endpoint, data: data);
      return ApiResponse<dynamic>(data: res.data, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> patch(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _dio.patch(endpoint, data: data);
      return ApiResponse<dynamic>(data: res.data, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _dio.delete(endpoint, data: data);
      return ApiResponse<dynamic>(data: res.data, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  NetworkException _handleError(dynamic e) {
    String message = "Unexpected error";

    if (e is DioException) {
      message =
          e.response?.data?["message"] ?? e.message ?? "Network request failed";
    }

    return NetworkException(message);
  }
}
