abstract class ISqliteCreator {
  ISqliteCreator createTable(String tableName);

  ISqliteCreator updateTable(String tableName);

  ISqliteCreator deleteTable(String tableName);

  ISqliteCreator ifNotExsist();

  ISqliteCreator addInteger(String property);

  ISqliteCreator addReal(String property);

  ISqliteCreator addText(String property);

  ISqliteCreator addBlob(String property);

  ISqliteCreator addBool(String property);

  ISqliteCreator addPrimaryKey();

  ISqliteCreator autoIncrement();

  ISqliteCreator notNull();

  ISqliteCreator and();
  
  ISqliteCreator ok();

  ISqliteCreator raw(String raw);

  ISqliteCreator log();

  ISqliteCreator withDatabase({String? databaseName});

  Future<void> build();
}
