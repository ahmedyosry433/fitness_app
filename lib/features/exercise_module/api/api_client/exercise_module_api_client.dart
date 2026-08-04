import 'package:dio/dio.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/exercise_module/data/models/difficulty_level_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/exercise_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/muscle_group_details_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/muscles_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/random_muscles_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'exercise_module_api_client.g.dart';

@injectable
@RestApi(baseUrl: AppEndPoints.baseUrl)
abstract class ExerciseModuleApiClient {
  @factoryMethod
  factory ExerciseModuleApiClient(Dio dio) = _ExerciseModuleApiClient;

  @GET(AppEndPoints.exercisesByMuscleAndDifficulty)
  Future<ExerciseResponseModel> getExercises(
    @Query(AppEndPoints.primeMoverMuscleIdParam) String primeMoverMuscleId,
    @Query(AppEndPoints.difficultyLevelIdParam) String difficultyLevelId,
  );

  @GET(AppEndPoints.difficultyLevels)
  Future<DifficultyLevelResponseModel> getDifficultyLevels(
    @Query(AppEndPoints.primeMoverMuscleIdParam) String primeMoverMuscleId,
  );

  @GET(AppEndPoints.muscles)
  Future<MusclesResponseModel> getMuscleGroups();

  @GET(AppEndPoints.musclesRandom)
  Future<RandomMusclesResponseModel> getRandomMuscles();

  @GET(AppEndPoints.musclesGroupById)
  Future<MuscleGroupDetailsResponseModel> getMusclesByGroupId(
    @Path('id') String muscleGroupId,
  );
}
