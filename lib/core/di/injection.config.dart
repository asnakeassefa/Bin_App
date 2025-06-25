// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/remote_datasource.dart' as _i96;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/auth_repository.dart' as _i996;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../network/check_internet.dart' as _i1072;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i1072.CheckInternet>(() => _i1072.CheckInternet());
  gh.factory<_i96.AuthRemoteDataSource>(() => _i96.AuthRemoteDataSourceImpl());
  gh.factory<_i996.AuthRepository>(
    () => _i153.AuthRepositoryImpl(gh<_i96.AuthRemoteDataSource>()),
  );
  gh.factory<_i797.AuthCubit>(
    () => _i797.AuthCubit(gh<_i996.AuthRepository>()),
  );
  return getIt;
}
