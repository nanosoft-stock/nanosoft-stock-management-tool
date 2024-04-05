import 'package:get_it/get_it.dart';
import 'package:stock_management_tool/features/add_new_product/data/repositories/product_repository_implementation.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/add_new_product_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_category_based_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/usecases/get_initial_input_fields_usecase.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/bloc/add_new_product_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImplementation());

  sl.registerLazySingleton<GetInitialInputFieldsUseCase>(() => GetInitialInputFieldsUseCase(sl()));

  sl.registerLazySingleton<GetCategoryBasedInputFieldsUseCase>(
      () => GetCategoryBasedInputFieldsUseCase(sl()));

  sl.registerLazySingleton<AddNewProductUseCase>(() => AddNewProductUseCase(sl()));

  sl.registerFactory<AddNewProductBloc>(() => AddNewProductBloc(sl()));
}
