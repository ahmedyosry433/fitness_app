import 'package:fitness/features/auth_modul/domain/repositories/auth_modul_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../data/models/response/auth_common_response.dart';

@injectable
class VerifyOtpUseCase {
  final AuthModulRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<Result<AuthCommonResponse>> call(String email, String otp) async {
    return await _repository.verifyOtp(email, otp);
  }
}
