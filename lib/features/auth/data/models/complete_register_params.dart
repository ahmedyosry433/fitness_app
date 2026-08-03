class CompleteRegisterParams {
  final String? uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String? rePassword;
  final String? photoUrl;
  final bool isSocial;

  const CompleteRegisterParams({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.rePassword,
    this.photoUrl,
    this.isSocial = false,
  });
}
