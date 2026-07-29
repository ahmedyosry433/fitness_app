import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<Result<void>> call() => repository.deleteAccount();
}
