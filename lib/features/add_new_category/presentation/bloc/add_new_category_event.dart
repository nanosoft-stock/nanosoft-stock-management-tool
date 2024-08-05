part of 'add_new_category_bloc.dart';

abstract class AddNewCategoryEvent extends Equatable {
  const AddNewCategoryEvent();

  @override
  List<Object> get props => [];
}

class CloudDataChangeEvent extends AddNewCategoryEvent {
  const CloudDataChangeEvent({required this.onChange});

  final Function(Map)? onChange;
}

class LoadedEvent extends AddNewCategoryEvent {
  const LoadedEvent();
}

class CategoryTypedEvent extends AddNewCategoryEvent {
  const CategoryTypedEvent({
    required this.category,
  });

  final String? category;
}

class ViewFieldDetailsEvent extends AddNewCategoryEvent {
  const ViewFieldDetailsEvent({
    required this.field,
  });

  final String? field;
}

class AddNewFieldEvent extends AddNewCategoryEvent {
  const AddNewFieldEvent();
}

class RearrangeFieldsEvent extends AddNewCategoryEvent {
  const RearrangeFieldsEvent({
    required this.fields,
  });

  final List? fields;
}

class AddNewCategoryPressedEvent extends AddNewCategoryEvent {
  const AddNewCategoryPressedEvent();
}

class RemoveFieldEvent extends AddNewCategoryEvent {
  const RemoveFieldEvent();
}

class FieldNameTypedEvent extends AddNewCategoryEvent {
  const FieldNameTypedEvent({
    required this.title,
    required this.value,
  });

  final String? title;
  final String? value;
}

class DetailsTypedEvent extends AddNewCategoryEvent {
  const DetailsTypedEvent({
    required this.title,
    required this.value,
  });

  final String? title;
  final String? value;
}
