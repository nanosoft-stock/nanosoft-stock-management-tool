import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_management_tool/constants/constants.dart';

class AuthDefault {
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
    userName = currentUser!.displayName!;
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
    userName = currentUser!.displayName!;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
