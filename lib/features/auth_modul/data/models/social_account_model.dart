class SocialAccountModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  /// `true` when this sign-in created the Firebase account, i.e. the very first
  /// time this social identity is seen by the project.
  final bool isNewUser;

  const SocialAccountModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.isNewUser = false,
  });
}
