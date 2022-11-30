// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

import 'hive_curd_impl.dart';

void main(List<String> args) async {
  await HiveCurdImpl.connect();
  // var results = HiveCurdImpl().generateId();
//  var result2s =  await HiveCurdImpl().withConverter((json) => UserModel.fromMap(json)).insert(<String, dynamic>{'id': results, 'name': 'Tai DM', 'age': 18});
  var results = await HiveCurdImpl()
      .withConverter((json) => UserModel.fromMap(json))
      .update("5123123", <String, dynamic>{'id': 5, 'name': 'Tai DM 11111111', 'age': 18});
  // await HiveCurdImpl().insert({'id': 2, 'name': 'Tai DM 1', 'age': 18});
  // await HiveCurdImpl().insert({'id': 111, 'name': 'Tai DM 2', 'age': 18});
  // HiveCurdImpl().remove(1);
  // var result2s = HiveCurdImpl().withConverter((json) => UserModel.fromMap(json)).firstOrNull();
  //  await HiveCurdImpl().remove(5);
  var result2s = HiveCurdImpl().withConverter((json) => UserModel.fromMap(json)).findById("5123123");
  // var result2s = HiveCurdImpl()
  // .withConverter<List<UserModel>>((json) => json.map<UserModel>((e) => UserModel.fromMap(e)).toList())
  // .log()
  // .findAll();

  print(results);
  print(result2s);
}

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
