import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_app/core/constants/api_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
/// Provider for Dio instance
Dio dio(Ref ref) {
  return DioClient.instance;
}

/// Singleton Dio client configuration
class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll(<Interceptor>[
      // Only add LogInterceptor in debug mode
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (Object log) => debugPrint('DIO: $log'),
        ),
    ]);

    return dio;
  }

  /// Reset Dio instance (useful for testing)
  static void reset() {
    _dio = null;
  }
}
