import 'package:bin_app/features/setting/data/model/user_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/setting_repository.dart';
import '../datasource/remote_data_source.dart';

@Injectable(as: SettingRepository)
class SettingRepositoryImpl implements SettingRepository {
  SettingDataSource settingDataSource;
  SettingRepositoryImpl(this.settingDataSource);
  @override
  Future<String> changePassword(String oldPassword, String newPassword) async {
    return await settingDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<ProfileModel> getProfile() async {
    return await settingDataSource.getProfile();
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) {
    return settingDataSource.updateProfile(data);
  }
}
