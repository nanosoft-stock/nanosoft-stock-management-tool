abstract class AuthRepository {
  Future signInUser({required String email, required String password});

  Future signUpUser(
      {required String username,
      required String email,
      required String password});
}
