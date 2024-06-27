import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/services/auth.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  @override
  Future signInUser({required String email, required String password}) async {
    return await sl.get<Auth>().signInUser(email: email, password: password);
  }

  @override
  Future signUpUser({
    required String username,
    required String email,
    required String password,
  }) async {
    await sl
        .get<Auth>()
        .signUpUser(username: username, email: email, password: password);

    await sl.get<Firestore>().createDocument(path: "users", data: {
      "email": email,
      "username": CaseHelper.convert("title", username)
    });

    return;
  }
}
