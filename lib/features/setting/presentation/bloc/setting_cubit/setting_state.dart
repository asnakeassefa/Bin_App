

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

class SettingThemeChanged extends SettingState {
  final bool isDarkMode;

  SettingThemeChanged({required this.isDarkMode});
}