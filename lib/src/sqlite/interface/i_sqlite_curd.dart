import 'package:flutter/services.dart';

typedef SqliteConverter<T> = T Function(dynamic json);

abstract class ISqliteCurd {
  ISqliteCurd withConverter<T>(SqliteConverter<T> converter);

  ISqliteCurd withTable(String tableName);

  ISqliteCurd withDatabase({String databaseName});

  ISqliteCurd raw(String raw);

  ISqliteCurd setBool(String key, bool? value);

  ISqliteCurd setText(String key, String? value);

  ISqliteCurd setInteger(String key, int? value);

  ISqliteCurd setBlob(String key, Uint8List? value);

  ISqliteCurd setNum(String key, num? value);


  Future<int> count();

  ISqliteCurd page(int page);

  Future<T?> update<T>();

  Future<T?> insert<T>();

  Future<T?> delete<T>();


}
