import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';

class GetProductCategoryBasedInputFieldsUseCase extends UseCase {
  GetProductCategoryBasedInputFieldsUseCase(this._productRepository);
  final ProductRepository _productRepository;

  @override
  Future call({params}) async {
    return _productRepository.getCategoryBasedInputFields(category: params);
  }
}
