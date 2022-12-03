import 'package:hive_storage/hive_storage.dart';
import 'package:hive_storage/src/sqlite/interface/i_sqlite_index.dart';
import 'package:sqflite/sqlite_api.dart';

class SqliteIndexImpl extends ISqliteIndex {
  final StringBuffer _rawQuery = StringBuffer();
  Database? _database;
  @override
  ISqliteIndex createIndex(String indexName, {bool? isUnique}) {
    _rawQuery.write('CREATE ${isUnique == true ? 'UNIQUE ' : ''}INDEX IF NOT EXISTS $indexName');
    return this;
  }

  @override
  ISqliteIndex deleteIndex(String indexName) {
    _rawQuery.write('DROP INDEX $indexName');
    return this;
  }

  @override
  ISqliteIndex and() {
    _rawQuery.write(',');
    return this;
  }

  @override
  Future<void> build() async {
    await _database?.execute(_rawQuery.toString());
  }

  @override
  ISqliteIndex column(String columnName) {
    _rawQuery.write(columnName);
    return this;
  }

  @override
  ISqliteIndex on(String tableName) {
    _rawQuery.write(' ON $tableName (');
    return this;
  }

  @override
  ISqliteIndex withDatabase({String? databaseName}) {
    _database = DatabaseCreatorImpl().getDataBase(name: databaseName);
    return this;
  }

  @override
  ISqliteIndex log() {
    print(_rawQuery.toString());
    return this;
  }

  @override
  ISqliteIndex ok() {
    _rawQuery.write(')');
    return this;
  }

  @override
  ISqliteIndex raw(String raw) {
    _rawQuery.write(raw);
    return this;
  }
}
