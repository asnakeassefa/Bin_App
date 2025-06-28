import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_provider.dart';
import '../../../../core/network/endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<String> register(Map<String, dynamic> user);
  Future<String> verifiyOtp(Map<String, String> otpData);
  Future<String> resendOtp(String email);
  Future<String> resendResetOtp(String email);
  Future<String> forgetPassword(String email);
  Future<String> resetPassword(Map<String, dynamic> newData);
  Future<String> changePassword(String oldPassword, String newPassword);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiService api = ApiService();
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Future<String> login(String email, String password) async {
    String url = Endpoints.login;
    try {
      final response = await api.post(url, {
        'email': email,
        'password': password,
      });

      String token = response.data['data']['accessToken'];
      String refreshToken = response.data['data']['refreshToken'];

      await storage.write(key: "accessToken", value: token);
      await storage.write(key: "refreshToken", value: refreshToken);

      return response.data['message'] ?? 'User logged in successfully';
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  @override
  Future<String> register(Map<String, dynamic> user) async {
    String url = Endpoints.signUp;
    try {
      final response = await api.post(url, user);
      var responseData = response.data;
      return responseData['message'] ?? 'User registered successfully';
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  @override
  Future<String> verifiyOtp(Map<String, String> otpData) async {
    String url = Endpoints.verifyOtp;
    try {
      final response = await api.post(url, otpData);
      String token = response.data['data']['accessToken'];
      String refreshToken = response.data['data']['refreshToken'];

      await storage.write(key: "accessToken", value: token);
      await storage.write(key: "refreshToken", value: refreshToken);

      return response.data['message'] ?? "User verified successfully";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  @override
  Future<String> forgetPassword(String email) async {
    String url = Endpoints.forgetPassword;
    try {
      final response = await api.post(url, {'email': email});
      return response.data['message'];
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  @override
  Future<String> changePassword(String oldPassword, String newPassword) async {
    String url = Endpoints.changePassword;
    try {
      final response = await api.put(url, {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      return response.data['message'] ?? "Password changed successfully";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> newData) async {
    String url = Endpoints.resetPassword;
    try {
      final response = await api.post(url, newData);
      return response.data['message'] ?? "OTP resent successfully";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  @override
  Future<String> resendOtp(String email) async {
    String url = Endpoints.resendOtp;
    try {
      final response = await api.post(url, {'email': email});
      return response.data['message'] ?? "OTP resent successfully";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  @override
  Future<String> resendResetOtp(String email) async {
    String url = Endpoints.resendResetOtp;
    try {
      final response = await api.post(url, {'email': email});
      return response.data['message'] ?? "OTP resent successfully";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }
}
