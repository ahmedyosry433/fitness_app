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
import '../../features/exercise_module/api/api_client/exercise_module_api_client.dart'
    as _i723;
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
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => coreInjectableModule.secureStorage(),
    );
    gh.lazySingleton<_i361.CancelToken>(
      () => coreInjectableModule.cancelToken(),
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => coreInjectableModule.internetConnection(),
    );
    gh.factory<_i723.ExerciseModuleApiClient>(
      () => _i723.ExerciseModuleApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i781.AppInterceptors>(
      () => _i781.AppInterceptors(
        dio: gh<_i361.Dio>(),
        fss: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i112.ExerciseRepository>(
      () => _i1072.ExerciseRepositoryImpl(gh<_i723.ExerciseModuleApiClient>()),
    );
    gh.factory<_i198.GetDifficultyLevelsUseCase>(
      () => _i198.GetDifficultyLevelsUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i692.GetExercisesUseCase>(
      () => _i692.GetExercisesUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i589.UserHelper>(
      () => _i589.UserHelper(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i215.ExerciseModuleCubit>(
      () => _i215.ExerciseModuleCubit(gh<_i692.GetExercisesUseCase>()),
    );
    return this;
  }
}

class _$CoreInjectableModule extends _i291.CoreInjectableModule {}
