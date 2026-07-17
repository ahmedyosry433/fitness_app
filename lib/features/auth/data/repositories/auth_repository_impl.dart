import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:fitness/features/auth/data/datasources/auth_remote_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthLocalDataSourceContract _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

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

  @override
  Future<Result<AuthUserEntity>> register({
    required RegisterParams params,
  }) async {
    final result = await _remoteDataSource.register(params: params);

    if (result is Success<AuthResponseModel>) {
      final data = result.data;
      if (data == null) return const Error(exception: null);
      final user = data.toEntity();
      await _localDataSource.saveUser(user);
      return Success(data: user);
    }

    return Error(exception: (result as Error<AuthResponseModel>).exception);
  }

  @override
  Future<Result<void>> forgotPassword({
    required ForgotPasswordParams params,
  }) async {
    return _remoteDataSource.forgotPassword(params: params);
  }

  @override
  Future<Result<void>> logout() async {
    return _localDataSource.clearUser();
  }
}
