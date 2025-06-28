import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/setting_repository.dart';
import 'setting_state.dart';

@injectable
class SettingCubit extends Cubit<SettingState> {
  final SettingRepository repository;
  SettingCubit(this.repository) : super(SettingInitial());

  // get user data

  void getProfile() async {
    log('Fetching user profile...');
    emit(SettingLoading());
    try {
      final profile = await repository.getProfile();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  // change password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(PasswordChangeLoading());
    try {
      final message = await repository.changePassword(oldPassword, newPassword);
      emit(PasswordChanged(message: message));
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }
}
