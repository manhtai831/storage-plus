import 'package:flutter/material.dart';
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
    String databaseName = 'taidm';
    String tableName = 'users';
    await DatabaseCreatorImpl().connect(name: databaseName);
    await SqliteCreatorImpl()
        .createTable(tableName)
        .ifNotExsist()
        .addInteger('id')
        .notNull()
        .addPrimaryKey()
        .and()
        .addText('name')
        .and()
        .addInteger('age')
        .and()
        .addBool('is_student')
        .withDatabase(databaseName: databaseName)
        .ok()
        .log()
        .build();
    await DatabaseCreatorImpl().getDataBase(name: databaseName).execute('INSERT INTO $tableName (name, age, is_student) VALUES (\'Taidm\', 18, 0)');
    await DatabaseCreatorImpl().getDataBase(name: databaseName).execute('INSERT INTO $tableName (name, age, is_student) VALUES (\'Taidm\', 18, 0)');
    List response = await DatabaseCreatorImpl().getDataBase(name: databaseName).rawQuery('SELECT * FROM $tableName');

    print(response);
  }
}
