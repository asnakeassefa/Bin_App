import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/service/flutter_service.dart';
import '../../domain/auth_repository.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      String res = await repository.login(email, password);
      emit(AuthSuccess(message: res));
    } catch (err) {
      emit(AuthFailure(message: err.toString()));
    }
  }

  Future<void> register(Map<String, dynamic> user) async {
    emit(AuthLoading());
    try {
      // add device token to user data if needed
      final deviceToken = await FirebaseService()
          .getToken(); // Replace with actual device token logic

      log('Device Token: $deviceToken');
      user['deviceToken'] = deviceToken;
      String res = await repository.register(user);
      if (res.isNotEmpty) {
        emit(AuthSuccess(message: res));
      } else {
        emit(AuthFailure(message: 'Failed to register'));
      }
    } catch (err) {
      emit(AuthFailure(message: err.toString()));
    }
  }

  Future<void> verifyOtp(Map<String, String> otpData) async {
    emit(AuthLoading());
    try {
      String response = await repository.verifiyOtp(otpData);
      emit(AuthSuccess(message: response));
    } catch (err) {
      emit(AuthFailure(message: err.toString()));
    }
  }

  Future<void> resendOTP(String email) async {
    emit(AuthLoading());
    try {
      String response = await repository.resendOtp(email);
      emit(AuthSuccess(message: response));
    } catch (err) {
      emit(AuthFailure(message: err.toString()));
    }
  }

  Future<void> forgetPassword(String email) async {
    emit(AuthLoading());
    try {
      String response = await repository.forgetPassword(email);
      emit(AuthSuccess(message: response));
    } catch (err) {
      emit(AuthFailure(message: err.toString()));
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(AuthLoading());
    try {
      String response = await repository.changePassword(
        oldPassword,
        newPassword,
      );
      emit(AuthSuccess(message: response));
    } catch (err) {
      emit(AuthFailure(message: err.toString()));
    }
  }
}
