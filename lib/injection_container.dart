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
import 'package:stock_management_tool/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:stock_management_tool/features/auth/domain/repositories/auth_repository.dart';
import 'package:stock_management_tool/features/auth/domain/usecases/sign_in_user_usecase.dart';
import 'package:stock_management_tool/features/auth/domain/usecases/sign_up_user_usecase.dart';
import 'package:stock_management_tool/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stock_management_tool/features/home/data/repositories/home_repository_implementation.dart';
import 'package:stock_management_tool/features/home/domain/repositories/home_repository.dart';
import 'package:stock_management_tool/features/home/domain/usecases/sign_out_user_usecase.dart';
import 'package:stock_management_tool/features/home/presentation/bloc/home_bloc.dart';
import 'package:stock_management_tool/features/visualize_stock/data/repositories/visualize_stock_repository_implementation.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/export_to_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_fields_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/get_all_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_field_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/bloc/visualize_stock_bloc.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/services/auth.dart';
import 'package:stock_management_tool/services/auth_default.dart';
import 'package:stock_management_tool/services/auth_rest_api.dart';
import 'package:stock_management_tool/services/firestore.dart';
import 'package:stock_management_tool/services/firestore_default.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ObjectBox
  sl.registerLazySingleton<ObjectBox>(() => ObjectBox());

  // Auth
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImplementation());
  sl.registerLazySingleton<SignInUserUseCase>(() => SignInUserUseCase(sl()));
  sl.registerLazySingleton<SignUpUserUseCase>(() => SignUpUserUseCase(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl(), sl()));

  //Home
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImplementation());
  sl.registerLazySingleton<SignOutUserUseCase>(() => SignOutUserUseCase(sl()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl()));

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

  // Visualize Stock
  sl.registerLazySingleton<VisualizeStockRepository>(
      () => VisualizeStockRepositoryImplementation());
  sl.registerLazySingleton<GetAllStockUseCase>(() => GetAllStockUseCase(sl()));
  sl.registerLazySingleton<GetAllFieldsUseCase>(() => GetAllFieldsUseCase(sl()));
  sl.registerLazySingleton<SortFieldUseCase>(() => SortFieldUseCase(sl()));
  sl.registerLazySingleton<SortStockUseCase>(() => SortStockUseCase(sl()));
  sl.registerLazySingleton<ExportToExcelUsecase>(() => ExportToExcelUsecase(sl()));
  sl.registerFactory<VisualizeStockBloc>(() => VisualizeStockBloc(sl(), sl(), sl(), sl(), sl()));

  // Services
  sl.registerLazySingleton<Auth>(() => Auth());
  sl.registerLazySingleton<AuthDefault>(() => AuthDefault());
  sl.registerLazySingleton<AuthRestApi>(() => AuthRestApi());
  sl.registerLazySingleton<Firestore>(() => Firestore());
  sl.registerLazySingleton<FirestoreDefault>(() => FirestoreDefault());
  sl.registerLazySingleton<FirestoreRestApi>(() => FirestoreRestApi());
}
