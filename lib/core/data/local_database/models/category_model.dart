import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryModel {
  CategoryModel({
    this.id = 0,
    this.category,
    this.ref,
    this.updateTime,
  });

  @Id()
  int id;

  String? category;
  String? ref;

  @Property(type: PropertyType.date)
  DateTime? updateTime;

  @override
  String toString() {
    return "CategoryModel(id: $id, category: $category, ref: $ref, updateTime, $updateTime)";
  }
}
