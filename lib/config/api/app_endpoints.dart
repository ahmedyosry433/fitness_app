class AppEndPoints {
  AppEndPoints._();
  static const String baseUrl = 'https://fitness.elevateegy.com/api/v1';
  static const String baseUrlFood = 'https://www.themealdb.com/api/json/v1/1';
  static const String getProductsEndpoint = '$baseUrl/products';
  static const String getCategoriesEndpoint = '$baseUrl/categories';
  static const String refreshToken = '$baseUrl/refresh-token';

  static const String signIn = '/auth/signin';
  static const String signUp = '/auth/signup';
  static const String forgotPassword = '/auth/forgotPassword';
  static const String mealDetailsEndpoint = '/lookup.php';

  static const String exercisesEndpoint = '$baseUrl/exercises';
  static const String getRandomExercisesEndpoint = '$baseUrl/exercises/random';
  static const String exercisesByMuscleAndDifficultyEndpoint =
      '$baseUrl/exercises/by-muscle-difficulty';
  static const String exercises = '/exercises';
  static const String exercisesByMuscleAndDifficulty =
      '/exercises/by-muscle-difficulty';
  static const String difficultyLevels = '/levels';
  static const String muscles = '/muscles';
  static const String musclesRandom = '/muscles/random';
  static const String musclesGroupById = '/musclesGroup/{id}';
  static const String primeMoverMuscleIdParam = 'primeMoverMuscleId';
  static const String difficultyLevelIdParam = 'difficultyLevelId';
  static const String resetPassword = '/auth/resetPassword';
  static const String deleteMe = '/auth/deleteMe';
  static const String logout = '/auth/logout';
  static const String editProfile = '/auth/editProfile';
  static const String nameParam = 'name';
  static const String photoParam = 'photo';
  static const String changePassword = '/auth/change-password';
  static const String uploadPhoto = '/auth/upload-photo';
  static const String profileData = '/auth/profile-data';
}
