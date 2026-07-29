import 'package:equatable/equatable.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';

class ProfileUIModel extends Equatable {
  final UserEntity? user;
  final bool isLoggedOut;
  final bool isAccountDeleted;
  
  const ProfileUIModel({
    this.user,
    this.isLoggedOut = false,
    this.isAccountDeleted = false,
  }); 

  ProfileUIModel copyWith({
    UserEntity? user,
    bool? isLoggedOut,
    bool? isAccountDeleted,
  }) {
    return ProfileUIModel(
      user: user ?? this.user,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
    );
  }

  @override
  List<Object?> get props => [user, isLoggedOut, isAccountDeleted];
}
