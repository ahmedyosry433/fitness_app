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
    gh.factory<_i329.FoodRemoteDataSourceContract>(
      () => _i521.FoodRemoteDataSourceImpl(
        foodRemoteDataSourceImpl: gh<_i521.FoodRemoteDataSourceImpl>(),
      ),
    );
    gh.lazySingleton<_i310.FoodApiClient>(
      () => _i310.FoodApiClient(gh<_i361.Dio>()),
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
    gh.factory<_i966.FoodRepositoryContract>(
      () => _i860.FoodRepositoryImpl(gh<_i329.FoodRemoteDataSourceContract>()),
    );
    gh.lazySingleton<_i912.KnowledgeLocalDatasource>(
      () => _i912.KnowledgeLocalDatasource(gh<_i16.KnowledgeDatabases>()),
    );
    gh.lazySingleton<_i437.AiChatLocalDatasource>(
      () => _i437.AiChatLocalDatasource(gh<_i581.AiChatDatabase>()),
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
    gh.lazySingleton<_i969.AiToolRegistry>(
      () => _i969.AiToolRegistry(gh<_i912.KnowledgeLocalDatasource>()),
    );
    gh.lazySingleton<_i442.FastPathRecognizer>(
      () => _i442.FastPathRecognizer(gh<_i912.KnowledgeLocalDatasource>()),
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
    gh.factory<_i198.GetDifficultyLevelsUseCase>(
      () => _i198.GetDifficultyLevelsUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i692.GetExercisesUseCase>(
      () => _i692.GetExercisesUseCase(gh<_i112.ExerciseRepository>()),
    );
    gh.factory<_i215.ExerciseModuleCubit>(
      () => _i215.ExerciseModuleCubit(
        gh<_i692.GetExercisesUseCase>(),
        gh<_i198.GetDifficultyLevelsUseCase>(),
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
    gh.factory<_i219.SendAgentMessageUseCase>(
      () => _i219.SendAgentMessageUseCase(gh<_i646.OllamaRepository>()),
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
      ),
    );
    return this;
  }
}

class _$CoreInjectableModule extends _i291.CoreInjectableModule {}
