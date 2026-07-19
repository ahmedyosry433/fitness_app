// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../core/user_helper/user_helper.dart' as _i589;
import '../../features/auth_modul/api/datasources/auth_modul_remote_data_source_impl.dart'
    as _i306;
import '../../features/auth_modul/api/datasources/social_auth_data_source_impl.dart'
    as _i943;
import '../../features/auth_modul/data/datasources/auth_modul_remote_data_source_contract.dart'
    as _i94;
import '../../features/auth_modul/data/datasources/social_auth_data_source_contract.dart'
    as _i801;
import '../../features/auth_modul/data/repositories/auth_modul_repository_impl.dart'
    as _i515;
import '../../features/auth_modul/data/services/meta_horizon_auth_service.dart'
    as _i872;
import '../../features/auth_modul/data/services/user_firestore_service.dart'
    as _i104;
import '../../features/auth_modul/domain/repositories/auth_modul_repository.dart'
    as _i566;
import '../../features/auth_modul/domain/use_cases/forget_password_use_case.dart'
    as _i42;
import '../../features/auth_modul/domain/use_cases/reset_password_use_case.dart'
    as _i840;
import '../../features/auth_modul/domain/use_cases/signup_use_case.dart'
    as _i124;
import '../../features/auth_modul/domain/use_cases/social_sign_in_use_case.dart'
    as _i123;
import '../../features/auth_modul/domain/use_cases/verify_otp_use_case.dart'
    as _i215;
import '../../features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart'
    as _i667;
import '../../features/auth_modul/presentation/signup/view_model/cubit/signup_cubit.dart'
    as _i76;
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
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreInjectableModule.prefs(),
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => coreInjectableModule.dio());
    gh.lazySingleton<_i59.FirebaseAuth>(
      () => coreInjectableModule.firebaseAuth,
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => coreInjectableModule.firestore,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => coreInjectableModule.secureStorage(),
    );
    gh.lazySingleton<_i361.CancelToken>(
      () => coreInjectableModule.cancelToken(),
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => coreInjectableModule.internetConnection(),
    );
    gh.factory<_i94.AuthModulRemoteDataSource>(
      () => _i306.AuthModulRemoteDataSourceImpl(),
    );
    gh.singleton<_i781.AppInterceptors>(
      () => _i781.AppInterceptors(
        dio: gh<_i361.Dio>(),
        fss: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i872.MetaHorizonAuthService>(
      () => _i872.MetaHorizonAuthService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i104.UserFirestoreService>(
      () => _i104.UserFirestoreService(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i589.UserHelper>(
      () => _i589.UserHelper(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i801.SocialAuthDataSourceContract>(
      () => _i943.AuthModulSocialAuthDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i872.MetaHorizonAuthService>(),
      ),
    );
    gh.factory<_i566.AuthModulRepository>(
      () => _i515.AuthModulRepositoryImpl(
        remoteDataSource: gh<_i94.AuthModulRemoteDataSource>(),
        socialAuthDataSource: gh<_i801.SocialAuthDataSourceContract>(),
      ),
    );
    gh.factory<_i42.ForgetPasswordUseCase>(
      () => _i42.ForgetPasswordUseCase(gh<_i566.AuthModulRepository>()),
    );
    gh.factory<_i840.ResetPasswordUseCase>(
      () => _i840.ResetPasswordUseCase(gh<_i566.AuthModulRepository>()),
    );
    gh.factory<_i124.SignUpUseCase>(
      () => _i124.SignUpUseCase(gh<_i566.AuthModulRepository>()),
    );
    gh.factory<_i123.SocialSignInUseCase>(
      () => _i123.SocialSignInUseCase(gh<_i566.AuthModulRepository>()),
    );
    gh.factory<_i215.VerifyOtpUseCase>(
      () => _i215.VerifyOtpUseCase(gh<_i566.AuthModulRepository>()),
    );
    gh.factory<_i667.ForgetPasswordCubit>(
      () => _i667.ForgetPasswordCubit(
        gh<_i42.ForgetPasswordUseCase>(),
        gh<_i215.VerifyOtpUseCase>(),
        gh<_i840.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i76.SignUpCubit>(
      () => _i76.SignUpCubit(
        gh<_i124.SignUpUseCase>(),
        gh<_i123.SocialSignInUseCase>(),
        gh<_i104.UserFirestoreService>(),
      ),
    );
    return this;
  }
}

class _$CoreInjectableModule extends _i291.CoreInjectableModule {}
