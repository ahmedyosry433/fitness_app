class AuthUserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;

  const AuthUserEntity({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.token = '',
  });

  factory AuthUserEntity.empty() => const AuthUserEntity();

  factory AuthUserEntity.fake() => const AuthUserEntity(
        id: 'fake-id',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '01234567890',
        token: 'fake-token',
      );
}
