import 'package:bin_app/core/network/api_provider.dart';
import 'package:bin_app/core/network/endpoints.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../model/user_model.dart';

abstract class SettingDataSource {
  // Fetches the user profile.
  Future<ProfileModel> getProfile();
  // Updates the user profile with the provided data.
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);
  // Changes the user's password.
  Future<String> changePassword(String oldPassword, String newPassword);
}

@Injectable(as: SettingDataSource)
class SettingRemoteDataSource implements SettingDataSource {
  ApiService api = ApiService();
  @override
  Future<String> changePassword(String oldPassword, String newPassword) async {
    String url = Endpoints.changePassword;
    Map<String, dynamic> data = {
      'currentPassword': oldPassword,
      'newPassword': newPassword,
    };

    try {
      final response = await api.put(url, data);
      return response.data['message'] ?? 'Password changed successfully';
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow; // Re-throw known exceptions
      } else {
        throw ServerException(message: 'Failed to change password');
      }
    }
  }

  @override
  Future<ProfileModel> getProfile() async {
    String url = Endpoints.getProfile;

    try {
      final response = await api.get(url);
      final userInfo = ProfileModel.fromJson(response.data);
      return userInfo;
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow; // Re-throw known exceptions
      } else {
        throw ServerException(message: 'Failed to fetch profile data');
      }
    }
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
