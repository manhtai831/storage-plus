abstract class ISqliteIndex {

  ISqliteIndex raw(String raw);

  ISqliteIndex log();

  ISqliteIndex withDatabase({String? databaseName});

  Future<void> build();
}
