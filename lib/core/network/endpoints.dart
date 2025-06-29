// create class for end points
class Endpoints {
  // static const String baseUrl = 'https://vkapsprojects.com/aayojan-app/api';
  static const String baseUrl = 'https://bin-management.onrender.com/api/v1';
  // static const String imageUrl =
  //     'https://vkapsprojects.com/aayojan-app/storage/';

  // static const String imageUrl = 'https://aayojan.co.in/storage/';

  static const String signUp = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String verifyOtp = '$baseUrl/auth/verify-email';
  static const String resendOtp = '$baseUrl/auth/resend-verification';
  static const String resendResetOtp = '$baseUrl/auth/resend-password-reset';
  static const String forgetPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String changePassword = '$baseUrl/auth/change-password';

  // bin endpoints
  static const String getBins = '$baseUrl/bins';
  static const String addBin = '$baseUrl/bins/add';
  static const String updateBin = '$baseUrl/bins';

  // profile
  static const String getProfile = '$baseUrl/users/me';
  static const String updateProfile = '$baseUrl/users/me';
}
