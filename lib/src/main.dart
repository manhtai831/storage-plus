// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class UserModel {
  int? id;
  String? name;
  int? age;
  bool? isStudent;
  UserModel({
    this.id,
    this.name,
    this.age,
    this.isStudent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'isStudent': isStudent,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      age: map['age'] != null ? map['age'] as int : null,
      isStudent: map['isStudent'] != null ? map['isStudent'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, age: $age, isStudent: $isStudent)';
  }
}
