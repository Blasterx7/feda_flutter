import 'package:dio/dio.dart';
import 'package:feda_flutter/src/core/env/api_environment.dart';
import 'package:feda_flutter/src/core/exceptions/network_exception.dart';
import 'package:feda_flutter/src/core/models/api_response.dart';
import 'package:feda_flutter/src/network/dio_service.dart';
import 'package:flutter/widgets.dart';

class DioServiceImpl implements IDioService {
  final Dio _dio;

  Dio get client => _dio;

  void _safeLog(String message, String? secret) {
    if (secret == null || secret.isEmpty) {
      debugPrint(message);
      return;
    }
    final maskedKey = secret.replaceRange(
      secret.length > 8 ? secret.length - 8 : 0,
      secret.length,
      '********',
    );
    debugPrint(message.replaceAll(secret, maskedKey));
  }

  /// Mode Direct — utilise une clé API FedaPay directement.
  DioServiceImpl(ApiEnvironment environment, String? apiKey)
      : _dio = Dio(
          BaseOptions(
            baseUrl: environment.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: apiKey != null && apiKey.isNotEmpty
                ? {"Authorization": "Bearer $apiKey"}
                : {},
          ),
        ) {
    _addInterceptors(apiKey);
  }

  /// Mode Cloud Proxy — toutes les requêtes passent par ash-bwallet.
  ///
  /// Le SDK injecte automatiquement :
  /// - `x-feda-project-key` : identifie le projet (ash-bwallet résout la clé FedaPay)
  /// - `x-feda-env` : 'sandbox' ou 'live'
  ///
  /// Aucune clé FedaPay n'est exposée côté client.
  DioServiceImpl.cloudProxy({
    required String cloudUrl,
    required String projectKey,
    required ApiEnvironment environment,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: cloudUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {
              'x-feda-project-key': projectKey,
              'x-feda-env': environment == ApiEnvironment.live ? 'live' : 'sandbox',
            },
          ),
        ) {
    _addInterceptors(null);
  }

  void _addInterceptors(String? secretToMask) {
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        logPrint: (obj) => _safeLog(obj.toString(), secretToMask),
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-App-Version'] = '2.0.0';
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
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
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await _dio.get(endpoint, queryParameters: query);
      return ApiResponse<T>(data: res.data as T?, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _dio.post(endpoint, data: data);
      return ApiResponse<T>(data: res.data as T?, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse<T>> put<T>(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final res = await _dio.put(endpoint, data: data);
      return ApiResponse<T>(data: res.data as T?, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _dio.patch(endpoint, data: data);
      return ApiResponse<T>(data: res.data as T?, statusCode: res.statusCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _dio.delete(endpoint, data: data);
      return ApiResponse<T>(data: res.data as T?, statusCode: res.statusCode);
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
