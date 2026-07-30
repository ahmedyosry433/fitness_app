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
import '../../features/ai_agent/data/datasource/ai_chat_local_datasource.dart'
    as _i437;
import '../../features/ai_agent/data/datasource/knowledge_local_datasource.dart'
    as _i912;
import '../../features/ai_agent/data/datasource/ollama_remote_datasource.dart'
    as _i803;
import '../../features/ai_agent/data/local/ai_chat_database.dart' as _i581;
import '../../features/ai_agent/data/local/knowledge_database.dart' as _i16;
import '../../features/ai_agent/data/repository/ai_chat_history_repository_impl.dart'
    as _i165;
import '../../features/ai_agent/data/repository/ollama_repository_impl.dart'
    as _i508;
import '../../features/ai_agent/data/tools/ai_tool_registry.dart' as _i969;
import '../../features/ai_agent/data/tools/fast_path_recognizer.dart' as _i442;
import '../../features/ai_agent/data/tools/image_attachment_encoder.dart'
    as _i154;
import '../../features/ai_agent/domain/repositories/ai_chat_history_repository.dart'
    as _i487;
import '../../features/ai_agent/domain/repositories/ollama_repository.dart'
    as _i646;
import '../../features/ai_agent/domain/use_cases/delete_conversation_use_case.dart'
    as _i601;
import '../../features/ai_agent/domain/use_cases/get_ai_user_context_use_case.dart'
    as _i788;
import '../../features/ai_agent/domain/use_cases/get_conversation_messages_use_case.dart'
    as _i61;
import '../../features/ai_agent/domain/use_cases/get_conversations_use_case.dart'
    as _i606;
import '../../features/ai_agent/domain/use_cases/save_chat_message_use_case.dart'
    as _i219;
import '../../features/ai_agent/domain/use_cases/send_agent_message_use_case.dart'
    as _i219;
import '../../features/ai_agent/domain/use_cases/start_conversation_use_case.dart'
    as _i1051;
import '../../features/ai_agent/domain/use_cases/update_chat_message_use_case.dart'
    as _i1069;
import '../../features/ai_agent/presentation/view_model/cubit/ai_agent_cubit.dart'
    as _i599;
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
import '../../features/exercise_module/domain/use_cases/get_muscle_groups_use_case.dart'
    as _i487;
import '../../features/exercise_module/domain/use_cases/get_muscles_by_group_use_case.dart'
    as _i735;
import '../../features/exercise_module/domain/use_cases/get_random_muscles_use_case.dart'
    as _i467;
import '../../features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart'
    as _i215;
import '../../features/exercise_module/presentation/view_model/cubit/workout_cubit.dart'
    as _i355;
import '../../features/food/api/api_client/food_api_client.dart' as _i310;
import '../../features/food/api/datasource/food_remote_data_source_impl.dart'
    as _i521;
import '../../features/food/data/datasources/food_remote_data_source_contract.dart'
    as _i329;
import '../../features/food/data/repositories/food_repository_impl.dart'
    as _i860;
import '../../features/food/domain/repositories/food_repository_contract.dart'
    as _i966;
import '../../features/food/domain/use_case/get_food_categories_use_case.dart'
    as _i484;
import '../../features/food/domain/use_case/get_meal_details_use_case.dart'
    as _i201;
import '../../features/food/domain/use_case/get_meals_by_category_use_case.dart'
    as _i681;
import '../../features/food/presentation/details_food/view_model/cubit/details_food_cubit.dart'
    as _i1072;
import '../../features/food/presentation/food_recommendation/view_model/cubit/food_recommendation_cubit.dart'
    as _i685;
import '../../features/home/presentation/view_model/cubit/home_cubit.dart'
    as _i1039;
import '../../features/login/api/api_client/login_api_client.dart' as _i395;
import '../../features/login/api/datasources/login_local_data_source_impl.dart'
    as _i438;
import '../../features/login/api/datasources/login_remote_data_source_impl.dart'
    as _i904;
import '../../features/login/data/datasources/login_local_data_source_contract.dart'
    as _i325;
import '../../features/login/data/datasources/login_remote_data_source_contract.dart'
    as _i736;
