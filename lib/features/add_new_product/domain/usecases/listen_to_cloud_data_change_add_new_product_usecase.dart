import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';

class ListenToCloudDataChangeAddNewProductUseCase extends UseCase {
  ListenToCloudDataChangeAddNewProductUseCase(this._productRepository);

  final ProductRepository _productRepository;

  @override
  Future call({params}) async {
    return _productRepository.listenToCloudDataChange(
        fields: params["fields"], onChange: params["on_change"]);
  }
}
