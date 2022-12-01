import 'package:flutter_test/flutter_test.dart';
import 'package:hive_storage/src/hive_curd_impl.dart';
import 'package:hive_storage/src/main.dart';
import 'package:hive_storage/src/name_collection.dart';

void main() async {
  HiveCurdImpl.connect();
  await HiveCurdImpl.create(name: NameCollection.messages);
  await HiveCurdImpl.create(name: NameCollection.groups);

  test('Chỉ tạo ra 1 box trong tất cả các thời điểm với 1 tên', _onUseMessageBox);
  test('Tạo với key hoặc không key', _onAddByKeyOrNoneKey);
  test('Cập nhật với key', _onUpdateByKey);
  test('Xóa với key', _onDeleteByKey);
  test('Lấy tất cả', _onGetAll);
  test('Phân trang', _onFindByPaging);
  test('Lấy 1 phần tử với key', _onFindOne);
  test('Lấy 1 phần tử đầu tiên', _onFindFirt);
  test('Lấy 1 phần tử cuối cùng', _onFindLast);
  test('Lấy 1 phần tử với converter', _onFindLast);

  group('Test get with converter', () {
    test('Lấy tất cả với converter', _onFindAllWithConverter);
    test('Lấy phân trang với converter', _onFindPagingWithConverter);
    test('Lấy phần tử đầu tiên với converter', _onFindFirstWithConverter);
    test('Lấy phần tử cuối cùng với converter', _onFindLastWithConverter);
  });
}

void _onUseMessageBox() {
  HiveCurdImpl impl = HiveCurdImpl.msg();
  HiveCurdImpl impl2 = HiveCurdImpl.msg();

  expect(impl.collection, impl2.collection);
}

void _onUpdateByKey() async {
  Map<String, dynamic> data0 = {'id': 0, 'name': 'data0'};
  Map<String, dynamic> data1 = {'id': 0, 'name': 'data1'};
  String key = 'dataUpdate';
  HiveCurdImpl impl = HiveCurdImpl.msg();
  await impl.insert(data0, key: key);

  expect(impl.collection, isNotNull);
  Map<String, dynamic> response0 = impl.collection!.get(key);
  await impl.update(key, data1);
  Map<String, dynamic> response1 = impl.collection!.get(key);
  expect(response0['id'] == 0, response1['id'] == 0);
  expect(response0['name'] == 'data0', response1['name'] == 'data1');
}

void _onAddByKeyOrNoneKey() async {
  Map<String, dynamic> data0 = {'id': 0, 'name': 'data0'};
  String key = 'dataInsert';
  HiveCurdImpl impl = HiveCurdImpl.msg();
  Map<String, dynamic> response = await impl.insert(data0, key: key);
  expect(data0['id'], 0);
  expect(response['id'], 0);
  expect(data0['name'], 'data0');
  expect(response['name'], 'data0');
}

void _onDeleteByKey() async {
  Map<String, dynamic> data1 = {'id': 0, 'name': 'data1'};
  String key = 'dataRemove';
  HiveCurdImpl impl = HiveCurdImpl.msg();
  Map<String, dynamic> response = await impl.insert(data1, key: key);
  expect(response['id'], 0);
  expect(response['name'], 'data1');
  await impl.remove(key);
  Map<String, dynamic>? afterData = impl.collection!.get(key);
  bool? isExist = impl.collection!.containsKey(key);
  expect(afterData, isNull);
  expect(isExist, isFalse);
}

void _onGetAll() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();
  Map<String, dynamic> data = {'id': 0};
  await impl.insert(data);
  await impl.insert(data);
  await impl.insert(data);
  await impl.insert(data);
  List<Map<String, dynamic>>? response = impl.findAll<Map<String, dynamic>>();

  expect(response, isNotNull);
  expect(response!.length, 4);
}

void _onFindByPaging() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();

  for (int i = 0; i < 1000; i++) {
    await impl.insert({'id': i});
  }

  List<Map<String, dynamic>>? response = impl.findByPage<Map<String, dynamic>>(pageIndex: -1, pageSize: 20);
  var firstData = impl.collection?.values.elementAt(0);
  var data20 = impl.collection?.values.elementAt(19);
  expect(response, isNotNull);
  expect(response!.length, 20);
  expect(firstData['id'], response.first['id']);
  expect(data20['id'], response[19]['id']);
}

void _onFindOne() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();

  for (int i = 0; i < 100; i++) {
    await impl.insert({'id': i}, key: i);
  }
  Map<String, dynamic>? data = impl.findById(0);
  expect(data, isNotNull);
  expect(data?['id'], 0);
}

_onFindFirt() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();

  for (int i = 0; i < 100; i++) {
    await impl.insert({'id': i}, key: i);
  }
  Map<String, dynamic>? data = impl.firstOrNull();
  expect(data, isNotNull);
  expect(data?['id'], 0);
}

_onFindLast() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();

  for (int i = 0; i < 100; i++) {
    await impl.insert({'id': i}, key: i);
  }
  Map<String, dynamic>? data = impl.lastOrNull();
  expect(data, isNotNull);
  expect(data?['id'], 99);
}

void _onFindAllWithConverter() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();

  for (int i = 0; i < 100; i++) {
    await impl.insert({'id': i}, key: i);
  }
  List<UserModel>? data = HiveCurdImpl.group().withConverter<List<UserModel>>((json) => json.map<UserModel>((e) => UserModel.fromMap(e)).toList()).findAll();
  expect(data, isNotNull);
  expect(data.runtimeType, List<UserModel>);
}

void _onFindPagingWithConverter() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();
  for (int i = 0; i < 100; i++) {
    await impl.insert({'id': i}, key: i);
  }

  List<UserModel>? data = HiveCurdImpl.group().withConverter<List<UserModel>>((json) => json.map<UserModel>((e) => UserModel.fromMap(e)).toList()).findByPage();

  expect(data, isNotNull);
  expect(data?.length, 50);
  expect(data.runtimeType, List<UserModel>);
}

void _onFindFirstWithConverter() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();

  for (int i = 0; i < 100; i++) {
    await impl.insert({'id': i}, key: i);
  }
  UserModel? data = HiveCurdImpl.group().withConverter((json) => UserModel.fromMap(json)).firstOrNull();
  expect(data, isNotNull);
  expect(data.runtimeType, UserModel);
  expect(data?.id, 0);
}

void _onFindLastWithConverter() async {
  HiveCurdImpl impl = HiveCurdImpl.group();
  await impl.removeAll();

  for (int i = 0; i < 100; i++) {
    await impl.insert({'id': i}, key: i);
  }
  UserModel? data = HiveCurdImpl.group().withConverter((json) => UserModel.fromMap(json)).lastOrNull();
  expect(data, isNotNull);
  expect(data.runtimeType, UserModel);
  expect(data?.id, 99);
}
