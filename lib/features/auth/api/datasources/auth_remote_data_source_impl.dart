import 'package:fitness/config/api/api_executer.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/api/api_client/auth_api_client.dart';
import 'package:fitness/features/auth/data/datasources/auth_remote_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<AuthResponseModel>> login({required LoginParams params}) {
    return executeApi(() => _apiClient.login(params));
  }

  @override
  Future<Result<AuthResponseModel>> register({required RegisterParams params}) {
    return executeApi(() => _apiClient.register(params));
  }

  @override
  Future<Result<void>> forgotPassword({required ForgotPasswordParams params}) {
    return executeApi(() => _apiClient.forgotPassword(params));
  }
}
