import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/config/firebase/firebase_auth_config.dart';
import 'package:injectable/injectable.dart';

/// Service responsible for storing and retrieving user profile documents in Cloud Firestore.
@lazySingleton
class UserFirestoreService {
  final FirebaseFirestore _firestore;

  UserFirestoreService(this._firestore);

  /// Saves or updates the user profile document in the `users` collection keyed by [uid].
  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    String? phone,
    String? photoUrl,
    String? gender,
    int? age,
    int? weight,
    int? height,
    String? goal,
    String? activityLevel,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseAuthConfig.usersCollection)
          .doc(uid);

      final data = <String, dynamic>{
        'uid': uid,
        'name': name,
        'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (photoUrl != null && photoUrl.isNotEmpty) 'photoUrl': photoUrl,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
        if (age != null) 'age': age,
        if (weight != null) 'weight': weight,
        if (height != null) 'height': height,
        if (goal != null && goal.isNotEmpty) 'goal': goal,
        if (activityLevel != null && activityLevel.isNotEmpty)
          'activityLevel': activityLevel,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.set(data, SetOptions(merge: true));
    } catch (e, stackTrace) {
      // Rethrown on purpose: Firestore is the source of truth for who finished
      // sign-up, so a failed write must not be reported as a completed profile.
      log(
        'Firestore saveUserProfile failed for uid $uid',
        name: 'UserFirestoreService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Retrieves the user profile document from Cloud Firestore.
  ///
  /// Returns `null` when the document does not exist.
  /// Rethrows permission-denied errors so callers can handle them.
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirebaseAuthConfig.usersCollection)
          .doc(uid)
          .get();

      if (!docSnapshot.exists) return null;
      return docSnapshot.data();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        log(
          'Firestore getUserProfile permission-denied – rethrowing',
          name: 'UserFirestoreService',
        );
        rethrow;
      }
      log('Firestore getUserProfile error: $e', name: 'UserFirestoreService');
      return null;
    } catch (e) {
      log('Firestore getUserProfile error: $e', name: 'UserFirestoreService');
      return null;
    }
  }

  /// Retrieves the user profile document from Cloud Firestore by email.
  ///
  /// Returns `null` when no matching document is found.
  /// Rethrows permission-denied errors so callers can handle them.
  Future<Map<String, dynamic>?> getUserProfileByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseAuthConfig.usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return querySnapshot.docs.first.data();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        log(
          'Firestore getUserProfileByEmail permission-denied – rethrowing',
          name: 'UserFirestoreService',
        );
        rethrow;
      }
      log(
        'Firestore getUserProfileByEmail error: $e',
        name: 'UserFirestoreService',
      );
      return null;
    } catch (e) {
      log(
        'Firestore getUserProfileByEmail error: $e',
        name: 'UserFirestoreService',
      );
      return null;
    }
  }
}
