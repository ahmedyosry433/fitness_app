import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth_modul/data/models/request/signup_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import 'package:fitness/features/auth_modul/domain/repositories/auth_modul_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpUseCase {
  final AuthModulRepository _repository;

  SignUpUseCase(this._repository);

  Future<Result<AuthCommonResponse>> call(SignUpRequest request) async {
    return await _repository.signUp(request);
  }
}
