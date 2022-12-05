
abstract class ISqliteCreator {

  ISqliteCreator raw(String raw);

  ISqliteCreator log();

  ISqliteCreator withDatabase({String? databaseName});

  Future<void> build();
}
