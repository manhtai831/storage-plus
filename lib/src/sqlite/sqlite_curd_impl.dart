import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:hive_storage/hive_storage.dart';
import 'package:hive_storage/src/sqlite/interface/i_sql_group.dart';
import 'package:hive_storage/src/sqlite/interface/i_sql_where.dart';
import 'package:hive_storage/src/sqlite/interface/i_sqlite_curd.dart';
import 'package:sqflite/sqflite.dart';

import 'interface/i_sql_join.dart';
import 'interface/i_sql_order.dart';
import 'interface/i_sql_select.dart';

enum OrderBy { asc, desc }

class SqliteCurdImpl implements ISqliteCurd, ISqlWhere, ISqlJoin, ISqlSelect, ISqlOrder, ISqlGroup {
  final StringBuffer _rawQuery = StringBuffer();
  final StringBuffer _rawWhere = StringBuffer();
  final StringBuffer _rawSelect = StringBuffer();
  final List<String> _keys = [];
  final List<dynamic> _values = [];
  Database? _database;
  String? _tableName;
  SqliteConverter? _converter;
  int? _limit;
  int? _offset;

  void _addData(String key, dynamic value) {
    _keys.add(key);
    _values.add(value);
  }

  @override
  Future<T?> delete<T>() async {
    _rawQuery.write(' DELETE FROM $_tableName WHERE ${_rawWhere.toString()}');
    await _database?.execute(_rawQuery.toString());
    return null;
  }

  @override
  Future<T?> findAll<T>() async {
    if (_limit != null && _offset != null) _rawQuery.write('LIMIT $_offset,$_limit');
    _rawQuery.write('SELECT $_rawSelect FROM $_tableName $_rawWhere');
    List<Map<String, dynamic>> response = await _database!.rawQuery(_rawQuery.toString());

    return _converter?.call(response) ?? response;
  }

  @override
  Future<T?> findOne<T>() async {
    _rawQuery.write('LIMIT 1');
    _rawQuery.write('SELECT $_rawSelect FROM $_tableName $_rawWhere');
    List<Map<String, dynamic>> response = await _database!.rawQuery(_rawQuery.toString());
    Map<String, dynamic> object = response.firstOrNull ?? {};
    return _converter?.call(object) ?? object;
  }

  @override
  Future<T?> insert<T>() async {
    _rawQuery.write('INSERT INTO $_tableName (${_keys.join(', ')}) VALUES (${_values.join(', ')})');
    _database?.execute(_rawQuery.toString());
    return null;
  }

  @override
  Future<T?> update<T>() async {
    List<String> dataSet = [];
    for (int i = 0; i < _keys.length; i++) {
      dataSet.add('${_keys[i]} = ${_values[i]}');
    }
    _rawQuery.write('UPDATE $_tableName SET ${dataSet.join(', ')} WHERE ${_rawWhere.toString()}');
    await _database?.execute(_rawQuery.toString());
    return null;
  }

  @override
  ISqliteCurd setBlob(String key, Uint8List? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteCurd setBool(String key, bool? value) {
    int boolean = value == true ? 1 : 0;
    _addData(key, boolean);
    return this;
  }

  @override
  ISqliteCurd setInteger(String key, int? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteCurd setNum(String key, num? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteCurd setText(String key, String? value) {
    _addData(key, '\'value\'');
    return this;
  }

  @override
  ISqliteCurd raw(String raw) {
    _rawWhere.write(raw);
    return this;
  }

  @override
  ISqliteCurd withConverter<T>(SqliteConverter<T> converter) {
    _converter = converter;
    return this;
  }

  @override
  ISqliteCurd withDatabase({String? databaseName}) {
    _database = DatabaseCreatorImpl().getDataBase(name: databaseName);
    return this;
  }

  @override
  ISqliteCurd withTable(String tableName) {
    _tableName = tableName;
    return this;
  }

  @override
  Future<int> count() async {
    _rawQuery.write('SELECT COUNT(*) FROM $_tableName');
    List<Map<String, Object?>> response = await _database!.rawQuery(_rawQuery.toString());
    return Sqflite.firstIntValue(response) ?? 0;
  }

  @override
  ISqlWhere limit(int limit) {
    _limit = limit;
    if (limit > 50 || limit < 0) limit = 50;
    return this;
  }

  @override
  ISqlWhere offset(int offset) {
    _offset = offset;
    if (offset < 0) _offset = 0;
    return this;
  }

  @override
  ISqliteCurd page(int page) {
    if (page < 0) _offset = 0;
    _offset = page * (_limit ?? 0);
    return this;
  }

  @override
  ISqliteCurd next() {
    return this;
  }

  @override
  ISqlWhere and() {
    _rawQuery.write(' END ');
    return this;
  }

  @override
  ISqlWhere or() {
    _rawQuery.write(' OR ');
    return this;
  }

  @override
  ISqlWhere where(String raw) {
    _rawQuery.write(raw);
    return this;
  }

  @override
  ISqlJoin innerJoin(String tableName) {
    _rawQuery.write(' INNER JOIN $tableName');
    return this;
  }

  @override
  ISqlJoin join(String tableName) {
    _rawQuery.write(' JOIN $tableName');
    return this;
  }

  @override
  ISqlJoin on(String raw) {
    _rawQuery.write(' $raw');
    return this;
  }

  @override
  ISqlSelect select(List<String> properties) {
    _rawSelect.write(properties.join(', '));
    return this;
  }

  @override
  ISqlOrder orderBy(OrderBy orderBy) {
    String order = 'ASC';
    if (orderBy == OrderBy.desc) order = 'DESC';
    _rawSelect.write(' ORDER BY $order');
    return this;
  }

  @override
  ISqlGroup groupBy(String columnName) {
    _rawSelect.write(' GRPUP BY $columnName HAVING ');
    return this;
  }

  @override
  ISqlGroup having(String condition) {
    _rawSelect.write(' $condition');
    return this;
  }
}
