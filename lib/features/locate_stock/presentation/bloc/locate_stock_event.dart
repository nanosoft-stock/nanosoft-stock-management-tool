part of 'locate_stock_bloc.dart';

abstract class LocateStockEvent extends Equatable {
  const LocateStockEvent();

  @override
  List<Object> get props => [];
}

class LoadedEvent extends LocateStockEvent {}

class AddNewLocateStockInputRowEvent extends LocateStockEvent {
  const AddNewLocateStockInputRowEvent({required this.locatedItems});

  final List? locatedItems;
}

class RemoveLocateStockInputRowEvent extends LocateStockEvent {
  const RemoveLocateStockInputRowEvent({
    required this.index,
    required this.locatedItems,
  });

  final int? index;
  final List? locatedItems;
}

class SearchByFieldSelected extends LocateStockEvent {
  const SearchByFieldSelected(
      {required this.index, required this.searchBy, required this.locatedItems});

  final int? index;
  final String? searchBy;
  final List? locatedItems;
}

class IdSelected extends LocateStockEvent {
  const IdSelected({required this.index, required this.ids, required this.locatedItems});

  final int? index;
  final List? ids;
  final List? locatedItems;
}

class ShowTableToggled extends LocateStockEvent {
  const ShowTableToggled(
      {required this.index, required this.showTable, required this.locatedItems});

  final int? index;
  final bool? showTable;
  final List? locatedItems;
}

class ShowDetailsToggled extends LocateStockEvent {
  const ShowDetailsToggled(
      {required this.index, required this.showDetails, required this.locatedItems});

  final int? index;
  final bool? showDetails;
  final List? locatedItems;
}

class CheckBoxToggled extends LocateStockEvent {
  const CheckBoxToggled({
    required this.index,
    required this.id,
    required this.state,
    required this.locatedItems,
  });

  final int? index;
  final String? id;
  final CheckBoxState? state;
  final List? locatedItems;
}

class AllCheckBoxToggled extends LocateStockEvent {
  const AllCheckBoxToggled({
    required this.index,
    required this.state,
    required this.locatedItems,
  });

  final int? index;
  final CheckBoxState? state;
  final List? locatedItems;
}

class CustomSearchMenuSelected extends LocateStockEvent {}
