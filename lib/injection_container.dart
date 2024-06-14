import 'package:get_it/get_it.dart';
import 'package:stock_management_tool/core/services/auth.dart';
import 'package:stock_management_tool/core/services/auth_default.dart';
import 'package:stock_management_tool/core/services/auth_rest_api.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/firestore_default.dart';
import 'package:stock_management_tool/core/services/firestore_rest_api.dart';
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
import 'package:stock_management_tool/features/locate_stock/data/repositories/locate_stock_repository_implementation.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/add_new_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/add_overlay_layer_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/cancel_pending_move_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/checkbox_toggled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/choose_ids_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/clear_field_filter_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/complete_pending_move_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/container_id_entered_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/expand_completed_moves_item_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/expand_pending_moves_item_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/field_filter_selected_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/filter_by_selected_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/filter_by_value_changed_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/filter_checkbox_toggled_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/filter_field_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/get_all_completed_state_items_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/get_all_pending_state_items_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/get_selected_items_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/hide_overlay_layer_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/id_entered_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/ids_chosen_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/initial_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/locate_stock_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/move_items_button_pressed_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/remove_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/reset_all_filters_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/search_by_field_filled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/search_value_changed_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/select_all_checkbox_toggled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/switch_stock_view_mode_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/switch_table_view_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/warehouse_location_id_entered_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/presentation/bloc/locate_stock_bloc.dart';
import 'package:stock_management_tool/features/print_id/data/repositories/print_id_repository_implementation.dart';
import 'package:stock_management_tool/features/print_id/domain/repositories/print_id_repository.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/initial_usecase.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/print_count_entered_usecase.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/print_id_selected_usecase.dart';
import 'package:stock_management_tool/features/print_id/domain/usecases/print_pressed_usecase.dart';
import 'package:stock_management_tool/features/print_id/presentation/bloc/print_id_bloc.dart';
import 'package:stock_management_tool/features/visualize_stock/data/repositories/visualize_stock_repository_implementation.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/add_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/change_column_visibility_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/checkbox_toggled_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/clear_column_filter_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/export_to_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_by_selected_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_column_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/filter_value_changed_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/hide_visualize_stock_layer_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/import_from_excel_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/initial_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/listen_to_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/rearrange_columns_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/reset_all_filters_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/search_value_changed_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/usecases/sort_column_visualize_stock_usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/presentation/bloc/visualize_stock_bloc.dart';
import 'package:stock_management_tool/objectbox.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ObjectBox
  sl.registerLazySingleton<ObjectBox>(() => ObjectBox());

  // Auth
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplementation());
  sl.registerLazySingleton<SignInUserUseCase>(() => SignInUserUseCase(sl()));
  sl.registerLazySingleton<SignUpUserUseCase>(() => SignUpUserUseCase(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl(), sl()));

  //Home
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImplementation());
  sl.registerLazySingleton<SignOutUserUseCase>(() => SignOutUserUseCase(sl()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl()));

  // Add New Stock
  sl.registerLazySingleton<StockRepository>(
      () => StockRepositoryImplementation());
  sl.registerLazySingleton<GetStockInitialInputFieldsUseCase>(
      () => GetStockInitialInputFieldsUseCase(sl()));
  sl.registerLazySingleton<GetStockCategoryBasedInputFieldsUseCase>(
      () => GetStockCategoryBasedInputFieldsUseCase(sl()));
  sl.registerLazySingleton<AutofillFieldsWithSelectedSkuUseCase>(
      () => AutofillFieldsWithSelectedSkuUseCase(sl()));
  sl.registerLazySingleton<AddNewStockUseCase>(() => AddNewStockUseCase(sl()));
  sl.registerFactory<AddNewStockBloc>(
      () => AddNewStockBloc(sl(), sl(), sl(), sl()));

  // Add New Product
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImplementation());
  sl.registerLazySingleton<GetProductInitialInputFieldsUseCase>(
      () => GetProductInitialInputFieldsUseCase(sl()));
  sl.registerLazySingleton<GetProductCategoryBasedInputFieldsUseCase>(
      () => GetProductCategoryBasedInputFieldsUseCase(sl()));
  sl.registerLazySingleton<AddNewProductUseCase>(
      () => AddNewProductUseCase(sl()));
  sl.registerFactory<AddNewProductBloc>(
      () => AddNewProductBloc(sl(), sl(), sl()));

  // Visualize Stock
  sl.registerLazySingleton<VisualizeStockRepository>(
      () => VisualizeStockRepositoryImplementation());
  sl.registerLazySingleton<ListenToCloudDataChangeVisualizeStockUseCase>(
      () => ListenToCloudDataChangeVisualizeStockUseCase(sl()));
  sl.registerLazySingleton<InitialVisualizeStockUseCase>(
      () => InitialVisualizeStockUseCase(sl()));
  sl.registerLazySingleton<SortColumnVisualizeStockUseCase>(
      () => SortColumnVisualizeStockUseCase(sl()));
  sl.registerLazySingleton<ImportFromExcelUseCase>(
      () => ImportFromExcelUseCase(sl()));
  sl.registerLazySingleton<ExportToExcelUseCase>(
      () => ExportToExcelUseCase(sl()));
  sl.registerLazySingleton<AddVisualizeStockLayerUseCase>(
      () => AddVisualizeStockLayerUseCase());
  sl.registerLazySingleton<HideVisualizeStockLayerUseCase>(
      () => HideVisualizeStockLayerUseCase());
  sl.registerLazySingleton<ResetAllFiltersVisualizeStockUseCase>(
      () => ResetAllFiltersVisualizeStockUseCase(sl()));
  sl.registerLazySingleton<RearrangeColumnsUseCase>(
      () => RearrangeColumnsUseCase());
  sl.registerLazySingleton<ChangeColumnVisibilityUseCase>(
      () => ChangeColumnVisibilityUseCase());
  sl.registerLazySingleton<FilterColumnVisualizeStockUseCase>(
      () => FilterColumnVisualizeStockUseCase(sl()));
  sl.registerLazySingleton<ClearColumnFilterVisualizeStockUseCase>(
      () => ClearColumnFilterVisualizeStockUseCase(sl()));
  sl.registerLazySingleton<FilterBySelectedVisualizeStockUseCase>(
      () => FilterBySelectedVisualizeStockUseCase());
  sl.registerLazySingleton<FilterValueChangedVisualizeStockUseCase>(
      () => FilterValueChangedVisualizeStockUseCase());
  sl.registerLazySingleton<SearchValueChangedVisualizeStockUseCase>(
      () => SearchValueChangedVisualizeStockUseCase(sl()));
  sl.registerLazySingleton<CheckboxToggledVisualizeStockUseCase>(
      () => CheckboxToggledVisualizeStockUseCase());
  sl.registerFactory<VisualizeStockBloc>(() => VisualizeStockBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));

  // Locate Stock
  sl.registerLazySingleton<LocateStockRepository>(
      () => LocateStockRepositoryImplementation());
  sl.registerLazySingleton<InitialLocateStockUseCase>(
      () => InitialLocateStockUseCase(sl()));
  sl.registerLazySingleton<LocateStockCloudDataChangeUseCase>(
      () => LocateStockCloudDataChangeUseCase(sl()));
  sl.registerLazySingleton<AddNewInputRowUseCase>(
      () => AddNewInputRowUseCase());
  sl.registerLazySingleton<RemoveInputRowUseCase>(
      () => RemoveInputRowUseCase());
  sl.registerLazySingleton<AddOverlayLayerUseCase>(
      () => AddOverlayLayerUseCase());
  sl.registerLazySingleton<HideOverlayLayerUseCase>(
      () => HideOverlayLayerUseCase());
  sl.registerLazySingleton<SearchByFieldFilledUseCase>(
      () => SearchByFieldFilledUseCase(sl()));
  sl.registerLazySingleton<ChooseIdsUseCase>(() => ChooseIdsUseCase());
  sl.registerLazySingleton<IdEnteredUseCase>(() => IdEnteredUseCase());
  sl.registerLazySingleton<IdsChosenUseCase>(() => IdsChosenUseCase(sl()));
  sl.registerLazySingleton<ResetAllFiltersLocateStockUseCase>(
      () => ResetAllFiltersLocateStockUseCase(sl()));
  sl.registerLazySingleton<FieldFilterSelectedUseCase>(
      () => FieldFilterSelectedUseCase());
  sl.registerLazySingleton<FilterFieldLocateStockUseCase>(
      () => FilterFieldLocateStockUseCase(sl()));
  sl.registerLazySingleton<ClearFieldFilterLocateStockUseCase>(
      () => ClearFieldFilterLocateStockUseCase(sl()));
  sl.registerLazySingleton<FilterBySelectedLocateStockUseCase>(
      () => FilterBySelectedLocateStockUseCase());
  sl.registerLazySingleton<FilterByValueChangedLocateStockUseCase>(
      () => FilterByValueChangedLocateStockUseCase());
  sl.registerLazySingleton<SearchValueChangedLocateStockUseCase>(
      () => SearchValueChangedLocateStockUseCase(sl()));
  sl.registerLazySingleton<FilterCheckboxToggledLocateStockUseCase>(
      () => FilterCheckboxToggledLocateStockUseCase());
  sl.registerLazySingleton<SwitchTableViewUseCase>(
      () => SwitchTableViewUseCase());
  sl.registerLazySingleton<SwitchStockViewModeUseCase>(
      () => SwitchStockViewModeUseCase());
  sl.registerLazySingleton<IdCheckBoxToggledUseCase>(
      () => IdCheckBoxToggledUseCase(sl()));
  sl.registerLazySingleton<SelectAllCheckBoxToggledUseCase>(
      () => SelectAllCheckBoxToggledUseCase(sl()));
  sl.registerLazySingleton<GetSelectedItemsUseCase>(
      () => GetSelectedItemsUseCase(sl()));
  sl.registerLazySingleton<ContainerIDEnteredUseCase>(
      () => ContainerIDEnteredUseCase(sl()));
  sl.registerLazySingleton<WarehouseLocationIDEnteredUseCase>(
      () => WarehouseLocationIDEnteredUseCase(sl()));
  sl.registerLazySingleton<MoveItemsButtonPressedUseCase>(
      () => MoveItemsButtonPressedUseCase(sl()));
  sl.registerLazySingleton<GetAllPendingStateItemsUseCase>(
      () => GetAllPendingStateItemsUseCase(sl()));
  sl.registerLazySingleton<ExpandPendingMovesItemUseCase>(
      () => ExpandPendingMovesItemUseCase());
  sl.registerLazySingleton<CompletePendingMoveUseCase>(
      () => CompletePendingMoveUseCase(sl()));
  sl.registerLazySingleton<CancelPendingMoveUseCase>(
      () => CancelPendingMoveUseCase(sl()));
  sl.registerLazySingleton<GetAllCompletedStateItemsUseCase>(
      () => GetAllCompletedStateItemsUseCase(sl()));
  sl.registerLazySingleton<ExpandCompletedMovesItemUseCase>(
      () => ExpandCompletedMovesItemUseCase());
  sl.registerFactory<LocateStockBloc>(() => LocateStockBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));

  // Print Id
  sl.registerLazySingleton<PrintIdRepository>(
      () => PrintIdRepositoryImplementation());
  sl.registerLazySingleton<InitialPrintIdUseCase>(
      () => InitialPrintIdUseCase());
  sl.registerLazySingleton<PrintIdSelectedUseCase>(
      () => PrintIdSelectedUseCase());
  sl.registerLazySingleton<PrintCountEnteredUseCase>(
      () => PrintCountEnteredUseCase());
  sl.registerLazySingleton<PrintPressedUseCase>(
      () => PrintPressedUseCase(sl()));
  sl.registerFactory<PrintIdBloc>(() => PrintIdBloc(sl(), sl(), sl(), sl()));

  // Services
  sl.registerLazySingleton<Auth>(() => Auth());
  sl.registerLazySingleton<AuthDefault>(() => AuthDefault());
  sl.registerLazySingleton<AuthRestApi>(() => AuthRestApi());
  sl.registerLazySingleton<Firestore>(() => Firestore());
  sl.registerLazySingleton<FirestoreDefault>(() => FirestoreDefault());
  sl.registerLazySingleton<FirestoreRestApi>(() => FirestoreRestApi());
}
