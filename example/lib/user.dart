// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_storage/hive_storage.dart';

class User {
  int? id;
  String? name;
  bool? isStudent;
  int? age;
  User({
    this.id,
    this.name,
    this.isStudent,
    this.age,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isStudent': isStudent,
      'age': age,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
  
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      isStudent: map['is_student'] != null ? (map['is_student'] as int?).toBool : null,
      age: map['age'] != null ? map['age'] as int : null,
    );
  }



  @override
  String toString() {
    return 'User(id: $id, name: $name, isStudent: $isStudent, age: $age)';
  }
}
