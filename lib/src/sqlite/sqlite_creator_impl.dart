import 'package:hive_storage/src/sqlite/database_creator_impl.dart';
import 'package:sqflite/sqflite.dart';

import 'interface/i_sqlite_creator.dart';

class SqliteCreatorImpl implements ISqliteCreator {
  final StringBuffer _rawQuery = StringBuffer();

  Database? _database;

  @override
  ISqliteCreator addBlob(String property) {
    _rawQuery.write(' $property BLOB');
    return this;
  }

  @override
  ISqliteCreator addBool(String property) {
    _rawQuery.write(' $property INTEGER');
    return this;
  }

  @override
  ISqliteCreator addInteger(String property) {
    _rawQuery.write(' $property INTEGER');
    return this;
  }

  @override
  ISqliteCreator addReal(String property) {
    _rawQuery.write(' $property REAL');
    return this;
  }

  @override
  ISqliteCreator addText(String property) {
    _rawQuery.write(' $property TEXT');
    return this;
  }

  @override
  ISqliteCreator addPrimaryKey() {
    _rawQuery.write(' PRIMARY KEY');
    return this;
  }

  @override
  ISqliteCreator autoIncrement() {
    _rawQuery.write(' AUTO INCREMENT');
    return this;
  }

  @override
  ISqliteCreator createTable(String tableName) {
    _rawQuery.write('CREATE TABLE $tableName (');
    return this;
  }

  @override
  ISqliteCreator deleteTable(String tableName) {
    _rawQuery.write('DELETE TABLE $tableName (');
    return this;
  }

  @override
  ISqliteCreator ifNotExsist() {
    List<String> prifixs = _rawQuery.toString().split(' ');
    String tableName = prifixs[prifixs.length - 2];
    String prifixQuery = prifixs.take(prifixs.length - 2).join(' ');
    _rawQuery.clear();
    _rawQuery.write('$prifixQuery IF NOT EXISTS $tableName (');
    return this;
  }

  @override
  ISqliteCreator updateTable(String tableName) {
    _rawQuery.write('ALTER TABLE $tableName (');
    return this;
  }

  @override
  ISqliteCreator notNull() {
    _rawQuery.write(' NOT NULL');
    return this;
  }

  @override
  ISqliteCreator raw(String raw) {
    _rawQuery.write(raw);
    return this;
  }

  @override
  ISqliteCreator log() {
    print(_rawQuery.toString());
    return this;
  }

  @override
  ISqliteCreator withDatabase({String? databaseName}) {
    _database = DatabaseCreatorImpl().getDataBase(name: databaseName);
    return this;
  }

  @override
  ISqliteCreator and() {
    _rawQuery.write(',');
    return this;
  }

  @override
  Future<void> build() async {
    await _database?.execute(_rawQuery.toString());
  }

  @override
  ISqliteCreator ok() {
    _rawQuery.write(')');
    return this;
  }
}
