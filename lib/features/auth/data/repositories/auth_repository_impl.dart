import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:fitness/features/auth/data/datasources/auth_remote_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth/data/social_auth_api_password.dart';
import 'package:fitness/features/auth_modul/data/datasources/social_auth_data_source_contract.dart';
import 'package:fitness/features/auth_modul/data/models/social_account_model.dart';
import 'package:fitness/features/auth_modul/data/services/user_firestore_service.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:injectable/injectable.dart';

import 'package:fitness/features/auth/domain/entities/auth_social_result.dart';

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
  Future<Result<AuthSocialResult>> socialLogin({
    required AuthSocialProvider provider,
  }) async {
    try {
      final account = await _socialAuthDataSource.signIn(provider);
      final profile = await _findUserProfile(account);
      final needsProfileCompletion =
          account.isNewUser || profile == null || !_isProfileComplete(profile);

      if (needsProfileCompletion) {
        return Success(
          data: AuthSocialResult(
            user: AuthUserEntity(
              id: account.uid,
              name: account.name,
              email: account.email,
              token: account.uid,
            ),
            isNewUser: true,
            photoUrl: account.photoUrl,
          ),
        );
      }

      final user = AuthUserEntity(
        id: (profile['uid'] as String?)?.isNotEmpty == true
            ? profile['uid'] as String
            : account.uid,
        name: (profile['name'] as String?)?.isNotEmpty == true
            ? profile['name'] as String
            : account.name,
        email: (profile['email'] as String?)?.isNotEmpty == true
            ? profile['email'] as String
            : account.email,
        phone: profile['phone'] as String? ?? '',
        token: await _fetchApiToken(
          email: account.email,
          fallbackToken: account.uid,
        ),
      );
      await _localDataSource.saveUser(user);
      return Success(
        data: AuthSocialResult(
          user: user,
          isNewUser: false,
          photoUrl: account.photoUrl,
        ),
      );
    } catch (e, stackTrace) {
      log(
        'Social sign in failed.',
        name: 'AuthRepositoryImpl',
        error: e,
        stackTrace: stackTrace,
      );
      return Error(exception: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> _findUserProfile(
    SocialAccountModel account,
  ) async {
    try {
      final profileByUid = await _userFirestoreService.getUserProfile(
        account.uid,
      );
      if (profileByUid != null) return profileByUid;
      if (account.email.isEmpty) return null;
      return await _userFirestoreService.getUserProfileByEmail(account.email);
    } on FirebaseException catch (e, stackTrace) {
      log(
        'Firestore profile lookup failed (${e.code}) – '
        'treating the user as not registered yet.',
        name: 'AuthRepositoryImpl',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  bool _isProfileComplete(Map<String, dynamic> profile) {
    const requiredFields = ['gender', 'age', 'weight', 'height'];
    return requiredFields.every((field) => profile[field] != null);
  }

  Future<String> _fetchApiToken({
    required String email,
    required String fallbackToken,
  }) async {
    if (email.isEmpty) return fallbackToken;

    final result = await _remoteDataSource.login(
      params: LoginParams(email: email, password: SocialAuthApiPassword.value),
    );
    if (result is Success<AuthResponseModel> && result.data?.token != null) {
      return result.data!.token!;
    }

    log(
      'Elevate API signin for the social account returned no token – '
      'falling back to the Firebase uid.',
      name: 'AuthRepositoryImpl',
    );
    return fallbackToken;
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
