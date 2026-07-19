import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/config/firebase/firebase_auth_config.dart';
import 'package:fitness/features/auth_modul/data/models/social_account_model.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:fitness/features/auth_modul/data/datasources/social_auth_data_source_contract.dart';
import 'package:fitness/features/auth_modul/data/services/meta_horizon_auth_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SocialAuthDataSourceContract)
class AuthModulSocialAuthDataSourceImpl
    implements SocialAuthDataSourceContract {
  final FirebaseAuth _firebaseAuth;
  final MetaHorizonAuthService _metaHorizonAuthService;

  AuthModulSocialAuthDataSourceImpl(
    this._firebaseAuth,
    this._metaHorizonAuthService,
  );

  Future<void>? _googleInitialization;

  Future<void> _ensureGoogleInitialized() {
    return _googleInitialization ??= GoogleSignIn.instance.initialize(
      serverClientId: FirebaseAuthConfig.googleServerClientId,
    );
  }

  @override
  Future<SocialAccountModel> signIn(AuthSocialProvider provider) async {
    if (provider == AuthSocialProvider.google) {
      return _googleDirectSignIn();
    }

    if (provider == AuthSocialProvider.metaHorizon) {
      return _metaHorizonSignIn();
    }

    final credential = switch (provider) {
      AuthSocialProvider.google => throw StateError(
        'Google is handled directly via OAuth.',
      ),
      AuthSocialProvider.facebook => await _facebookCredential(),
      AuthSocialProvider.apple => throw Exception(
        'Apple sign in is not supported yet.',
      ),
      AuthSocialProvider.metaHorizon => throw StateError(
        'Meta Horizon is handled separately in signIn.',
      ),
    };

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw Exception('Sign in failed: no Firebase user was returned.');
    }

    return SocialAccountModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }

  Future<SocialAccountModel> _googleDirectSignIn() async {
    await _ensureGoogleInitialized();

    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      throw Exception('Google sign in is not supported on this platform.');
    }

    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw Exception('Google sign in failed: missing id token.');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception(
          'Google sign in failed: no Firebase user was returned.',
        );
      }

      return SocialAccountModel(
        uid: user.uid,
        name: user.displayName ?? account.displayName ?? '',
        email: user.email ?? account.email,
        photoUrl: user.photoURL ?? account.photoUrl ?? '',
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Google sign in was cancelled.');
      }
      rethrow;
    }
  }

  Future<SocialAccountModel> _metaHorizonSignIn([String? accessToken]) async {
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception(
        'Meta Horizon sign in requires a valid access token. '
        'Configure your Meta Horizon App ID in MetaHorizonConfig.',
      );
    }
    return _metaHorizonAuthService.fetchHorizonProfile(accessToken);
  }

  Future<OAuthCredential> _facebookCredential() async {
    final result = await FacebookAuth.instance.login();

    switch (result.status) {
      case LoginStatus.success:
        final token = result.accessToken;
        if (token == null) {
          throw Exception('Facebook sign in failed: missing access token.');
        }
        return FacebookAuthProvider.credential(token.tokenString);
      case LoginStatus.cancelled:
        throw Exception('Facebook sign in was cancelled.');
      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        throw Exception(
          result.message ?? 'Facebook sign in failed. Please try again.',
        );
    }
  }

  @override
  Future<void> linkEmailPassword({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null || email.isEmpty) return;

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      const ignorable = {
        'provider-already-linked',
        'credential-already-in-use',
        'email-already-in-use',
        'requires-recent-login',
      };
      if (ignorable.contains(e.code)) {
        log('linkEmailPassword skipped: ${e.code}', name: 'SocialAuth');
        return;
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      GoogleSignIn.instance.signOut(),
      FacebookAuth.instance.logOut(),
    ]);
  }
}
