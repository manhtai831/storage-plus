typedef HiveConverter<T> = T Function(dynamic json);

abstract class IHiveCurd {
  IHiveCurd withConverter<T>(HiveConverter<T>? converter);

  Future<T?> insert<T>(dynamic value, {dynamic key});

  Future<T?> update<T>(dynamic key, dynamic value);

  List<T>? findByPage<T>({int? pageIndex = 0, int? pageSize = 50});

  List<T>? findAll<T>();

  T? findById<T>(dynamic key);

  T? firstOrNull<T>();

  T? lastOrNull<T>();

  Future<void> remove(dynamic key);

  Future<void> removeAll();

  int generateId();

  bool isExist(dynamic key);

  IHiveCurd log();
  
  IHiveCurd order<T>(Comparator<T> orderBy);
}
