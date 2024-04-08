import 'package:stock_management_tool/features/auth/domain/repositories/auth_repository.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/services/auth.dart';

class AuthRepositoryImplementation implements AuthRepository {
  @override
  Future signInUser({required String email, required String password}) async {
    return await sl.get<Auth>().signInUser(email: email, password: password);
  }

  @override
  Future signUpUser(
      {required String username, required String email, required String password}) async {
    return await sl.get<Auth>().signUpUser(username: username, email: email, password: password);
  }
}