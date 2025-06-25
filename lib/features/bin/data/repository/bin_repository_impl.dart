import 'package:bin_app/features/bin/data/model/bin_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/bin_repository.dart';
import '../data_source/remote_data_source.dart';

@Injectable(as: BinRepository)
class BinRepositoryImpl implements BinRepository {
  final BinDataSource dataSource;
  BinRepositoryImpl({required this.dataSource});
  @override
  Future<String> addBin(Map<String, dynamic> binData) async {
    try {
      return await dataSource.addBin(binData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteBin(String binId) async {
    try {
      return await dataSource.deleteBin(binId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BinModel> getBins() async {
    try {
      return await dataSource.getBins();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateBin(String binId, Map<String, dynamic> binData) async {
    try {
      return await dataSource.updateBin(binId, binData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateBinColor(
    String binId,
    Map<String, String> colors,
  ) async {
    try {
      return await dataSource.updateBinColor(binId, colors);
    } catch (e) {
      rethrow;
    }
  }
}
