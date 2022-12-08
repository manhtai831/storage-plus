import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:hive_storage/hive_storage.dart';
import 'package:hive_storage/src/sqlite/interface/i_sqlite_curd.dart';
import 'package:sqflite/sqflite.dart';

class SqliteCurdImpl implements ISqliteCURD {
  final StringBuffer _rawQuery = StringBuffer();
  final StringBuffer _rawWhere = StringBuffer();
  final List<String> _keys = [];
  final List<dynamic> _values = [];
  Database? _database;
  String? _tableName;
  SqliteConverter? _converter;

  Database get _mDatabase => _database ?? DatabaseCreatorImpl().getDataBase();
  Database get mDatabase => _database ?? DatabaseCreatorImpl().getDataBase();

  void _addData(String key, dynamic value) {
    _keys.add(key);
    _values.add(value);
  }

  @override
  Future<void> delete() async {
    _rawQuery.write('DELETE FROM $_tableName ${_rawWhere.toString()}');
    await _mDatabase.rawDelete(_rawQuery.toString(),_values);
  }

  @override
  Future<T?> findAll<T>() async {
    _rawQuery.write(_rawWhere.toString());
    List<Map<String, dynamic>> response = await _mDatabase.rawQuery(_rawQuery.toString(),_values);

    return _converter?.call(response) ?? response;
  }

  @override
  Future<T?> findOne<T>() async {
    _rawQuery.write(_rawWhere.toString());
    List<Map<String, dynamic>> response = await _mDatabase.rawQuery(_rawQuery.toString(),_values);
    Map<String, dynamic>? object = response.firstOrNull;
    if (object == null) return null;
    return _converter?.call(object) ?? object;
  }

  @override
  Future<void> insert() async {
    String finalRaw = 'INSERT INTO $_tableName (${_keys.join(', ')}) VALUES (${_keys.map((e) => '?').join(', ')})';
    _rawQuery.write(finalRaw);
    _mDatabase.rawInsert(_rawQuery.toString(),_values);
  }

  @override
  Future<void> update() async {
    List<String> dataSet = [];
    for (int i = 0; i < _keys.length; i++) {
      dataSet.add('${_keys[i]} = ?');
    }
    _rawQuery.write('UPDATE $_tableName SET ${dataSet.join(', ')} ${_rawWhere.toString()}');
    await _mDatabase.rawUpdate(_rawQuery.toString(),_values);
  }

  @override
  ISqliteCURD setBlob(String key, Uint8List? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteCURD setBool(String key, bool? value) {
    int boolean = value == true ? 1 : 0;
    _addData(key, boolean);
    return this;
  }

  @override
  ISqliteCURD setInteger(String key, int? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteCURD setNum(String key, num? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteCURD setText(String key, String? value) {
    _addData(key, value);
    return this;
  }

  @override
  ISqliteCURD raw(String raw) {
    _rawWhere.write(raw);
    return this;
  }

  @override
  ISqliteCURD withConverter<T>(SqliteConverter<T> converter) {
    _converter = converter;
    return this;
  }

  @override
  ISqliteCURD withDatabase({String? databaseName}) {
    _database = DatabaseCreatorImpl().getDataBase(name: databaseName);
    return this;
  }

  @override
  ISqliteCURD withTable(String tableName) {
    _tableName = tableName;
    return this;
  }

  @override
  Future<int> count() async {
    _rawQuery.write('SELECT COUNT(*) FROM $_tableName');
    List<Map<String, Object?>> response = await _mDatabase.rawQuery(_rawQuery.toString(),_values);
    return Sqflite.firstIntValue(response) ?? 0;
  }

  @override
  Future<bool> isExists() async {
    _rawQuery.write(_rawWhere.toString());
    List<Map<String, dynamic>> response = await _mDatabase.rawQuery(_rawQuery.toString(),_values);
    Map<String, dynamic>? object = response.firstOrNull;
    return object != null;
  }
}
