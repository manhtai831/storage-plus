import 'package:hive_storage/src/sqlite/database_creator_impl.dart';
import 'package:sqflite/sqflite.dart';

import 'interface/i_sqlite_creator.dart';

class SqliteCreatorImpl implements ISqliteCreator {
  final StringBuffer _rawQuery = StringBuffer();

  Database? _database;

  Database get _mDatabase => _database ?? DatabaseCreatorImpl().getDataBase();

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
  Future<void> build() async {
    await _mDatabase.execute(_rawQuery.toString());
  }
}
