import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/features/auth_modul/api/datasources/social_auth_data_source_impl.dart';
import 'package:fitness/features/auth_modul/data/services/meta_horizon_auth_service.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockMetaHorizonAuthService extends Mock
    implements MetaHorizonAuthService {}

class MockOAuthCredential extends Mock implements OAuthCredential {}

void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockMetaHorizonAuthService metaHorizonService;
  late AuthModulSocialAuthDataSourceImpl dataSource;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    metaHorizonService = MockMetaHorizonAuthService();
    dataSource = AuthModulSocialAuthDataSourceImpl(
      firebaseAuth,
      metaHorizonService,
    );
  });

  test(
    'throws clean exception when account-exists-with-different-credential occurs',
    () async {
      final credential = MockOAuthCredential();
      when(
        () => firebaseAuth.signInWithCredential(credential),
      ).thenThrow(
        FirebaseAuthException(
          code: 'account-exists-with-different-credential',
          message:
              'An account already exists with the same email address but different sign-in credentials.',
        ),
      );

      expect(
        () async => firebaseAuth.signInWithCredential(credential),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'account-exists-with-different-credential',
          ),
        ),
      );
    },
  );
}
