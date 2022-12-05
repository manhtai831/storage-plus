import 'package:hive_storage/hive_storage.dart';
import 'package:hive_storage/src/sqlite/interface/i_sqlite_index.dart';
import 'package:sqflite/sqlite_api.dart';

class SqliteIndexImpl extends ISqliteIndex {
  final StringBuffer _rawQuery = StringBuffer();
  Database? _database;

  @override
  Future<void> build() async {
    await _database?.execute(_rawQuery.toString());
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
  ISqliteIndex raw(String raw) {
    _rawQuery.write(raw);
    return this;
  }
}
