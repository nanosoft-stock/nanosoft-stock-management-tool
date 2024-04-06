import 'package:get_it/get_it.dart';
import 'package:stock_management_tool/features/add_new_product/data/repositories/product_repository_implementation.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/add_new_product_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_product_category_based_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_product_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/bloc/add_new_product_bloc.dart';
import 'package:stock_management_tool/features/add_new_stock/data/repositories/stock_repository_implementation.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/add_new_stock_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/autofill_fields_with_selected_sku_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/get_stock_category_based_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/usecases/get_stock_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/bloc/add_new_stock_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Add New Stock
  sl.registerLazySingleton<StockRepository>(() => StockRepositoryImplementation());
  sl.registerLazySingleton<GetStockInitialInputFieldsUseCase>(
      () => GetStockInitialInputFieldsUseCase(sl()));
  sl.registerLazySingleton<GetStockCategoryBasedInputFieldsUseCase>(
      () => GetStockCategoryBasedInputFieldsUseCase(sl()));
  sl.registerLazySingleton<AutofillFieldsWithSelectedSkuUseCase>(
      () => AutofillFieldsWithSelectedSkuUseCase(sl()));
  sl.registerLazySingleton<AddNewStockUseCase>(() => AddNewStockUseCase(sl()));
  sl.registerFactory<AddNewStockBloc>(() => AddNewStockBloc(sl(), sl(), sl(), sl()));

  // Add New Product
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImplementation());
  sl.registerLazySingleton<GetProductInitialInputFieldsUseCase>(
      () => GetProductInitialInputFieldsUseCase(sl()));
  sl.registerLazySingleton<GetProductCategoryBasedInputFieldsUseCase>(
      () => GetProductCategoryBasedInputFieldsUseCase(sl()));
  sl.registerLazySingleton<AddNewProductUseCase>(() => AddNewProductUseCase(sl()));
  sl.registerFactory<AddNewProductBloc>(() => AddNewProductBloc(sl(), sl(), sl()));
}
