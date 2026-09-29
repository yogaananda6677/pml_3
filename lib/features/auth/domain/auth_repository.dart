import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendEmailVerification();
  Future<void> updateDisplayName(String displayName);
  Future<void> signOut();
  User? getCurrentUser();
}
