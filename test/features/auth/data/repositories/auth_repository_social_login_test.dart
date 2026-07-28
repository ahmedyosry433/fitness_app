import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:fitness/features/auth/data/datasources/auth_remote_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth_modul/data/datasources/social_auth_data_source_contract.dart';
import 'package:fitness/features/auth_modul/data/models/social_account_model.dart';
import 'package:fitness/features/auth_modul/data/services/user_firestore_service.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements AuthRemoteDataSourceContract {}

class MockLocalDataSource extends Mock implements AuthLocalDataSourceContract {}

class MockSocialAuthDataSource extends Mock
    implements SocialAuthDataSourceContract {}

class MockUserFirestoreService extends Mock implements UserFirestoreService {}

void main() {
  late MockRemoteDataSource remote;
  late MockLocalDataSource local;
  late MockSocialAuthDataSource social;
  late MockUserFirestoreService firestore;
  late AuthRepositoryImpl repository;

  const uid = 'firebase-uid-1';
  const email = 'social@user.com';

  const completeProfile = <String, dynamic>{
    'uid': uid,
    'name': 'Social User',
    'email': email,
    'phone': '0100',
    'gender': 'male',
    'age': 25,
    'weight': 80,
    'height': 175,
  };

  SocialAccountModel account({required bool isNewUser}) => SocialAccountModel(
    uid: uid,
    name: 'Social User',
    email: email,
    photoUrl: '',
    isNewUser: isNewUser,
  );

  setUpAll(() {
    registerFallbackValue(const LoginParams());
    registerFallbackValue(const AuthUserEntity());
  });

  setUp(() {
    remote = MockRemoteDataSource();
    local = MockLocalDataSource();
    social = MockSocialAuthDataSource();
    firestore = MockUserFirestoreService();
    repository = AuthRepositoryImpl(remote, local, social, firestore);

    when(
      () => local.saveUser(any()),
    ).thenAnswer((_) async => const Success(data: null));
  });

  test(
    'first social sign in is flagged as new user and never calls the API signin',
    () async {
      when(
        () => social.signIn(AuthSocialProvider.google),
      ).thenAnswer((_) async => account(isNewUser: true));
      when(() => firestore.getUserProfile(uid)).thenAnswer((_) async => null);
      when(
        () => firestore.getUserProfileByEmail(email),
      ).thenAnswer((_) async => null);

      final result = await repository.socialLogin(
        provider: AuthSocialProvider.google,
      );

      expect(result, isA<Success>());
      expect((result as Success).data?.isNewUser, isTrue);
      verifyNever(() => remote.login(params: any(named: 'params')));
      verifyNever(() => local.saveUser(any()));
    },
  );

  test(
    'known Firebase account without a completed profile still needs completion',
    () async {
      when(
        () => social.signIn(AuthSocialProvider.google),
      ).thenAnswer((_) async => account(isNewUser: false));
      when(() => firestore.getUserProfile(uid)).thenAnswer(
        (_) async => const {'uid': uid, 'name': 'Social User', 'email': email},
      );

      final result = await repository.socialLogin(
        provider: AuthSocialProvider.google,
      );

      expect((result as Success).data?.isNewUser, isTrue);
      verifyNever(() => remote.login(params: any(named: 'params')));
    },
  );

  test(
    'registered social user signs in and gets the API token cached',
    () async {
      when(
        () => social.signIn(AuthSocialProvider.google),
      ).thenAnswer((_) async => account(isNewUser: false));
      when(
        () => firestore.getUserProfile(uid),
      ).thenAnswer((_) async => completeProfile);
      when(() => remote.login(params: any(named: 'params'))).thenAnswer(
        (_) async => const Success(data: AuthResponseModel(token: 'jwt-123')),
      );

      final result = await repository.socialLogin(
        provider: AuthSocialProvider.google,
      );

      final socialResult = (result as Success).data;
      expect(socialResult?.isNewUser, isFalse);
      expect(socialResult?.user.token, 'jwt-123');
      verify(() => local.saveUser(any())).called(1);
    },
  );

  test(
    'registered social user falls back to the uid when API signin fails',
    () async {
      when(
        () => social.signIn(AuthSocialProvider.google),
      ).thenAnswer((_) async => account(isNewUser: false));
      when(
        () => firestore.getUserProfile(uid),
      ).thenAnswer((_) async => completeProfile);
      when(() => remote.login(params: any(named: 'params'))).thenAnswer(
        (_) async => Error<AuthResponseModel>(exception: Exception('401')),
      );

      final result = await repository.socialLogin(
        provider: AuthSocialProvider.google,
      );

      expect((result as Success).data?.user.token, uid);
    },
  );
}
