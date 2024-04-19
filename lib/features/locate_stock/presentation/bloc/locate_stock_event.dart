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
  const IdSelected({required this.index, required this.id, required this.locatedItems});

  final int? index;
  final String? id;
  final List? locatedItems;
}

class CustomSearchMenuSelected extends LocateStockEvent {}
