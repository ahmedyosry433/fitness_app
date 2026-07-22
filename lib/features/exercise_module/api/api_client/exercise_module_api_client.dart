import 'package:dio/dio.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/exercise_module/data/models/difficulty_level_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/exercise_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'exercise_module_api_client.g.dart';

@injectable
@RestApi(baseUrl: AppEndPoints.baseUrl)
abstract class ExerciseModuleApiClient {
  @factoryMethod
  factory ExerciseModuleApiClient(Dio dio) = _ExerciseModuleApiClient;

  @GET('/exercises')
  Future<ExerciseResponseModel> getExercises();

  @GET('/difficulty-levels')
  Future<DifficultyLevelResponseModel> getDifficultyLevels(@Query('primeMoverMuscleId') String primeMoverMuscleId);
}
