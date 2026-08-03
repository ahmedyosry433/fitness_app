import 'dart:io';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';
import 'package:fitness/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Result<UserEntity>> call({
    required String name,
    String? email,
    int? weight,
    String? goal,
    String? activityLevel,
  }) => repository.updateProfile(
    name: name,
    email: email,
    weight: weight,
    goal: goal,
    activityLevel: activityLevel,
  );
}
