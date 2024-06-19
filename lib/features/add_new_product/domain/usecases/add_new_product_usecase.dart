import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';

class AddNewProductUseCase extends UseCase {
  AddNewProductUseCase(this._productRepository);

  final ProductRepository _productRepository;

  @override
  Future call({params}) async {
    List fields = params["fields"];

    await _productRepository.addNewProduct(fields: fields);
    fields = _productRepository.getInitialInputFields();

    return fields;
  }
}
