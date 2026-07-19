import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth_modul/data/datasources/auth_modul_remote_data_source_contract.dart';
import 'package:fitness/features/auth_modul/domain/repositories/auth_modul_repository.dart';
import 'package:injectable/injectable.dart';

import '../models/request/forget_password_request.dart';
import '../models/request/reset_password_request.dart';
import '../models/request/signup_request.dart';
import '../models/response/auth_common_response.dart';

@Injectable(as: AuthModulRepository)
class AuthModulRepositoryImpl implements AuthModulRepository {
  final AuthModulRemoteDataSource remoteDataSource;

  AuthModulRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<AuthCommonResponse>> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    try {
      final response = await remoteDataSource.forgetPassword(request);
      return Success(data: response);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthCommonResponse>> verifyOtp(String email, String otp) async {
    try {
      final response = await remoteDataSource.verifyOtp(email, otp);
      return Success(data: response);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthCommonResponse>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final response = await remoteDataSource.resetPassword(request);
      return Success(data: response);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthCommonResponse>> signUp(SignUpRequest request) async {
    try {
      final response = await remoteDataSource.signUp(request);
      return Success(data: response);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }
}
