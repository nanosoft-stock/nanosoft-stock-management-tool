import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryObjectBoxModel {
  CategoryObjectBoxModel({
    this.id = 0,
    this.category,
  });

  @Id()
  int id;

  String? category;

  factory CategoryObjectBoxModel.fromJson(Map json) {
    return CategoryObjectBoxModel(
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,
    };
  }

  @override
  String toString() {
    return "CategoryModel(id: $id, category: $category)";
  }
}
