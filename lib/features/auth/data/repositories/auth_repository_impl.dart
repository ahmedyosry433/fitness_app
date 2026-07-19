import 'dart:developer';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:fitness/features/auth/data/datasources/auth_remote_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth_modul/data/datasources/social_auth_data_source_contract.dart';
import 'package:fitness/features/auth_modul/data/services/user_firestore_service.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthLocalDataSourceContract _localDataSource;
  final SocialAuthDataSourceContract _socialAuthDataSource;
  final UserFirestoreService _userFirestoreService;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._socialAuthDataSource,
    this._userFirestoreService,
  );

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
  Future<Result<AuthUserEntity>> socialLogin({
    required AuthSocialProvider provider,
  }) async {
    try {
      final account = await _socialAuthDataSource.signIn(provider);
      final user = AuthUserEntity(
        id: account.uid,
        name: account.name,
        email: account.email,
        token: account.uid,
      );
      await _localDataSource.saveUser(user);
      try {
        await _userFirestoreService.saveUserProfile(
          uid: account.uid,
          name: account.name,
          email: account.email,
          photoUrl: account.photoUrl,
        );
      } catch (e) {
        log('Firestore save profile non-fatal: $e', name: 'AuthRepository');
      }
      return Success(data: user);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
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

