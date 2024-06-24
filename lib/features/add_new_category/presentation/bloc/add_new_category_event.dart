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
  const LoadedEvent({
    required this.addNewCategoryData,
  });

  final Map<String, dynamic>? addNewCategoryData;
}

class CategoryTypedEvent extends AddNewCategoryEvent {
  const CategoryTypedEvent({
    required this.category,
    required this.addNewCategoryData,
  });

  final String? category;
  final Map<String, dynamic>? addNewCategoryData;
}

class ViewFieldDetailsEvent extends AddNewCategoryEvent {
  const ViewFieldDetailsEvent({
    required this.field,
    required this.addNewCategoryData,
  });

  final String? field;
  final Map<String, dynamic>? addNewCategoryData;
}

class AddNewFieldEvent extends AddNewCategoryEvent {
  const AddNewFieldEvent({
    required this.addNewCategoryData,
  });

  final Map<String, dynamic>? addNewCategoryData;
}

class RearrangeFieldsEvent extends AddNewCategoryEvent {
  const RearrangeFieldsEvent({
    required this.fields,
    required this.addNewCategoryData,
  });

  final List? fields;
  final Map<String, dynamic>? addNewCategoryData;
}

class AddNewCategoryPressedEvent extends AddNewCategoryEvent {
  const AddNewCategoryPressedEvent({
    required this.addNewCategoryData,
  });

  final Map<String, dynamic>? addNewCategoryData;
}

class RemoveFieldEvent extends AddNewCategoryEvent {
  const RemoveFieldEvent({
    required this.addNewCategoryData,
  });

  final Map<String, dynamic>? addNewCategoryData;
}

class FieldNameTypedEvent extends AddNewCategoryEvent {
  const FieldNameTypedEvent({
    required this.title,
    required this.value,
    required this.addNewCategoryData,
  });

  final String? title;
  final String? value;
  final Map<String, dynamic>? addNewCategoryData;
}

class DetailsTypedEvent extends AddNewCategoryEvent {
  const DetailsTypedEvent({
    required this.title,
    required this.value,
    required this.addNewCategoryData,
  });

  final String? title;
  final String? value;
  final Map<String, dynamic>? addNewCategoryData;
}
