import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _auth.currentUser?.updateDisplayName(username);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
