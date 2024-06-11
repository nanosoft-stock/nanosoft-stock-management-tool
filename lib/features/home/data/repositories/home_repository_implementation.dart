import 'package:stock_management_tool/core/services/auth.dart';
import 'package:stock_management_tool/features/home/domain/repositories/home_repository.dart';
import 'package:stock_management_tool/injection_container.dart';

class HomeRepositoryImplementation implements HomeRepository {
  @override
  Future<void> signOutUser() async {
    return await sl.get<Auth>().signOutUser();
  }
}
