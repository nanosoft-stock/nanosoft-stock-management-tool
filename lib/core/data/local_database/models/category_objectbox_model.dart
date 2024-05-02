import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryObjectBoxModel {
  CategoryObjectBoxModel({
    this.id = 0,
    this.uid,
    this.category,
    this.updateTime,
  });

  @Id()
  int id;

  String? uid;
  String? category;

  @Property(type: PropertyType.date)
  DateTime? updateTime;

  @override
  String toString() {
    return "CategoryModel(id: $id, uid: $uid, category: $category, updateTime, $updateTime)";
  }
}
