

import 'package:bin_app/features/setting/data/model/user_model.dart';

sealed class SettingState {}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final bool isDarkMode;

  SettingLoaded({required this.isDarkMode});
}

class SettingError extends SettingState {
  final String message;

  SettingError({required this.message});
}


// Profile state
class ProfileLoaded extends SettingState {
  final ProfileModel profile;
  ProfileLoaded({required this.profile});
}

class ProfileLoading extends SettingState {}

// chage password state
class PasswordChanged extends SettingState {
  final String message;

  PasswordChanged({required this.message});
}

class PasswordChangeLoading extends SettingState {}


// profile update state
class ProfileUpdated extends SettingState {
  final String message;
  ProfileUpdated({required this.message});
}

class ProfileUpdateLoading extends SettingState {}