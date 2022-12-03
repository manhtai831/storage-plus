abstract class ISqlSelect {
  ISqlSelect select(List<String> properties);

  Future<T?> findAll<T>();

  Future<T?> findOne<T>();
}
