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
  const LoadedEvent({
    required this.modifyCategoryData,
  });

  final Map<String, dynamic>? modifyCategoryData;
}

class CategorySelectedEvent extends ModifyCategoryEvent {
  const CategorySelectedEvent({
    required this.category,
    required this.modifyCategoryData,
  });

  final String? category;
  final Map<String, dynamic>? modifyCategoryData;
}

class ViewFieldDetailsEvent extends ModifyCategoryEvent {
  const ViewFieldDetailsEvent({
    required this.field,
    required this.modifyCategoryData,
  });

  final String? field;
  final Map<String, dynamic>? modifyCategoryData;
}

class AddNewFieldEvent extends ModifyCategoryEvent {
  const AddNewFieldEvent({
    required this.modifyCategoryData,
  });

  final Map<String, dynamic>? modifyCategoryData;
}

class RearrangeFieldsEvent extends ModifyCategoryEvent {
  const RearrangeFieldsEvent({
    required this.fields,
    required this.modifyCategoryData,
  });

  final List? fields;
  final Map<String, dynamic>? modifyCategoryData;
}

class ModifyCategoryPressedEvent extends ModifyCategoryEvent {
  const ModifyCategoryPressedEvent({
    required this.modifyCategoryData,
  });

  final Map<String, dynamic>? modifyCategoryData;
}

class RemoveFieldEvent extends ModifyCategoryEvent {
  const RemoveFieldEvent({
    required this.modifyCategoryData,
  });

  final Map<String, dynamic>? modifyCategoryData;
}

class FieldNameTypedEvent extends ModifyCategoryEvent {
  const FieldNameTypedEvent({
    required this.title,
    required this.value,
    required this.modifyCategoryData,
  });

  final String? title;
  final String? value;
  final Map<String, dynamic>? modifyCategoryData;
}

class DetailsTypedEvent extends ModifyCategoryEvent {
  const DetailsTypedEvent({
    required this.title,
    required this.value,
    required this.modifyCategoryData,
  });

  final String? title;
  final String? value;
  final Map<String, dynamic>? modifyCategoryData;
}
