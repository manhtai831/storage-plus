import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:hive_storage/hive_storage.dart';
import 'package:hive_storage/src/sqlite/interface/i_sqlite_curd.dart';
import 'package:sqflite/sqflite.dart';

class SqliteCurdImpl implements ISqliteIU, ISqliteRD, ISqliteRaw {
  final StringBuffer _rawQuery = StringBuffer();
  final StringBuffer _rawWhere = StringBuffer();
  final List<String> _keys = [];
  final List<dynamic> _values = [];
  Database? _database;
  String? _tableName;
  SqliteConverter? _converter;

  Database get _mDatabase => _database ?? DatabaseCreatorImpl().getDataBase();

  void _addData(String key, dynamic value) {
    _keys.add(key);
    _values.add(value);
  }

  @override
  Future<void> delete() async {
    _rawQuery.write('DELETE FROM $_tableName WHERE ${_rawWhere.toString()}');
    await _mDatabase.execute(_rawQuery.toString());
  }

  @override
  Future<T?> findAll<T>() async {
    _rawQuery.write(_rawWhere.toString());
    List<Map<String, dynamic>> response = await _mDatabase.rawQuery(_rawQuery.toString());

    return _converter?.call(response) ?? response;
  }

  @override
  Future<T?> findOne<T>() async {
    _rawQuery.write(_rawWhere.toString());
    List<Map<String, dynamic>> response = await _mDatabase.rawQuery(_rawQuery.toString());
    Map<String, dynamic>? object = response.firstOrNull;
    if (object == null) return null;
    return _converter?.call(object) ?? object;
  }

  @override
  Future<void> insert() async {
    _rawQuery.write('INSERT INTO $_tableName (${_keys.join(', ')}) VALUES (${_values.join(', ')})');
    _mDatabase.execute(_rawQuery.toString());
  }

  @override
  Future<void> update() async {
    List<String> dataSet = [];
    for (int i = 0; i < _keys.length; i++) {
      dataSet.add('${_keys[i]} = ${_values[i]}');
    }
    _rawQuery.write('UPDATE $_tableName SET ${dataSet.join(', ')} ${_rawWhere.toString()}');
    await _mDatabase.execute(_rawQuery.toString());
  }

  @override
  ISqliteIU setBlob(String key, Uint8List? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteIU setBool(String key, bool? value) {
    int boolean = value == true ? 1 : 0;
    _addData(key, boolean);
    return this;
  }

  @override
  ISqliteIU setInteger(String key, int? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteIU setNum(String key, num? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteIU setText(String key, String? value) {
    _addData(key, '\'value\'');
    return this;
  }

  @override
  SqliteCurdImpl raw(String raw) {
    _rawWhere.write(raw);
    return this;
  }

  @override
  ISqliteRD withConverter<T>(SqliteConverter<T> converter) {
    _converter = converter;
    return this;
  }

  @override
  SqliteCurdImpl withDatabase({String? databaseName}) {
    _database = DatabaseCreatorImpl().getDataBase(name: databaseName);
    return this;
  }

  @override
  ISqliteIU withTable(String tableName) {
    _tableName = tableName;
    return this;
  }

  @override
  Future<int> count() async {
    _rawQuery.write('SELECT COUNT(*) FROM $_tableName');
    List<Map<String, Object?>> response = await _mDatabase.rawQuery(_rawQuery.toString());
    return Sqflite.firstIntValue(response) ?? 0;
  }
}
