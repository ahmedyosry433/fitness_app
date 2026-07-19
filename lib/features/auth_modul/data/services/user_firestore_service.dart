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
  }) async {
    final docRef = _firestore
        .collection(FirebaseAuthConfig.usersCollection)
        .doc(uid);

    final data = <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (photoUrl != null && photoUrl.isNotEmpty) 'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(data, SetOptions(merge: true));
  }

  /// Retrieves the user profile document from Cloud Firestore.
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final docSnapshot = await _firestore
        .collection(FirebaseAuthConfig.usersCollection)
        .doc(uid)
        .get();

    return docSnapshot.data();
  }
}
