import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/home/domain/repositories/home_repository.dart';

class SignOutUserUseCase extends UseCase {
  SignOutUserUseCase(this._homeRepository);

  final HomeRepository _homeRepository;

  @override
  Future call({params}) async {
    return await _homeRepository.signOutUser();
  }
}
