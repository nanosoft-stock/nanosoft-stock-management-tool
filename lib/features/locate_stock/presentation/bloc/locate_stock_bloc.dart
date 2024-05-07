import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/add_new_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/cancel_pending_move_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/checkbox_toggled_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/choose_ids_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/complete_pending_move_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/container_id_entered_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/get_all_completed_state_items_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/get_all_pending_state_items_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/get_selected_items_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/hide_overlay_layer_event.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/id_entered_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/ids_chosen_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/initial_locate_stock_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/locate_stock_cloud_data_change_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/move_items_button_pressed_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/remove_input_row_usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/usecases/search_by_field_filled_usecase.dart';
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
  final HideOverlayLayerUseCase? _hideOverlayLayerUseCase;
  final SearchByFieldFilledUseCase? _searchByFieldFilledUseCase;
  final ChooseIdsUseCase? _chooseIdsUseCase;
  final IdEnteredUseCase? _idEnteredUseCase;
  final IdsChosenUseCase? _idsChosenUseCase;
  final SwitchTableViewUseCase? _switchTableViewUseCase;
  final SwitchStockViewModeUseCase? _switchStockViewModeUseCase;
  final IdCheckBoxToggledUseCase? _idCheckBoxToggledUseCase;
  final SelectAllCheckBoxToggledUseCase? _selectAllCheckBoxToggledUseCase;
  final GetSelectedItemsUseCase? _getSelectedItemsUseCase;
  final ContainerIDEnteredUseCase? _containerIDEnteredUseCase;
  final WarehouseLocationIDEnteredUseCase? _warehouseLocationIDEnteredUseCase;
  final MoveItemsButtonPressedUseCase? _moveItemsButtonPressedUseCase;
  final GetAllPendingStateItemsUseCase? _getAllPendingStateItemsUseCase;
  final CompletePendingMoveUseCase? _completePendingMoveUseCase;
  final CancelPendingMoveUseCase? _cancelPendingMoveUseCase;
  final GetAllCompletedStateItemsUseCase? _getAllCompletedStateItemsUseCase;

  LocateStockBloc(
    this._initialLocateStockUseCase,
    this._locateStockCloudDataChangeUseCase,
    this._addNewInputRowUseCase,
    this._removeInputRowUseCase,
    this._hideOverlayLayerUseCase,
    this._searchByFieldFilledUseCase,
    this._chooseIdsUseCase,
    this._idEnteredUseCase,
    this._idsChosenUseCase,
    this._switchTableViewUseCase,
    this._switchStockViewModeUseCase,
    this._idCheckBoxToggledUseCase,
    this._selectAllCheckBoxToggledUseCase,
    this._getSelectedItemsUseCase,
    this._containerIDEnteredUseCase,
    this._warehouseLocationIDEnteredUseCase,
    this._moveItemsButtonPressedUseCase,
    this._getAllPendingStateItemsUseCase,
    this._completePendingMoveUseCase,
    this._cancelPendingMoveUseCase,
    this._getAllCompletedStateItemsUseCase,
  ) : super(LoadingState()) {
    on<LoadedEvent>(loadedEvent);
    on<CloudDataChangeEvent>(cloudDataChangeEvent);
    on<AddNewInputRowEvent>(addNewInputRowEvent);
    on<RemoveInputRowEvent>(removeInputRowEvent);
    on<HideOverlayLayerEvent>(hideOverlayLayerEvent);
    on<SearchByFieldFilled>(searchByFieldFilled);
    on<ChooseIdsButtonPressed>(chooseIdsButtonPressed);
    on<IdEntered>(idEntered);
    on<IdsChosen>(idsChosen);
    on<SwitchTableView>(switchTableView);
    on<SwitchStockViewMode>(switchStockViewMode);
    on<IdCheckBoxToggled>(idCheckBoxToggled);
    on<SelectAllCheckBoxToggled>(selectAllCheckBoxToggled);
    on<PreviewMoveButtonPressed>(previewMoveButtonPressed);
    on<ContainerIdEntered>(containerIdEntered);
    on<WarehouseLocationIdEntered>(warehouseLocationIdEntered);
    on<MoveItemsButtonPressed>(moveItemsButtonPressed);
    on<PendingMovesButtonPressed>(pendingMovesButtonPressed);
    on<CompleteMoveButtonPressed>(completeMoveButtonPressed);
    on<CancelMoveButtonPressed>(cancelMoveButtonPressed);
    on<CompletedMovesButtonPressed>(completedMovesButtonPressed);
  }

  FutureOr<void> loadedEvent(
      LoadedEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
      locatedStock: event.locatedStock!.cast<String, dynamic>(),
    ));
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
    emit(ReduceDuplicationActionState());
    emit(LoadedState(locatedStock: locatedStock));
  }

  FutureOr<void> addNewInputRowEvent(
      AddNewInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _addNewInputRowUseCase!(params: {
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> removeInputRowEvent(
      RemoveInputRowEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _removeInputRowUseCase!(params: {
      "index": event.index,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> hideOverlayLayerEvent(
      HideOverlayLayerEvent event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _hideOverlayLayerUseCase!(params: {
      "layer": event.layer,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> searchByFieldFilled(
      SearchByFieldFilled event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        index: event.index,
        locatedStock: await _searchByFieldFilledUseCase!(params: {
          "index": event.index,
          "search_by": event.searchBy,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> chooseIdsButtonPressed(
      ChooseIdsButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        index: event.index,
        locatedStock: await _chooseIdsUseCase!(params: {
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> idEntered(
      IdEntered event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        index: event.index,
        locatedStock: await _idEnteredUseCase!(params: {
          "index": event.index,
          "chosen_id": event.chosenId,
          "located_stock": event.locatedStock,
        })));
  }

  FutureOr<void> idsChosen(
      IdsChosen event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _idsChosenUseCase!(params: {
      "index": event.index,
      "chosen_ids": event.chosenIds,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> switchTableView(
      SwitchTableView event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _switchTableViewUseCase!(params: {
      "index": event.index,
      "show_table": event.showTable,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> switchStockViewMode(
      SwitchStockViewMode event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _switchStockViewModeUseCase!(params: {
      "index": event.index,
      "mode": event.mode,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> idCheckBoxToggled(
      IdCheckBoxToggled event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _idCheckBoxToggledUseCase!(params: {
      "index": event.index,
      "id": event.id,
      "state": event.state,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> selectAllCheckBoxToggled(
      SelectAllCheckBoxToggled event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _selectAllCheckBoxToggledUseCase!(params: {
      "index": event.index,
      "state": event.state,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> previewMoveButtonPressed(
      PreviewMoveButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _getSelectedItemsUseCase!(params: {
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> containerIdEntered(
      ContainerIdEntered event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _containerIDEnteredUseCase!(params: {
      "text": event.text,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> warehouseLocationIdEntered(
      WarehouseLocationIdEntered event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _warehouseLocationIDEnteredUseCase!(params: {
      "text": event.text,
      "located_stock": event.locatedStock,
    })));
  }

  FutureOr<void> moveItemsButtonPressed(
      MoveItemsButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
      locatedStock: await _moveItemsButtonPressedUseCase!(
          params: {"located_stock": event.locatedStock}),
    ));
  }

  FutureOr<void> pendingMovesButtonPressed(
      PendingMovesButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
      locatedStock: await _getAllPendingStateItemsUseCase!(
          params: {"located_stock": event.locatedStock}),
    ));
  }

  FutureOr<void> completeMoveButtonPressed(
      CompleteMoveButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
      locatedStock: await _completePendingMoveUseCase!(
          params: {"index": event.index, "located_stock": event.locatedStock}),
    ));
  }

  FutureOr<void> cancelMoveButtonPressed(
      CancelMoveButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _cancelPendingMoveUseCase!(params: {
      "index": event.index,
      "located_stock": event.locatedStock
    })));
  }

  FutureOr<void> completedMovesButtonPressed(
      CompletedMovesButtonPressed event, Emitter<LocateStockState> emit) async {
    emit(ReduceDuplicationActionState());
    emit(LoadedState(
        locatedStock: await _getAllCompletedStateItemsUseCase!(params: {
      "located_stock": event.locatedStock,
    })));
  }
}
