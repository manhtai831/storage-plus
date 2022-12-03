import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_storage/src/name_collection.dart';

import 'i_hive_curd.dart';

class HiveCurdImpl extends IHiveCurd {
  static final Map<String, Box> _mBoxes = {};
  HiveConverter? _converter;
  Comparator? _orderBy;
  final Box? _collection;

  HiveCurdImpl() : _collection = _mBoxes[NameCollection.messages];
  HiveCurdImpl.msg() : _collection = _mBoxes[NameCollection.messages];
  HiveCurdImpl.group() : _collection = _mBoxes[NameCollection.groups];
  HiveCurdImpl.users() : _collection = _mBoxes[NameCollection.users];

  Box? get collection => _collection;

  static void connect() => Hive.init('./local.data');

  static Future<void> create({String? name}) async {
    name ??= 'defaultBoxName';
    if (_mBoxes.containsKey(name)) return;
    Box box = await Hive.openBox(name);
    _mBoxes[name] = box;
  }

  static Future<void> close() => Hive.close();

  @override
  Future<T?> update<T>(key, value) async {
    await _collection?.put(key, value);
    return _converter?.call(value) ?? value;
  }

  @override
  Future<T> insert<T>(dynamic value, {dynamic key}) async {
    if (key != null) update(key, value);
    if (key == null) await _collection?.add(value);
    return _converter?.call(value) ?? value;
  }

  @override
  Future<void> remove(dynamic key) async {
    await _collection!.delete(key);
  }

  @override
  List<T>? findAll<T>() {
    List<Map<String, dynamic>> mDatas = _collection!.values.map<Map<String, dynamic>>((e) => e.cast<String, dynamic>()).toList();
    return _converter?.call(mDatas) ?? mDatas;
  }

  @override
  T? findById<T>(dynamic key) {
    var data = _collection!.get(key)?.cast<String, dynamic>();
    if (data == null) return null;
    return _converter?.call(data) ?? data as T?;
  }

  @override
  List<T>? findByPage<T>({int? pageIndex = 0, int? pageSize = 50}) {
    if (pageSize! > 50 || pageSize <= 0) pageSize = 50;
    if (pageIndex! < 0) pageIndex = 0;
    int skipCount = pageIndex * pageSize;
    int count = _collection!.values.length;
    if (count < skipCount) return [];
    var mDatas = _collection!.values.skip(skipCount).take(pageSize).map<Map<String, dynamic>>((e) => e.cast<String, dynamic>()).toList();
    return _converter?.call(mDatas) ?? mDatas;
  }

  @override
  IHiveCurd withConverter<T>(HiveConverter<T>? converter) {
    _converter = converter;
    return this;
  }

  @override
  IHiveCurd log() {
    print(_collection?.toMap());
    return this;
  }

  @override
  int generateId() => (_collection!.keys.lastOrNull ?? -1) + 1;

  @override
  T? firstOrNull<T>() {
    int? key = _collection!.keys.firstOrNull;
    if (key == null) return null;
    return findById(key);
  }

  @override
  T? lastOrNull<T>() {
    int? key = _collection!.keys.lastOrNull;
    if (key == null) return null;

    return findById(key);
  }

  @override
  Future<void> removeAll() => _collection!.deleteAll(_collection!.keys);

  @override
  bool isExist(key) => _collection!.containsKey(key);

  @override
  IHiveCurd order<T>(Comparator<T> orderBy) {
    _orderBy = orderBy as Comparator?;
    return this;
  }

  @override
  int count() => _collection!.length;
}
