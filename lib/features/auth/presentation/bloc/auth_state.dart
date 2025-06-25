part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess({required this.message});
}

class AuthOtp extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

class OtpSuccess extends AuthState {}

class GoogleAuthLoading extends AuthState {}

class AuthLogout extends AuthState {}
