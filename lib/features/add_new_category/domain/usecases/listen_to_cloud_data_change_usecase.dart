import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/repositories/add_new_category_repository.dart';

class ListenToCloudDataChangeAddNewCategoryUseCase extends UseCase {
  ListenToCloudDataChangeAddNewCategoryUseCase(this._addNewCategoryRepository);

  final AddNewCategoryRepository _addNewCategoryRepository;

  @override
  Future call({params}) async {
    return _addNewCategoryRepository.listenToCloudDataChange(
        addNewCategoryData: params["add_new_category_data"],
        onChange: params["on_change"]);
  }
}
