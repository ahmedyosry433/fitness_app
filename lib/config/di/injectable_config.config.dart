// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../core/user_helper/user_helper.dart' as _i589;
import '../../features/auth/api/api_client/auth_api_client.dart' as _i824;
import '../../features/auth/api/datasources/auth_local_data_source_impl.dart'
    as _i563;
import '../../features/auth/api/datasources/auth_remote_data_source_impl.dart'
    as _i723;
import '../../features/auth/auth_di.dart' as _i563;
import '../../features/auth/data/datasources/auth_local_data_source_contract.dart'
    as _i271;
import '../../features/auth/data/datasources/auth_remote_data_source_contract.dart'
    as _i453;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/view_model/cubit/forget_password/forget_password_cubit.dart'
    as _i391;
import '../../features/auth/presentation/view_model/cubit/login/login_cubit.dart'
    as _i646;
import '../../features/auth/presentation/view_model/cubit/register/register_cubit.dart'
    as _i848;
import '../api/app_interceptors.dart' as _i781;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreInjectableModule = _$CoreInjectableModule();
    final authInjectableModule = _$AuthInjectableModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreInjectableModule.prefs(),
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => coreInjectableModule.dio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => coreInjectableModule.secureStorage(),
    );
    gh.lazySingleton<_i361.CancelToken>(
      () => coreInjectableModule.cancelToken(),
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => coreInjectableModule.internetConnection(),
    );
    gh.lazySingleton<_i271.AuthLocalDataSourceContract>(
      () => _i563.AuthLocalDataSourceImpl(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i824.AuthApiClient>(
      () => authInjectableModule.authApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i781.AppInterceptors>(
      () => _i781.AppInterceptors(
        dio: gh<_i361.Dio>(),
        fss: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i453.AuthRemoteDataSourceContract>(
      () => _i723.AuthRemoteDataSourceImpl(gh<_i824.AuthApiClient>()),
    );
    gh.factory<_i589.UserHelper>(
      () => _i589.UserHelper(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i453.AuthRemoteDataSourceContract>(),
        gh<_i271.AuthLocalDataSourceContract>(),
      ),
    );
    gh.factory<_i391.ForgetPasswordCubit>(
      () => _i391.ForgetPasswordCubit(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i646.LoginCubit>(
      () => _i646.LoginCubit(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i848.RegisterCubit>(
      () => _i848.RegisterCubit(gh<_i787.AuthRepository>()),
    );
    return this;
  }
}

class _$CoreInjectableModule extends _i291.CoreInjectableModule {}

class _$AuthInjectableModule extends _i563.AuthInjectableModule {}
