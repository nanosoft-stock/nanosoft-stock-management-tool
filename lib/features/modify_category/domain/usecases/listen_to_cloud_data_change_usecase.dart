import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/repositories/modify_category_repository.dart';

class ListenToCloudDataChangeModifyCategoryUseCase extends UseCase {
  ListenToCloudDataChangeModifyCategoryUseCase(this._modifyCategoryRepository);

  final ModifyCategoryRepository _modifyCategoryRepository;

  @override
  Future call({params}) async {
    return _modifyCategoryRepository.listenToCloudDataChange(
        modifyCategoryData: params["modify_category_data"],
        onChange: params["on_change"]);
  }
}
