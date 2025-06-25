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
  static const String forgetPassword = '$baseUrl/auth/forget-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String changePassword = '$baseUrl/auth/change-password';
}