import '../../features/login/data/repositories/login_repository_impl.dart'
    as _i1066;
import '../../features/login/domain/repositories/login_repository.dart'
    as _i902;
import '../../features/login/login_di.dart' as _i871;
import '../../features/login/presentation/view_model/cubit/login_cubit.dart'
    as _i753;
import '../../features/profile/api/api_client/profile_api_client.dart' as _i699;
import '../../features/profile/api/datasources/profile_remote_data_source_impl.dart'
    as _i4;
import '../../features/profile/data/datasources/profile_remote_data_source_contract.dart'
    as _i961;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/use_cases/change_password_use_case.dart'
    as _i266;
import '../../features/profile/domain/use_cases/delete_account_use_case.dart'
    as _i546;
import '../../features/profile/domain/use_cases/get_profile_use_case.dart'
    as _i110;
import '../../features/profile/domain/use_cases/logout_use_case.dart' as _i332;
import '../../features/profile/domain/use_cases/update_profile_use_case.dart'
    as _i186;
import '../../features/profile/domain/use_cases/upload_photo_use_case.dart'
    as _i967;
import '../../features/profile/presentation/view_model/cubit/profile_cubit.dart'
    as _i967;
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
    final loginInjectableModule = _$LoginInjectableModule();
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
    gh.lazySingleton<_i803.OllamaRemoteDatasource>(
      () => _i803.OllamaRemoteDatasource(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i581.AiChatDatabase>(() => _i581.AiChatDatabase());
    gh.lazySingleton<_i16.KnowledgeDatabases>(
      () => _i16.KnowledgeDatabases(),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i154.ImageAttachmentEncoder>(
      () => const _i154.ImageAttachmentEncoder(),
    );
    gh.factory<_i94.AuthModulRemoteDataSource>(
      () => _i306.AuthModulRemoteDataSourceImpl(),
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
    gh.lazySingleton<_i310.FoodApiClient>(
      () => _i310.FoodApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i395.LoginApiClient>(
      () => loginInjectableModule.loginApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i699.ProfileApiClient>(
      () => _i699.ProfileApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i723.ExerciseModuleApiClient>(
      () => _i723.ExerciseModuleApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i329.FoodRemoteDataSourceContract>(
      () => _i521.FoodRemoteDataSourceImpl(gh<_i310.FoodApiClient>()),
    );
    gh.lazySingleton<_i325.LoginLocalDataSourceContract>(
      () => _i438.LoginLocalDataSourceImpl(
        gh<_i460.SharedPreferences>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
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
    gh.lazySingleton<_i736.LoginRemoteDataSourceContract>(
      () => _i904.LoginRemoteDataSourceImpl(gh<_i395.LoginApiClient>()),
    );
    gh.factory<_i966.FoodRepositoryContract>(
      () => _i860.FoodRepositoryImpl(gh<_i329.FoodRemoteDataSourceContract>()),
    );
    gh.lazySingleton<_i453.AuthRemoteDataSourceContract>(
      () => _i723.AuthRemoteDataSourceImpl(gh<_i824.AuthApiClient>()),
    );
    gh.lazySingleton<_i912.KnowledgeLocalDatasource>(
      () => _i912.KnowledgeLocalDatasource(gh<_i16.KnowledgeDatabases>()),
    );
    gh.lazySingleton<_i437.AiChatLocalDatasource>(
      () => _i437.AiChatLocalDatasource(gh<_i581.AiChatDatabase>()),
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
    gh.lazySingleton<_i801.SocialAuthDataSourceContract>(
      () => _i943.AuthModulSocialAuthDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i872.MetaHorizonAuthService>(),
      ),
    );
    gh.lazySingleton<_i961.ProfileRemoteDataSourceContract>(
      () => _i4.ProfileRemoteDataSourceImpl(gh<_i699.ProfileApiClient>()),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(
        gh<_i961.ProfileRemoteDataSourceContract>(),
        gh<_i589.UserHelper>(),
      ),
    );
    gh.lazySingleton<_i902.LoginRepository>(
      () => _i1066.LoginRepositoryImpl(
        gh<_i736.LoginRemoteDataSourceContract>(),
        gh<_i325.LoginLocalDataSourceContract>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i453.AuthRemoteDataSourceContract>(),
        gh<_i271.AuthLocalDataSourceContract>(),
        gh<_i801.SocialAuthDataSourceContract>(),
        gh<_i104.UserFirestoreService>(),
      ),
    );
    gh.factory<_i484.GetFoodCategoriesUseCase>(
      () => _i484.GetFoodCategoriesUseCase(gh<_i966.FoodRepositoryContract>()),
    );
    gh.factory<_i201.GetMealDetailsUseCase>(
      () => _i201.GetMealDetailsUseCase(gh<_i966.FoodRepositoryContract>()),
    );
    gh.factory<_i681.GetMealsByCategoryUseCase>(
      () => _i681.GetMealsByCategoryUseCase(gh<_i966.FoodRepositoryContract>()),
    );
    gh.factory<_i566.AuthModulRepository>(
      () => _i515.AuthModulRepositoryImpl(
        remoteDataSource: gh<_i94.AuthModulRemoteDataSource>(),
        socialAuthDataSource: gh<_i801.SocialAuthDataSourceContract>(),
      ),
    );
    gh.lazySingleton<_i969.AiToolRegistry>(
      () => _i969.AiToolRegistry(gh<_i912.KnowledgeLocalDatasource>()),
    );
    gh.lazySingleton<_i442.FastPathRecognizer>(
      () => _i442.FastPathRecognizer(gh<_i912.KnowledgeLocalDatasource>()),
    );
    gh.factory<_i685.FoodRecommendationCubit>(
      () =>
          _i685.FoodRecommendationCubit(gh<_i681.GetMealsByCategoryUseCase>()),
    );
    gh.factory<_i112.ExerciseRepository>(
      () => _i1072.ExerciseRepositoryImpl(gh<_i868.ExerciseRemoteDataSource>()),
    );
    gh.lazySingleton<_i646.OllamaRepository>(
      () => _i508.OllamaRepositoryImpl(
        gh<_i803.OllamaRemoteDatasource>(),
        gh<_i912.KnowledgeLocalDatasource>(),
        gh<_i969.AiToolRegistry>(),
        gh<_i442.FastPathRecognizer>(),
        gh<_i154.ImageAttachmentEncoder>(),
      ),
    );
    gh.lazySingleton<_i487.AiChatHistoryRepository>(
      () =>
          _i165.AiChatHistoryRepositoryImpl(gh<_i437.AiChatLocalDatasource>()),
    );
    gh.lazySingleton<_i967.UploadPhotoUseCase>(
      () => _i967.UploadPhotoUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i198.GetDifficultyLevelsUseCase>(
      () => _i198.GetDifficultyLevelsUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i692.GetExercisesUseCase>(
      () => _i692.GetExercisesUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i487.GetMuscleGroupsUseCase>(
      () => _i487.GetMuscleGroupsUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i735.GetMusclesByGroupUseCase>(
      () => _i735.GetMusclesByGroupUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i467.GetRandomMusclesUseCase>(
      () => _i467.GetRandomMusclesUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i1072.DetailsFoodCubit>(
      () => _i1072.DetailsFoodCubit(gh<_i201.GetMealDetailsUseCase>()),
    );
    gh.factory<_i266.ChangePasswordUseCase>(
      () => _i266.ChangePasswordUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i546.DeleteAccountUseCase>(
      () => _i546.DeleteAccountUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i110.GetProfileUseCase>(
      () => _i110.GetProfileUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i332.LogoutUseCase>(
      () => _i332.LogoutUseCase(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i186.UpdateProfileUseCase>(
      () => _i186.UpdateProfileUseCase(gh<_i894.ProfileRepository>()),
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
    gh.factory<_i753.LoginCubit>(
      () => _i753.LoginCubit(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i215.ExerciseModuleCubit>(
      () => _i215.ExerciseModuleCubit(
        gh<_i692.GetExercisesUseCase>(),
        gh<_i198.GetDifficultyLevelsUseCase>(),
      ),
    );
    gh.factory<_i1039.HomeCubit>(
      () => _i1039.HomeCubit(
        gh<_i487.GetMuscleGroupsUseCase>(),
        gh<_i467.GetRandomMusclesUseCase>(),
        gh<_i735.GetMusclesByGroupUseCase>(),
        gh<_i110.GetProfileUseCase>(),
        gh<_i589.UserHelper>(),
      ),
    );
    gh.factory<_i788.GetAiUserContextUseCase>(
      () => _i788.GetAiUserContextUseCase(
        gh<_i589.UserHelper>(),
        gh<_i487.AiChatHistoryRepository>(),
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
    gh.factory<_i355.WorkoutCubit>(
      () => _i355.WorkoutCubit(
        gh<_i487.GetMuscleGroupsUseCase>(),
        gh<_i735.GetMusclesByGroupUseCase>(),
        gh<_i692.GetExercisesUseCase>(),
        gh<_i467.GetRandomMusclesUseCase>(),
      ),
    );
    gh.factory<_i601.DeleteConversationUseCase>(
      () =>
          _i601.DeleteConversationUseCase(gh<_i487.AiChatHistoryRepository>()),
    );
    gh.factory<_i61.GetConversationMessagesUseCase>(
      () => _i61.GetConversationMessagesUseCase(
        gh<_i487.AiChatHistoryRepository>(),
      ),
    );
    gh.factory<_i606.GetConversationsUseCase>(
      () => _i606.GetConversationsUseCase(gh<_i487.AiChatHistoryRepository>()),
    );
    gh.factory<_i219.SaveChatMessageUseCase>(
      () => _i219.SaveChatMessageUseCase(gh<_i487.AiChatHistoryRepository>()),
    );
    gh.factory<_i1051.StartConversationUseCase>(
      () =>
          _i1051.StartConversationUseCase(gh<_i487.AiChatHistoryRepository>()),
    );
    gh.factory<_i1069.UpdateChatMessageUseCase>(
      () =>
          _i1069.UpdateChatMessageUseCase(gh<_i487.AiChatHistoryRepository>()),
    );
    gh.factory<_i667.ForgetPasswordCubit>(
      () => _i667.ForgetPasswordCubit(
        gh<_i42.ForgetPasswordUseCase>(),
        gh<_i215.VerifyOtpUseCase>(),
        gh<_i840.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i219.SendAgentMessageUseCase>(
      () => _i219.SendAgentMessageUseCase(gh<_i646.OllamaRepository>()),
    );
    gh.factory<_i76.SignUpCubit>(
      () => _i76.SignUpCubit(
        gh<_i124.SignUpUseCase>(),
        gh<_i123.SocialSignInUseCase>(),
        gh<_i104.UserFirestoreService>(),
      ),
    );
    gh.factory<_i599.AiAgentCubit>(
      () => _i599.AiAgentCubit(
        gh<_i219.SendAgentMessageUseCase>(),
        gh<_i606.GetConversationsUseCase>(),
        gh<_i61.GetConversationMessagesUseCase>(),
        gh<_i1051.StartConversationUseCase>(),
        gh<_i219.SaveChatMessageUseCase>(),
        gh<_i1069.UpdateChatMessageUseCase>(),
        gh<_i601.DeleteConversationUseCase>(),
        gh<_i589.UserHelper>(),
        gh<_i110.GetProfileUseCase>(),
        gh<_i788.GetAiUserContextUseCase>(),
      ),
    );
    gh.factory<_i967.ProfileCubit>(
      () => _i967.ProfileCubit(
        gh<_i110.GetProfileUseCase>(),
        gh<_i186.UpdateProfileUseCase>(),
        gh<_i967.UploadPhotoUseCase>(),
        gh<_i266.ChangePasswordUseCase>(),
        gh<_i546.DeleteAccountUseCase>(),
        gh<_i332.LogoutUseCase>(),
      ),
    );
    return this;
  }
}

class _$CoreInjectableModule extends _i291.CoreInjectableModule {}

class _$AuthInjectableModule extends _i563.AuthInjectableModule {}

class _$LoginInjectableModule extends _i871.LoginInjectableModule {}
