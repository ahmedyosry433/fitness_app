import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';

abstract class LoginRemoteDataSourceContract {
  Future<Result<AuthResponseModel>> login({required LoginParams params});
}
