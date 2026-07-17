class AppEndPoints {
  AppEndPoints._();
  static const String baseUrl = 'https://ecommerce.routemisr.com/api/v1';
  static const String getProductsEndpoint = '$baseUrl/products';
  static const String getCategoriesEndpoint = '$baseUrl/categories';
  static const String refreshToken = '$baseUrl/refresh-token';

  static const String signIn = '/auth/signin';
  static const String signUp = '/auth/signup';
  static const String forgotPassword = '/auth/forgotPassword';
}
