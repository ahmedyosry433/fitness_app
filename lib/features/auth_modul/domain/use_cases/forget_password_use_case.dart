import 'package:fitness/features/auth_modul/domain/repositories/auth_modul_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart'; // عدل المسار حسب الـ config عندك
import '../../data/models/request/forget_password_request.dart';
import '../../data/models/response/auth_common_response.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthModulRepository _repository;

  ForgetPasswordUseCase(this._repository);

  Future<Result<AuthCommonResponse>> call(ForgetPasswordRequest request) async {
    return await _repository.forgetPassword(request);
  }
}
