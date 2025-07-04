

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<String> register(Map<String, dynamic> user);
  Future<String> verifiyOtp(Map<String, String> otpData);
  Future<String> resendOtp(String email);
  Future<String> resendResetOtp(String email);
  Future<String> forgetPassword(String email);
  Future<String> resetPassword(Map<String,dynamic> otpData);
  Future<String> changePassword(String oldPassword, String newPassword);
  
}
