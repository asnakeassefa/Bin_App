import 'dart:developer';

import 'package:injectable/injectable.dart';

import '../../domain/auth_repository.dart';
import '../datasources/remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<String> register(Map<String, dynamic> user) async {
    return await remoteDataSource.register(user);
  }

  @override
  Future<String> verifiyOtp(Map<String, String> otpData) async {
    return await remoteDataSource.verifiyOtp(otpData);
  }

  @override
  Future<String> forgetPassword(String email) async {
    return await remoteDataSource.forgetPassword(email);
  }

  @override
  Future<String> changePassword(String oldPassword, String newPassword) async {
    return await remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> newData) async {
    return await remoteDataSource.resetPassword(newData);
  }

  @override
  Future<String> resendOtp(String email) async {
    return await remoteDataSource.resendOtp(email);
  }

  @override
  Future<String> resendResetOtp(String email) async {
    log("Resending reset OTP for email: $email");
    return await remoteDataSource.resendResetOtp(email);
  }
}
