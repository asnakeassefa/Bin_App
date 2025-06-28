import 'dart:developer';

import 'package:bin_app/core/error/exceptions.dart';
import 'package:bin_app/core/network/api_provider.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/endpoints.dart';
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
  ApiService api = ApiService();
  @override
  Future<String> addBin(Map<String, dynamic> binData) async {
    final url = Endpoints.addBin;
    try {
      final response = await api.post(url, binData);
      return response.data['message'] ?? "Bin is added";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow; // Rethrow the specific exceptions
      } else {
        throw Exception('Failed to add bin'); // Handle other exceptions
      }
    }
  }

  @override
  Future<String> deleteBin(String binId) async {
    // TODO: implement deleteBin
    throw UnimplementedError();
  }

  @override
  Future<BinModel> getBins() async {
    log('Fetching bins from remote data source');
    final url = Endpoints.getBins;
    try {
      final response = await api.get(url);
      final finalResponse = BinModel.fromJson(response.data);
      return finalResponse;
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow; // Rethrow the specific exceptions
      } else {
        throw Exception('Failed to load bins'); // Handle other exceptions
      }
    }
  }

  @override
  Future<String> updateBin(String binId, Map<String, dynamic> binData) async {
    String url = "${Endpoints.updateBin}/$binId/schedule";
    try {
      final response = await api.put(url, binData);
      log('request made');
      return response.data['message'] ?? "Bin is updated";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow; // Rethrow the specific exceptions
      } else {
        throw 'Something went wrong'; // Handle other exceptions
      }
    }
  }

  @override
  Future<String> updateBinColor(
    String binId,
    Map<String, String> colors,
  ) async {
    String url = "${Endpoints.updateBin}/$binId/appearance";
    try {
      final response = await api.put(url, colors);
      log('request made');
      return response.data['message'] ?? "Colors are updated";
    } catch (e) {
      if (e is ClientException || e is ServerException) {
        rethrow; // Rethrow the specific exceptions
      } else {
        throw 'Something went wrong'; // Handle other exceptions
      }
    }
  }
}
