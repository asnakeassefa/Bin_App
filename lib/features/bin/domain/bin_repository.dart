import 'package:bin_app/features/bin/data/model/bin_model.dart';

abstract class BinRepository {
  Future<BinModel> getBins();
  Future<String> addBin(Map<String, dynamic> binData);
  Future<String> updateBin(String binId, Map<String, dynamic> binData);
  Future<String> deleteBin(String binId);
  Future<String> updateBinColor(String binId, Map<String, String> colors);
}
