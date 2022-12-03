import 'package:sqflite/sqflite.dart';

import 'interface/i_database_creator.dart';

class DatabaseCreatorImpl implements IDatabaseCreator {
  DatabaseCreatorImpl._();

  static final DatabaseCreatorImpl _singleton = DatabaseCreatorImpl._();

  factory DatabaseCreatorImpl() => _singleton;
  final Map<String, Database> _mDatabases = {};

  @override
  Future<void> close({String? name}) async {
    name ??= 'defaultNameDatabase';
    await _mDatabases[name]?.close();
  }

  @override
  Future<void> connect({String? name}) async {
    name ??= 'defaultNameDatabase';
    if (_mDatabases.containsKey(name)) return;

    var databasesPath = await getDatabasesPath();
    // var databasesPath = '../../sql_data';

    StringBuffer buffer = StringBuffer(databasesPath);
    buffer.write('$name.db');
    print(buffer.toString());

    _mDatabases[name] = await openDatabase(buffer.toString(), version: 1, onDowngrade: onDowngrade, onUpgrade: onUpgrate);
  }

  @override
  Future<void> closeAll() async {
    await Future.forEach(_mDatabases.keys, (element) => close(name: element));
  }

  @override
  Database getDataBase({String? name}) {
    name ??= 'defaultNameDatabase';
    if (!_mDatabases.containsKey(name)) throw Exception('Not found database with name: $name');
    return _mDatabases[name]!;
  }

  @override
  void onDowngrade(Database db, int oldVersion, int newVersion) {}

  @override
  void onUpgrate(Database db, int oldVersion, int newVersion) {}
}
