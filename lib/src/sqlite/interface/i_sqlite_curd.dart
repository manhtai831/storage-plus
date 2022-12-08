import 'package:flutter/services.dart';

typedef SqliteConverter<T> = T Function(dynamic json);



abstract class ISqliteCURD {
  ISqliteCURD raw(String raw);

  ISqliteCURD withDatabase({String databaseName});

  ISqliteCURD withConverter<T>(SqliteConverter<T> converter);

  Future<int> count();

  Future<void> delete();

  Future<T?> findAll<T>();

  Future<T?> findOne<T>();

  ISqliteCURD withTable(String tableName);

  ISqliteCURD setBool(String key, bool? value);

  ISqliteCURD setText(String key, String? value);

  ISqliteCURD setInteger(String key, int? value);

  ISqliteCURD setBlob(String key, Uint8List? value);

  ISqliteCURD setNum(String key, num? value);

  Future<void> update();

  Future<void> insert();

  Future<bool> isExists();
}
