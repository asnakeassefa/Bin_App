
import '../data/model/user_model.dart';

abstract class SettingRepository {
  // Fetches the user profile.
  Future<ProfileModel> getProfile();

  // Updates the user profile with the provided data.
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);

  // Changes the user's password.
  Future<String> changePassword(String oldPassword, String newPassword);
}