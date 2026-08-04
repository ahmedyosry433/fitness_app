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
import '../../features/auth/api/api_client/auth_api_client.dart' as _i824;
import '../../features/auth/api/datasources/auth_local_data_source_impl.dart'
    as _i563;
import '../../features/auth/api/datasources/auth_remote_data_source_impl.dart'
    as _i723;
import '../../features/auth/data/datasources/auth_local_data_source_contract.dart'
    as _i271;
import '../../features/auth/data/datasources/auth_remote_data_source_contract.dart'
    as _i453;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/register_use_case.dart' as _i1010;
import '../../features/auth/domain/use_cases/social_login_use_case.dart'
    as _i104;
import '../../features/auth/presentation/view_model/cubit/register/register_cubit.dart'
    as _i848;
import '../../features/auth_modul/api/datasources/social_auth_data_source_impl.dart'
    as _i943;
import '../../features/auth_modul/data/datasources/social_auth_data_source_contract.dart'
    as _i801;
import '../../features/auth_modul/data/services/meta_horizon_auth_service.dart'
    as _i872;
import '../../features/auth_modul/data/services/user_firestore_service.dart'
    as _i104;
import '../../features/exercise_module/api/api_client/exercise_module_api_client.dart'
    as _i723;
import '../../features/exercise_module/data/datasources/exercise_remote_data_source.dart'
    as _i868;
import '../../features/exercise_module/data/repositories/exercise_repository_impl.dart'
    as _i1072;
import '../../features/exercise_module/domain/repositories/exercise_repository.dart'
    as _i112;
import '../../features/exercise_module/domain/use_cases/get_difficulty_levels_use_case.dart'
    as _i198;
import '../../features/exercise_module/domain/use_cases/get_exercises_use_case.dart'
    as _i692;
import '../../features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart'
    as _i215;
import '../../features/food/api/api_client/food_api_client.dart' as _i310;
import '../../features/food/api/datasource/food_remote_data_source_impl.dart'
    as _i521;
import '../../features/food/data/datasources/food_remote_data_source_contract.dart'
    as _i329;
import '../../features/food/data/repositories/food_repository_impl.dart'
    as _i860;
import '../../features/food/domain/repositories/food_repository_contract.dart'
    as _i966;
import '../../features/food/domain/use_case/get_meal_details_use_case.dart'
    as _i201;
import '../../features/food/presentation/details_food/view_model/cubit/details_food_cubit.dart'
    as _i1072;
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
    gh.factory<_i824.AuthApiClient>(
      () => _i824.AuthApiClient(gh<_i361.Dio>(), baseUrl: gh<String>()),
    );
    gh.factory<_i271.AuthLocalDataSourceContract>(
      () => _i563.AuthLocalDataSourceImpl(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i310.FoodApiClient>(
      () => _i310.FoodApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i723.ExerciseModuleApiClient>(
      () => _i723.ExerciseModuleApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i329.FoodRemoteDataSourceContract>(
      () => _i521.FoodRemoteDataSourceImpl(gh<_i310.FoodApiClient>()),
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
    gh.factory<_i966.FoodRepositoryContract>(
      () => _i860.FoodRepositoryImpl(gh<_i329.FoodRemoteDataSourceContract>()),
    );
    gh.factory<_i453.AuthRemoteDataSourceContract>(
      () => _i723.AuthRemoteDataSourceImpl(gh<_i824.AuthApiClient>()),
    );
    gh.lazySingleton<_i104.UserFirestoreService>(
      () => _i104.UserFirestoreService(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i868.ExerciseRemoteDataSource>(
      () => _i868.ExerciseRemoteDataSourceImpl(
        gh<_i723.ExerciseModuleApiClient>(),
      ),
    );
    gh.factory<_i589.UserHelper>(
      () => _i589.UserHelper(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i801.SocialAuthDataSourceContract>(
      () => _i943.AuthModulSocialAuthDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i872.MetaHorizonAuthService>(),
      ),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i453.AuthRemoteDataSourceContract>(),
        gh<_i271.AuthLocalDataSourceContract>(),
        gh<_i801.SocialAuthDataSourceContract>(),
        gh<_i104.UserFirestoreService>(),
      ),
    );
    gh.factory<_i201.GetMealDetailsUseCase>(
      () => _i201.GetMealDetailsUseCase(gh<_i966.FoodRepositoryContract>()),
    );
    gh.factory<_i112.ExerciseRepository>(
      () => _i1072.ExerciseRepositoryImpl(gh<_i868.ExerciseRemoteDataSource>()),
    );
    gh.factory<_i198.GetDifficultyLevelsUseCase>(
      () => _i198.GetDifficultyLevelsUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i692.GetExercisesUseCase>(
      () => _i692.GetExercisesUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i1072.DetailsFoodCubit>(
      () => _i1072.DetailsFoodCubit(gh<_i201.GetMealDetailsUseCase>()),
    );
    gh.factory<_i1010.RegisterUseCase>(
      () => _i1010.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i104.SocialLoginUseCase>(
      () => _i104.SocialLoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i215.ExerciseModuleCubit>(
      () => _i215.ExerciseModuleCubit(
        gh<_i692.GetExercisesUseCase>(),
        gh<_i198.GetDifficultyLevelsUseCase>(),
      ),
    );
    gh.factory<_i848.RegisterCubit>(
      () => _i848.RegisterCubit(
        gh<_i1010.RegisterUseCase>(),
        gh<_i104.SocialLoginUseCase>(),
      ),
    );
    return this;
  }
}

class _$CoreInjectableModule extends _i291.CoreInjectableModule {}
