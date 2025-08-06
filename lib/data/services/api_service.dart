import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posts_app/core/constants/api_constants.dart';
import 'package:posts_app/core/network/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

@riverpod
/// Provider for API service
ApiService apiService(Ref ref) {
  return ApiService(ref.watch(dioProvider));
}

/// Service class for making API calls
/// Using Service pattern instead of DataSource for simplicity
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  /// Get all posts from the API
  Future<List<dynamic>> getPosts() async {
    try {
      final Response<dynamic> response = await _dio.get(ApiConstants.posts);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get a single post by ID
  Future<Map<String, dynamic>> getPost(int id) async {
    try {
      final Response<dynamic> response = await _dio.get('${ApiConstants.posts}/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get comments for a specific post
  Future<List<dynamic>> getComments(int postId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        ApiConstants.comments,
        queryParameters: <String, dynamic>{'postId': postId},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create a new post
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    try {
      final Response<dynamic> response = await _dio.post(ApiConstants.posts, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update an existing post
  Future<Map<String, dynamic>> updatePost(int id, Map<String, dynamic> data) async {
    try {
      final Response<dynamic> response = await _dio.patch('${ApiConstants.posts}/$id', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete a post
  Future<void> deletePost(int id) async {
    try {
      await _dio.delete('${ApiConstants.posts}/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert to user-friendly messages
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final int? statusCode = error.response?.statusCode;
        final String? message = error.response?.data?['message'] ?? 'Server error';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception('Network error. Please check your connection.');
    }
  }
}
