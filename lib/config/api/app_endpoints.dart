class AppEndPoints {
  AppEndPoints._();
  static const String baseUrl = 'https://fitness.elevateegy.com/api/v1';
  static const String getProductsEndpoint = '$baseUrl/products';
  static const String getCategoriesEndpoint = '$baseUrl/categories';
  static const String refreshToken = '$baseUrl/refresh-token';
  static const String exercisesEndpoint = '$baseUrl/exercises';
  static const String getRandomExercisesEndpoint = '$baseUrl/exercises/random';
  static const String exercisesByMuscleAndDifficultyEndpoint =
      '$baseUrl/exercises/by-muscle-difficulty';
  static const String exercises = '/exercises';
  static const String exercisesByMuscleAndDifficulty = '/exercises/by-muscle-difficulty';
  static const String difficultyLevels = '/levels';
  static const String primeMoverMuscleIdParam = 'primeMoverMuscleId';
  static const String difficultyLevelIdParam = 'difficultyLevelId';
}
