import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/login/data/datasources/login_local_data_source_contract.dart';
import 'package:fitness/features/login/data/datasources/login_remote_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSourceContract _remoteDataSource;
  final LoginLocalDataSourceContract _localDataSource;

  LoginRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<AuthUserEntity>> login({required LoginParams params}) async {
    final result = await _remoteDataSource.login(params: params);

    if (result is Success<AuthResponseModel>) {
      final data = result.data;
      if (data == null) return const Error(exception: null);
      final user = data.toEntity();
      await _localDataSource.saveUser(user);
      return Success(data: user);
    }

    return Error(exception: (result as Error<AuthResponseModel>).exception);
  }
}
