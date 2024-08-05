part of 'modify_category_bloc.dart';

abstract class ModifyCategoryEvent extends Equatable {
  const ModifyCategoryEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends ModifyCategoryEvent {
  const CloudDataChangeEvent({required this.onChange});

  final Function(Map)? onChange;
}

class LoadedEvent extends ModifyCategoryEvent {
  const LoadedEvent();
}

class CategorySelectedEvent extends ModifyCategoryEvent {
  const CategorySelectedEvent({
    required this.category,
  });

  final String? category;
}

class ViewFieldDetailsEvent extends ModifyCategoryEvent {
  const ViewFieldDetailsEvent({
    required this.field,
  });

  final String? field;
}

class AddNewFieldEvent extends ModifyCategoryEvent {
  const AddNewFieldEvent();
}

class RearrangeFieldsEvent extends ModifyCategoryEvent {
  const RearrangeFieldsEvent({
    required this.fields,
  });

  final List? fields;
}

class ModifyCategoryPressedEvent extends ModifyCategoryEvent {
  const ModifyCategoryPressedEvent();
}

class RemoveFieldEvent extends ModifyCategoryEvent {
  const RemoveFieldEvent();
}

class FieldNameTypedEvent extends ModifyCategoryEvent {
  const FieldNameTypedEvent({
    required this.title,
    required this.value,
  });

  final String? title;
  final String? value;
}

class DetailsTypedEvent extends ModifyCategoryEvent {
  const DetailsTypedEvent({
    required this.title,
    required this.value,
  });

  final String? title;
  final String? value;
}
