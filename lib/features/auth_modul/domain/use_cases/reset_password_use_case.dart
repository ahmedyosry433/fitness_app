import 'package:fitness/features/auth_modul/domain/repositories/auth_modul_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../data/models/request/reset_password_request.dart';
import '../../data/models/response/auth_common_response.dart';

@injectable
class ResetPasswordUseCase {
  final AuthModulRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Result<AuthCommonResponse>> call(ResetPasswordRequest request) async {
    return await _repository.resetPassword(request);
  }
}
