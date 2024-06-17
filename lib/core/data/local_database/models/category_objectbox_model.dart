import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryObjectBoxModel {
  CategoryObjectBoxModel({
    this.id = 0,
    this.category,
    this.skus,
  });

  @Id()
  int id;

  String? category;
  List<Map<String, dynamic>>? skus;

  factory CategoryObjectBoxModel.fromJson(Map json) {
    return CategoryObjectBoxModel(
      category: json["category"],
      skus: json["skus"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "skus": skus,
    };
  }

  @override
  String toString() {
    return "CategoryModel(id: $id, category: $category, skus: $skus)";
  }
}
