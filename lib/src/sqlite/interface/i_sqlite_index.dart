abstract class ISqliteIndex {
  ISqliteIndex createIndex(String indexName, {bool? isUnique});

  ISqliteIndex deleteIndex(String indexName);

  ISqliteIndex on(String tableName);

  ISqliteIndex column(String columnName);

  ISqliteIndex and();
  
  ISqliteIndex ok();

  ISqliteIndex raw(String raw);

  ISqliteIndex log();

  ISqliteIndex withDatabase({String? databaseName});

  Future<void> build();
}
