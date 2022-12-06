import 'package:example/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_storage/hive_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _init() async {
    String tableName = 'users';
    await DatabaseCreatorImpl().connect();
    await SqliteCreatorImpl().raw('drop table if exists  $tableName').build();
    await SqliteCreatorImpl()
        .raw(
            'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , name TEXT, age INTEGER, is_student INTEGER, du_lieu BLOB)')
        .build();
    Map<String, dynamic> s = {'s1': '1', 's2': 2, 's3': false};
    await SqliteCurdImpl()
        .withTable(tableName)
        .setText('name', 'Do Manh Tai')
        .setInteger('age', 18)
        .setBool('is_student', false)
        .setBlob('du_lieu', s.toBytes)
        .insert();
    // await SqliteCurdImpl().mDatabase.insert(tableName, {'name': 'Do Manh Tai', 'is_student': 0,'du_lieu':s.toBytes });

    // await SqliteCreatorImpl().raw('INSERT INTO users (name, age, is_student, du_lieu) VALUES (\'Do Manh Tai\', 18, 0, \'[1, 2, 3]\')').build();

    //  User? response =
    //       await SqliteCurdImpl().raw('SELECT * FROM $tableName ORDER BY id DESC').withConverter((json) => User.fromMap(json)).findOne();

    // print(response);
        Map<String, dynamic> s2 = {'s1': 'update', 's2': 2, 's3': false};
        await SqliteCurdImpl()
        .withTable(tableName)
        .setText('name', 'Do Manh Tai Update')
        .setInteger('age', 18)
        .setBool('is_student', false)
        .setBlob('du_lieu', s2.toBytes)
        .update();
    List<Map>? responseMap = await SqliteCurdImpl().raw('SELECT * FROM $tableName ORDER BY id ASC').findAll();
    print(responseMap);
    print((responseMap?.first['du_lieu']).runtimeType);
    print((responseMap?.first['du_lieu'] as Uint8List).string);
  }
}
