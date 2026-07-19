import 'package:fitness/config/api/api_executer.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/login/api/api_client/login_api_client.dart';
import 'package:fitness/features/login/data/datasources/login_remote_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoginRemoteDataSourceContract)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSourceContract {
  final LoginApiClient _apiClient;

  const LoginRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<AuthResponseModel>> login({required LoginParams params}) {
    return executeApi(() => _apiClient.login(params));
  }
}
