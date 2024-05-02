import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/auth/domain/repositories/auth_repository.dart';

class SignInUserUseCase extends UseCase {
  SignInUserUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future call({params}) async {
    return await _authRepository.signInUser(
        email: params['email'], password: params['password']);
  }
}
