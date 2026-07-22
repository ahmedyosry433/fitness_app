class AppEndPoints {
  AppEndPoints._();
  static const String baseUrl = 'https://fitness.elevateegy.com/api/v1';
  static const String getProductsEndpoint = '$baseUrl/products';
  static const String getCategoriesEndpoint = '$baseUrl/categories';
  static const String refreshToken = '$baseUrl/refresh-token';
  static const String exercisesEndpoint = '$baseUrl/exercises';
  static const String getRandomExercisesEndpoint =
      '$baseUrl/exercises/random?targetMuscleGroupId=69d982ed85f6bfa972bf2218&difficultyLevelId=69d982ed85f6bfa972bf2216&limit=5';
  static const String exercisesByMuscleAndDifficultyEndpoint =
      '$baseUrl/exercises/by-muscle-difficulty?primeMoverMuscleId=69d982ef85f6bfa972bf2248&difficultyLevelId=69d982ed85f6bfa972bf2216';
}
