import 'dart:convert';
import 'dart:developer';

import 'package:bin_app/core/error/exceptions.dart';
import 'package:bin_app/features/auth/presentation/pages/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../main.dart';
import 'check_internet.dart';
import 'endpoints.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService() {
    _dio.options.connectTimeout = const Duration(
      milliseconds: 50000,
    ); // 50 seconds
    _dio.options.receiveTimeout = const Duration(
      milliseconds: 40000,
    ); // 40 seconds

    // Adding log interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Adding interceptor for request/response handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add Authorization token to headers
          final accessToken = await _secureStorage.read(key: 'accessToken');
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          handler.next(options); // Continue the request
        },
        onResponse: (response, handler) {
          handler.next(response); // Continue the response
        },
        onError: (DioException error, handler) async {
          log(
            'Error occurred: ${error.response?.statusCode} - ${error.response?.data['message']}',
          );
          if (error.response?.statusCode == 401 &&
              (error.response?.data['message'] ?? "") ==
                  'Invalid refresh token') {
            log('Invalid refresh token, redirecting to login');
            if (navigatorKey.currentState != null) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                LoginScreen.routeName,
                (route) => false,
              );
              return;
            } else {
              log(
                'Navigator key currentState is null, cannot redirect to login.',
              );
            }
            handler.next(error);
            log('Redirected to login screen due to invalid refresh token');
          }
          if (error.response?.statusCode == 401 &&
              (error.response?.data['message'] == 'Invalid token' ||
                  error.response?.data['message'] == 'Token has expired')) {
            try {
              await _refreshAccessToken();
              // Retry the failed request with the new token
              final retryResponse = await _retryRequest(error.requestOptions);
              handler.resolve(retryResponse);
            } catch (e) {
              handler.next(
                DioException(
                  requestOptions: error.requestOptions,
                  response: error.response,
                  message: "Token Refresh Failed",
                ),
              );
            }
          } else {
            handler.next(error); // Continue other errors
          }
        },
      ),
    );
  }

  /// Retry the failed request
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  /// Refresh the access token
  Future<void> _refreshAccessToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) {
        // throw RefreshTokenExpiredException();
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          LoginScreen.routeName,
          (route) => false,
        );
        throw 'Token has expired';
      }

      final response = await _dio.post(
        '${Endpoints.baseUrl}/auth/refresh-token',
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data["data"]["tokens"]["accessToken"];
        await _secureStorage.write(key: 'accessToken', value: newAccessToken);
      } else {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          LoginScreen.routeName,
          (route) => false,
        );
        // throw RefreshTokenExpiredException();
      }
    } catch (e) {
      log('Error refreshing access token: $e');
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    }
  }

  /// Perform a POST request
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString()[0] == '4') {
        final errorResponse = jsonEncode(e.response?.data['message']);

        // Parse and format the error message
        final decodedResponse =
            jsonDecode(errorResponse) as Map<String, dynamic>;
        final errorMessage = decodedResponse.entries
            .map((entry) => '${entry.value.join(', ')}')
            .join('\n');
        throw ClientException(
          message:
              "${e.response?.data['message'].toString()} ${errorMessage.toString()}",
        );
      } else if (e.response?.statusCode.toString()[0] == '5') {
        throw ServerException(message: 'Server error');
      }
      // check if it is time out exception and throw client error with timeout message
      else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Perform a GET request
  Future<Response> get(String endpoint) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
          message:
              'Somthing went wrong!. Please check your internet connection!',
        );
      }

      return await _dio.get(endpoint);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString()[0] == '4') {
        final errorResponse = jsonEncode(e.response?.data['errors']);

        // Parse and format the error message
        final decodedResponse =
            jsonDecode(errorResponse) as Map<String, dynamic>;
        final errorMessage = decodedResponse.entries
            .map((entry) => ' ${entry.value.join(', ')}')
            .join('\n');
        throw ClientException(
          message:
              "${e.response?.data['message'].toString()} ${errorMessage.toString()}",
        );
      } else if (e.response?.statusCode.toString()[0] == '5') {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Perform a PUT request
  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
          message:
              'Somthing went wrong!. Please check your internet connection!',
        );
      }
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString()[0] == '4') {
        final errorResponse = jsonEncode(e.response?.data['errors']);

        // Parse and format the error message
        final decodedResponse =
            jsonDecode(errorResponse) as Map<String, dynamic>;
        final errorMessage = decodedResponse.entries
            .map((entry) => ' ${entry.value.join(', ')}')
            .join('\n');
        throw ClientException(
          message:
              "${e.response?.data['message'].toString()} ${errorMessage.toString()}",
        );
      } else if (e.response?.statusCode.toString()[0] == '5') {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Perform a DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
          message:
              'Somthing went wrong!. Please check your internet connection!',
        );
      }
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString()[0] == '4') {
        final errorResponse = jsonEncode(e.response?.data['errors']);

        // Parse and format the error message
        final decodedResponse =
            jsonDecode(errorResponse) as Map<String, dynamic>;
        final errorMessage = decodedResponse.entries
            .map((entry) => ' ${entry.value.join(', ')}')
            .join('\n');
        throw ClientException(
          message:
              "${e.response?.data['message'].toString()} ${errorMessage.toString()}",
        );
      } else if (e.response?.statusCode.toString()[0] == '5') {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Upload multipart form data (e.g., file upload)
  Future<Response> upload(String endpoint, FormData formData) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
          message:
              'Somthing went wrong!. Please check your internet connection!',
        );
      }
      return await _dio.post(endpoint, data: formData);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString()[0] == '4') {
        final errorResponse = jsonEncode(e.response?.data['errors']);

        // Parse and format the error message
        final decodedResponse =
            jsonDecode(errorResponse) as Map<String, dynamic>;
        final errorMessage = decodedResponse.entries
            .map((entry) => ' ${entry.value.join(', ')}')
            .join('\n');
        throw ClientException(
          message:
              "${e.response?.data['message'].toString()} ${errorMessage.toString()}",
        );
      } else if (e.response?.statusCode.toString()[0] == '5') {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }

  /// Edit multipart form data (e.g., file update)
  Future<Response> uploadFileUpdate(String endpoint, FormData formData) async {
    try {
      final connection = await CheckInternet().hasInternetConnection();
      if (!connection) {
        throw ClientException(
          message:
              'Somthing went wrong!. Please check your internet connection!',
        );
      }
      return await _dio.put(endpoint, data: formData);
    } on DioException catch (e) {
      if (e.response?.statusCode.toString()[0] == '4') {
        final errorResponse = jsonEncode(e.response?.data['errors']);

        // Parse and format the error message
        final decodedResponse =
            jsonDecode(errorResponse) as Map<String, dynamic>;
        final errorMessage = decodedResponse.entries
            .map((entry) => ' ${entry.value.join(', ')}')
            .join('\n');
        throw ClientException(
          message:
              "${e.response?.data['message'].toString()} ${errorMessage.toString()}",
        );
      } else if (e.response?.statusCode.toString()[0] == '5') {
        throw ServerException(message: 'Server error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ClientException(message: 'Connection timeout. Please try again.');
      } else {
        throw ('Something went wrong');
      }
    }
  }
}
