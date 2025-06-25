sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final bool isDarkMode;

  ProfileLoaded({required this.isDarkMode});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

class ProfileThemeChanged extends ProfileState {
  final bool isDarkMode;

  ProfileThemeChanged({required this.isDarkMode});
}
