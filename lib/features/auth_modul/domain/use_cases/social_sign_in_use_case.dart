import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth_modul/data/models/social_account_model.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:fitness/features/auth_modul/domain/repositories/auth_modul_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SocialSignInUseCase {
  final AuthModulRepository _repository;

  SocialSignInUseCase(this._repository);

  Future<Result<SocialAccountModel>> call(AuthSocialProvider provider) {
    return _repository.socialSignIn(provider);
  }
}
