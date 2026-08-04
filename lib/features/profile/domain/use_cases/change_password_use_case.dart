import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Result<void>> call({
    required String oldPassword,
    required String newPassword,
  }) => repository.changePassword(
    oldPassword: oldPassword,
    newPassword: newPassword,
  );
}
