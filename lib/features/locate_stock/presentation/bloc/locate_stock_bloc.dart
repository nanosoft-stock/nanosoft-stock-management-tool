import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/constants/enums.dart';
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
import 'package:stock_management_tool/features/locate_stock/domain/usecases/search_by_field_filled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/search_value_changed_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/select_all_checkbox_toggled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/switch_stock_view_mode_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/switch_table_view_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/warehouse_location_id_entered_usecase.dart';

part 'locate_stock_event.dart';
part 'locate_stock_state.dart';

class LocateStockBloc extends Bloc<LocateStockEvent, LocateStockState> {
  final InitialLocateStockUseCase? _initialLocateStockUseCase;
  final LocateStockCloudDataChangeUseCase? _locateStockCloudDataChangeUseCase;
  final AddNewInputRowUseCase? _addNewInputRowUseCase;
  final RemoveInputRowUseCase? _removeInputRowUseCase;
  final AddOverlayLayerUseCase? _addOverlayLayerUseCase;
  final HideOverlayLayerUseCase? _hideOverlayLayerUseCase;
  final SearchByFieldFilledUseCase? _searchByFieldFilledUseCase;
  final ChooseIdsUseCase? _chooseIdsUseCase;
  final IdEnteredUseCase? _idEnteredUseCase;
  final IdsChosenUseCase? _idsChosenUseCase;
  final FieldFilterSelectedUseCase? _fieldFilterSelectedUseCase;
  final FilterFieldLocateStockUseCase? _filterFieldLocateStockUseCase;
  final ClearFieldFilterLocateStockUseCase? _clearFieldFilterLocateStockUseCase;
  final FilterBySelectedLocateStockUseCase? _filterBySelectedLocateStockUseCase;
  final FilterByValueChangedLocateStockUseCase?
      _filterByValueChangedLocateStockUseCase;
  final SearchValueChangedLocateStockUseCase?
      _searchValueChangedLocateStockUseCase;
  final FilterCheckboxToggledLocateStockUseCase?
      _filterCheckboxToggledLocateStockUseCase;
  final SwitchTableViewUseCase? _switchTableViewUseCase;
  final SwitchStockViewModeUseCase? _switchStockViewModeUseCase;
  final IdCheckBoxToggledUseCase? _idCheckBoxToggledUseCase;
  final SelectAllCheckBoxToggledUseCase? _selectAllCheckBoxToggledUseCase;
  final GetSelectedItemsUseCase? _getSelectedItemsUseCase;
  final ContainerIDEnteredUseCase? _containerIDEnteredUseCase;
  final WarehouseLocationIDEnteredUseCase? _warehouseLocationIDEnteredUseCase;
  final MoveItemsButtonPressedUseCase? _moveItemsButtonPressedUseCase;
  final GetAllPendingStateItemsUseCase? _getAllPendingStateItemsUseCase;
  final ExpandPendingMovesItemUseCase? _expandPendingMovesItemUseCase;
  final CompletePendingMoveUseCase? _completePendingMoveUseCase;
  final CancelPendingMoveUseCase? _cancelPendingMoveUseCase;
  final GetAllCompletedStateItemsUseCase? _getAllCompletedStateItemsUseCase;
  final ExpandCompletedMovesItemUseCase? _expandCompletedMovesItemUseCase;

