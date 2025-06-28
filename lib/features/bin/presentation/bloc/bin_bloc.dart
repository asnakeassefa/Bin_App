import 'dart:developer';

import 'package:bin_app/features/bin/domain/bin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'bin_state.dart';

@injectable
class BinBloc extends Cubit<BinState> {
  BinRepository repository;
  BinBloc(this.repository) : super(BinInitial());

  // add
  void addBins(Map<String, dynamic> binData) async {
    emit(BinLoading());
    try {
      final message = await repository.addBin(binData);
      emit(BinAdded(message));
    } catch (e) {
      emit(BinError(e.toString()));
    }
  }

  // update
  void updateBinSchedule(String binId, Map<String, dynamic> binData) async {
    log('Updating bin schedule for binId: $binId with data: $binData');
    emit(BinLoading());
    try {
      final message = await repository.updateBin(binId, binData);
      emit(BinUpdated(message));
    } catch (e) {
      emit(BinError(e.toString()));
    }
  }

  // delete
  void deleteBin(String binId) {}

  // get bins
  void getBins() async {
    emit(BinLoading());
    try {
      final bins = await repository.getBins();
      emit(BinLoaded(bins));
    } catch (e) {
      emit(BinError(e.toString()));
    }
  }

  // update color
  void updateBinColor(String binId, Map<String, String> colors) async {
    emit(BinLoading());
    try {
      final message = await repository.updateBinColor(binId, colors);
      emit(BinUpdated(message));
    } catch (e) {
      emit(BinError(e.toString()));
    }
  }
}
