import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: 1)
class CategoryHiveModel extends Equatable {
  const CategoryHiveModel({
    this.category,
  });

  @HiveField(0)
  final String? category;

  CategoryHiveModel copyWith({
    String? category,
  }) {
    return CategoryHiveModel(
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
    };
  }

  factory CategoryHiveModel.fromMap(Map<String, dynamic> map) {
    return CategoryHiveModel(
      category: (map['category'] as String?) ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryHiveModel.fromJson(String source) =>
      CategoryHiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => "CategoryHiveModel(category: $category)";

  @override
  List<Object> get props => [
        category!,
      ];
}
