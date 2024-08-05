import 'dart:convert';
import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel {
  UserHiveModel({
    this.userUUID,
    this.email,
    this.username,
    this.vsColumnFields,
    this.vsVisibleFields,
  });

  @HiveField(0)
  String? userUUID;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? username;

  @HiveField(3)
  List<String>? vsColumnFields;

  @HiveField(4)
  List<String>? vsVisibleFields;

  UserHiveModel copyWith({
    String? userUUID,
    String? email,
    String? username,
    List<String>? vsColumnFields,
    List<String>? vsVisibleFields,
  }) {
    return UserHiveModel(
      userUUID: userUUID ?? this.userUUID,
      email: email ?? this.email,
      username: username ?? this.username,
      vsColumnFields: vsColumnFields ?? this.vsColumnFields,
      vsVisibleFields: vsVisibleFields ?? this.vsVisibleFields,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_uuid': userUUID,
      'email': email,
      'username': username,
      'vs_column_fields': vsColumnFields,
      'vs_visible_fields': vsVisibleFields,
    };
  }

  factory UserHiveModel.fromMap(Map<String, dynamic> map) {
    return UserHiveModel(
      userUUID: (map['user_uuid'] as String?) ?? "",
      email: (map['email'] as String?) ?? "",
      username: (map['username'] as String?) ?? "",
      vsColumnFields:
          List<String>.from((map['vs_column_fields'] as List<String>? ?? [])),
      vsVisibleFields:
          List<String>.from((map['vs_visible_fields'] as List<String>? ?? [])),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserHiveModel.fromJson(String source) =>
      UserHiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserHiveModel(userUUID: $userUUID, email: $email, username: $username, vsColumnFields: $vsColumnFields, vsVisibleFields: $vsVisibleFields)';
  }
}
