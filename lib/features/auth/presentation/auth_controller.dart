import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pml_3/features/auth/data/firebase_auth_repository.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<FirebaseAuthRepository>(
    (ref) => FirebaseAuthRepository(ref.read(firebaseAuthProvider)));

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.read(authRepositoryProvider).authStateChanges);

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>(
    (ref) => AuthController(ref.read(authRepositoryProvider)));

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final FirebaseAuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null)) {
    _authRepository.authStateChanges.listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(email, password);
      state = AsyncValue.data(userCredential.user);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e("Sign in failed: ${e.code} - ${e.message}", error: e, stackTrace: st);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e("Sign in failed: $e", error: e, stackTrace: st);
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String displayName) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _authRepository.createUserWithEmailAndPassword(email, password);
      await _authRepository.updateDisplayName(displayName);
      await _authRepository.sendEmailVerification();
      state = AsyncValue.data(userCredential.user);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e("Create user failed: ${e.code} - ${e.message}", error: e, stackTrace: st);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e("Create user failed: $e", error: e, stackTrace: st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e("Sign out failed: $e", error: e, stackTrace: st);
    }
  }

  User? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }
}
