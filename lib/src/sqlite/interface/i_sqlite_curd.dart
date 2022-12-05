import 'package:flutter/services.dart';

typedef SqliteConverter<T> = T Function(dynamic json);

abstract class ISqliteRD {
  ISqliteRD withConverter<T>(SqliteConverter<T> converter);

  Future<int> count();

  Future<void> delete();

  Future<T?> findAll<T>();

  Future<T?> findOne<T>();
}

abstract class ISqliteRaw {
  ISqliteRaw raw(String raw);

  ISqliteRaw withDatabase({String databaseName});
}

abstract class ISqliteIU {
  ISqliteIU withTable(String tableName);

  ISqliteIU setBool(String key, bool? value);

  ISqliteIU setText(String key, String? value);

  ISqliteIU setInteger(String key, int? value);

  ISqliteIU setBlob(String key, Uint8List? value);

  ISqliteIU setNum(String key, num? value);

  Future<void> update();

  Future<void> insert();
}
