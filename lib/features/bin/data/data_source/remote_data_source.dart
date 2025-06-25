import 'package:injectable/injectable.dart';

import '../model/bin_model.dart';

abstract class BinDataSource {
  Future<BinModel> getBins();
  Future<String> addBin(Map<String, dynamic> binData);
  Future<String> updateBin(String binId, Map<String, dynamic> binData);
  Future<String> deleteBin(String binId);
  Future<String> updateBinColor(String binId, Map<String, String> colors);
}

@Injectable(as: BinDataSource)
class BinDataSourceImpl implements BinDataSource {
  @override
  Future<String> addBin(Map<String, dynamic> binData) async {
    // TODO: implement addBin
    throw UnimplementedError();
  }

  @override
  Future<String> deleteBin(String binId) async {
    // TODO: implement deleteBin
    throw UnimplementedError();
  }

  @override
  Future<BinModel> getBins() async {
    // TODO: implement getBins
    throw UnimplementedError();
  }

  @override
  Future<String> updateBin(String binId, Map<String, dynamic> binData) async {
    // TODO: implement updateBin
    throw UnimplementedError();
  }

  @override
  Future<String> updateBinColor(
    String binId,
    Map<String, String> colors,
  ) async {
    // TODO: implement updateBinColor
    throw UnimplementedError();
  }
}