  LocateStockBloc(
    this._initialLocateStockUseCase,
    this._locateStockCloudDataChangeUseCase,
    this._addNewInputRowUseCase,
    this._removeInputRowUseCase,
    this._addOverlayLayerUseCase,
    this._hideOverlayLayerUseCase,
    this._searchByFieldFilledUseCase,
    this._chooseIdsUseCase,
    this._idEnteredUseCase,
    this._idsChosenUseCase,
    this._fieldFilterSelectedUseCase,
    this._filterFieldLocateStockUseCase,
    this._clearFieldFilterLocateStockUseCase,
    this._filterBySelectedLocateStockUseCase,
    this._filterByValueChangedLocateStockUseCase,
    this._searchValueChangedLocateStockUseCase,
    this._filterCheckboxToggledLocateStockUseCase,
    this._switchTableViewUseCase,
    this._switchStockViewModeUseCase,
    this._idCheckBoxToggledUseCase,
    this._selectAllCheckBoxToggledUseCase,
    this._getSelectedItemsUseCase,
    this._containerIDEnteredUseCase,
    this._warehouseLocationIDEnteredUseCase,
    this._moveItemsButtonPressedUseCase,
    this._getAllPendingStateItemsUseCase,
    this._expandPendingMovesItemUseCase,
    this._completePendingMoveUseCase,
    this._cancelPendingMoveUseCase,
    this._getAllCompletedStateItemsUseCase,
    this._expandCompletedMovesItemUseCase,
  ) : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<AddNewInputRowEvent>(addNewInputRowEvent);
    on<RemoveInputRowEvent>(removeInputRowEvent);
    on<AddOverlayLayerEvent>(addOverlayLayerEvent);
    on<HideOverlayLayerEvent>(hideOverlayLayerEvent);
    on<SearchByFieldFilledEvent>(searchByFieldFilled);
    on<ChooseIdsButtonPressedEvent>(chooseIdsButtonPressed);
    on<IdEnteredEvent>(idEntered);
    on<IdsChosenEvent>(idsChosen);
    on<FieldFilterSelectedEvent>(fieldFilterSelectedEvent);
    on<FilterFieldEvent>(filterFieldEvent);
    on<ClearFieldFilterEvent>(clearFieldFilterEvent);
    on<FilterBySelectedEvent>(filterBySelectedEvent);
    on<FilterByValueChangedEvent>(filterByValueChangedEvent);
    on<SearchValueChangedEvent>(searchValueChangedEvent);
    on<FilterCheckBoxToggledEvent>(filterCheckBoxToggledEvent);
    on<SwitchTableViewEvent>(switchTableView);
    on<SwitchStockViewModeEvent>(switchStockViewMode);
    on<IdCheckBoxToggledEvent>(idCheckBoxToggled);
    on<SelectAllCheckBoxToggledEvent>(selectAllCheckBoxToggled);
    on<PreviewMoveButtonPressedEvent>(previewMoveButtonPressed);
    on<ContainerIdEnteredEvent>(containerIdEntered);
    on<WarehouseLocationIdEnteredEvent>(warehouseLocationIdEntered);
    on<MoveItemsButtonPressedEvent>(moveItemsButtonPressed);
    on<PendingMovesButtonPressedEvent>(pendingMovesButtonPressed);
    on<ExpandPendingMovesItemEvent>(expandPendingMovesItem);
    on<CompleteMoveButtonPressedEvent>(completeMoveButtonPressed);
    on<CancelMoveButtonPressedEvent>(cancelMoveButtonPressed);
    on<CompletedMovesButtonPressedEvent>(completedMovesButtonPressed);
    on<ExpandCompletedMovesItemEvent>(expandCompletedMovesItem);
  }

  FutureOr<void> cloudDataChangeEvent(
      CloudDataChangeEvent event, Emitter<LocateStockState> emit) async {
    Map<String, dynamic> locatedStock =
        event.locatedStock ?? await _initialLocateStockUseCase!();

    await _locateStockCloudDataChangeUseCase!(params: {
      "located_stock": locatedStock,
      "on_change": (Map locatedStock) {
        add(LoadedEvent(locatedStock: locatedStock.cast<String, dynamic>()));
      },
    });
    emit(LoadedState(locatedStock: locatedStock));
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
      locatedStock: event.locatedStock!.cast<String, dynamic>(),
    ));
  }

  FutureOr<void> addNewInputRowEvent(
      AddNewInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _addNewInputRowUseCase!(params: {
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> removeInputRowEvent(
      RemoveInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _removeInputRowUseCase!(params: {
      "index": event.index,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> addOverlayLayerEvent(
      AddOverlayLayerEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _addOverlayLayerUseCase!(params: {
          "layer": event.layer,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> hideOverlayLayerEvent(
      HideOverlayLayerEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _hideOverlayLayerUseCase!(params: {
      "layer": event.layer,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> searchByFieldFilled(
      SearchByFieldFilledEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _searchByFieldFilledUseCase!(params: {
          "index": event.index,
          "search_by": event.searchBy,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> chooseIdsButtonPressed(
      ChooseIdsButtonPressedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _chooseIdsUseCase!(params: {
          "index": event.index,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> idEntered(
      IdEnteredEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _idEnteredUseCase!(params: {
          "index": event.index,
          "chosen_id": event.chosenId,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> idsChosen(
      IdsChosenEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _idsChosenUseCase!(params: {
      "index": event.index,
      "chosen_ids": event.chosenIds,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> fieldFilterSelectedEvent(
      FieldFilterSelectedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _fieldFilterSelectedUseCase!(params: {
          "index": event.index,
          "field": event.field,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> filterFieldEvent(
      FilterFieldEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _filterFieldLocateStockUseCase!(params: {
          "index": event.index,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> clearFieldFilterEvent(
      ClearFieldFilterEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _clearFieldFilterLocateStockUseCase!(params: {
          "index": event.index,
          "field": event.field,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> filterBySelectedEvent(
      FilterBySelectedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _filterBySelectedLocateStockUseCase!(params: {
          "index": event.index,
          "field": event.field,
          "filter_by": event.filterBy,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> filterByValueChangedEvent(
      FilterByValueChangedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _filterByValueChangedLocateStockUseCase!(params: {
          "index": event.index,
          "field": event.field,
          "value": event.value,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> searchValueChangedEvent(
      SearchValueChangedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _searchValueChangedLocateStockUseCase!(params: {
          "index": event.index,
          "field": event.field,
          "value": event.value,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> filterCheckBoxToggledEvent(
      FilterCheckBoxToggledEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        index: event.index,
        locatedStock: await _filterCheckboxToggledLocateStockUseCase!(params: {
          "index": event.index,
          "field": event.field,
          "title": event.title,
          "value": event.value,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> switchTableView(
      SwitchTableViewEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _switchTableViewUseCase!(params: {
      "index": event.index,
      "show_table": event.showTable,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> switchStockViewMode(
      SwitchStockViewModeEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _switchStockViewModeUseCase!(params: {
      "index": event.index,
      "mode": event.mode,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> idCheckBoxToggled(
      IdCheckBoxToggledEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _idCheckBoxToggledUseCase!(params: {
      "index": event.index,
      "id": event.id,
      "state": event.state,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> selectAllCheckBoxToggled(SelectAllCheckBoxToggledEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _selectAllCheckBoxToggledUseCase!(params: {
      "index": event.index,
      "state": event.state,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> previewMoveButtonPressed(PreviewMoveButtonPressedEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _getSelectedItemsUseCase!(params: {
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> containerIdEntered(
      ContainerIdEnteredEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _containerIDEnteredUseCase!(params: {
      "text": event.text,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> warehouseLocationIdEntered(
      WarehouseLocationIdEnteredEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _warehouseLocationIDEnteredUseCase!(params: {
      "text": event.text,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> moveItemsButtonPressed(
      MoveItemsButtonPressedEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
      locatedStock: await _moveItemsButtonPressedUseCase!(
          params: {"located_stock": event.locatedStock}),
    ));
  }

  FutureOr<void> pendingMovesButtonPressed(PendingMovesButtonPressedEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
      locatedStock: await _getAllPendingStateItemsUseCase!(
          params: {"located_stock": event.locatedStock}),
    ));
  }

  FutureOr<void> expandPendingMovesItem(
      ExpandPendingMovesItemEvent event, Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _expandPendingMovesItemUseCase!(params: {
      "index": event.index,
      "is_expanded": event.isExpanded,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> completeMoveButtonPressed(CompleteMoveButtonPressedEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _completePendingMoveUseCase!(params: {
      "index": event.index,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> cancelMoveButtonPressed(CancelMoveButtonPressedEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _cancelPendingMoveUseCase!(params: {
      "index": event.index,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> completedMovesButtonPressed(
      CompletedMovesButtonPressedEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _getAllCompletedStateItemsUseCase!(params: {
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> expandCompletedMovesItem(ExpandCompletedMovesItemEvent event,
      Emitter<LocateStockState> emit) async {
    emit(LoadedState(
        locatedStock: await _expandCompletedMovesItemUseCase!(params: {
      "index": event.index,
      "is_expanded": event.isExpanded,
      "located_stock": event.locatedStock
    })));
  }
}
