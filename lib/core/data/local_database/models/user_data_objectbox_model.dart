import 'package:objectbox/objectbox.dart';

@Entity()
class UserDataObjectboxModel {
  UserDataObjectboxModel({
    this.id = 0,
    required this.uid,
    required this.email,
    required this.username,
    required this.visualizeStockTableColumns,
  });

  @Id()
  int id;

  String? uid;
  String? email;
  String? username;
  List<String>? visualizeStockTableColumns;

  factory UserDataObjectboxModel.fromJson(Map json) {
    return UserDataObjectboxModel(
      uid: json["uid"],
      email: json["email"],
      username: json["username"],
      visualizeStockTableColumns:
          json["visualize_stock_table_columns"]?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "username": username,
      "visualize_stock_table_columns": visualizeStockTableColumns,
    };
  }

  @override
  String toString() {
    return "UserDataObjectboxModel(id:$id, uid: $uid, email: $email, username: $username, visualizeStockTableColumns: $visualizeStockTableColumns)";
  }
}
