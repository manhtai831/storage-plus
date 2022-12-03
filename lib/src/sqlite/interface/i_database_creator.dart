import 'package:sqflite/sqflite.dart';

abstract class IDatabaseCreator {
  Future<void> connect({String? name});

  Future<void> close({String? name});

  Future<void> closeAll();

  Database getDataBase({String? name});
  
  void onUpgrate(Database db, int oldVersion, int newVersion);

  void onDowngrade(Database db, int oldVersion, int newVersion);
}
