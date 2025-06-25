import 'package:bin_app/features/bin/data/model/bin_model.dart';

sealed class BinState {}

class BinInitial extends BinState {}

// add
class BinLoading extends BinState {}
class BinLoaded extends BinState {
  final BinModel bins;
  BinLoaded(this.bins);
}

class BinError extends BinState {
  final String message;
  BinError(this.message);
}

class BinAdded extends BinState {
  final String message;
  BinAdded(this.message);
}

class BinUpdated extends BinState {
  final String message;
  BinUpdated(this.message);
}