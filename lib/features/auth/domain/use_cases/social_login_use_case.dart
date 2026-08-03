import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/domain/entities/auth_social_result.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:injectable/injectable.dart';

@injectable
class SocialLoginUseCase {
  final AuthRepository _repository;

  SocialLoginUseCase(this._repository);

  Future<Result<AuthSocialResult>> call({
    required AuthSocialProvider provider,
  }) {
    return _repository.socialLogin(provider: provider);
  }
}
