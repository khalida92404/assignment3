import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app11/insert.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


// Note: Add the following two lines to the list of dependencies:
//  path_provider:
//  sqflite: ^1.3.0
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  build(context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  Future<Database> database;

  MyHomePageState();

  Future<void> createDatabase() async {
    database = openDatabase(join(await getDatabasesPath(), 'students.db'),
        onCreate: (dbase, ver) {
          dbase.execute(
              "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, mark INTEGER)");
        }, version: 1);
    print(await getDatabasesPath());
  }

  Future<void> queryDatabase(context) async {
    Database db = await database;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QueryWidget(db)));
  }

  Future<void> insertIntoDatabase(context) async {
    final db = await database;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InsertWidget(db)));
  }

  Future<void> deleteFromDatabase(context) async {
    final db = await database;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DeleteWidget(db)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Info"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Create/Open Database"),
              onPressed: () async {
                await createDatabase();
              },
            ),
            RaisedButton(
              child: Text("Query Database"),
              onPressed: () async {
                await queryDatabase(context);
              },
            ),
            RaisedButton(
                child: Text("Insert record into Database"),
                onPressed: () async {
                  await insertIntoDatabase(context);
                }),
            RaisedButton(
              child: Text("Delete record from Database"),
              onPressed: () async {
                await deleteFromDatabase(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QueryWidget extends StatelessWidget {
  final database;

  QueryWidget(this.database);

  Future<List<Student>> queryDatabase() async {
    Database db = await database;
    List<Map<String, dynamic>> map = await db.query("students");

    var list = List.generate(map.length, (v) {
      return Student(
          id: map[v]['id'], name: map[v]['name'], mark: map[v]['mark']);
    });

    return list;
  }

  Widget intoTable(List<Student> students) {
    var rows = List.of(students.map((s) => DataRow(cells: [
      DataCell(Text(s.id.toString())),
      DataCell(Text(s.name)),
      DataCell(Text(s.mark.toString()))
    ])));
    return DataTable(columns: [
      DataColumn(label: Text("Id")),
      DataColumn(label: Text("Name")),
      DataColumn(label: Text("Mark")),
    ], rows: rows);
  }

  build(context) {
    var query = queryDatabase();
    Future<Widget> table = query.then((v) => intoTable(v));

    return FutureBuilder<Widget>(
        future: table,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Scaffold(
                appBar: AppBar(
                  title: Text('Student Table'),
                ),
                body: SingleChildScrollView(child: snapshot.data));
          else if (snapshot.hasError)
            return Text("Error" + snapshot.error);
          else
            return Text("Pending...");
        });
  }
}

class DeleteWidget extends StatefulWidget {
  final database;

  DeleteWidget(this.database);

  @override
  State<StatefulWidget> createState() {
    return DeleteWidgetState(database);
  }
}

class DeleteWidgetState extends State<DeleteWidget> {
  final database;

  DeleteWidgetState(this.database);

  Future<List<Student>> queryDatabase() async {
    Database db = await database;
    List<Map<String, dynamic>> map = await db.query("students");

    return List.generate(map.length, (v) {
      return Student(
          id: map[v]['id'], name: map[v]['name'], mark: map[v]['mark']);
    });
  }

  deleteRecord(id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Student from the database.
    await db.delete(
      'students',
      // Use a `where` clause to delete a specific student.
      where: "id = ?",
      // Pass the Student's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  List<Widget> intoTable(List<Student> students) {
    var rows = List.of(students.map((s) => DataRow(cells: [
      DataCell(Text(s.id.toString())),
      DataCell(Text(s.name)),
      DataCell(Text(s.mark.toString()))
    ])));
    return [
      DataTable(columns: [
        DataColumn(label: Text("Id")),
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Mark")),
      ], rows: rows)
    ];
  }

  build(context) {
    var query = queryDatabase();
    var table = query.then((v) => intoTable(v));
    var tec = TextEditingController(text: "");
    int id;

    var idField = TextField(
      controller: tec,
      onChanged: (str) => id = num.parse(str),
    );
    var delButton = RaisedButton(
      child: Text("Delete Record"),
      onPressed: () async {
        await deleteRecord(id);
        Navigator.pop(context);
      },
    );

    return FutureBuilder<List<Widget>>(
        future: table,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Scaffold(
              appBar: AppBar(
                title: Text('Student Table'),
              ),
              body: ListView(
                children: snapshot.data + [idField, delButton],
              ),
            );
          else if (snapshot.hasError)
            return Text("Error" + snapshot.error);
          else
            return Text("Pending...");
        });
  }
}

class NameWidget extends StatelessWidget {
  final Future<Widget> student;

  NameWidget(this.student);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: student,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else
          return Text("Waiting..");
      },
    );
  }
}

class InsertWidget extends StatefulWidget {
  final database;

  InsertWidget(this.database);

  @override
  State<StatefulWidget> createState() {
    return InsertWidgetState(database);
  }
}

class InsertWidgetState extends State<InsertWidget> {
  var database;
  int _id;
  String _name;
  int _mark;
  var _formChanged = false;
  var tecId = TextEditingController(text: "");
  var tecName = TextEditingController(text: "");
  var tecMark = TextEditingController(text: "");
  var context;
  InsertWidgetState(this.database);

  Future<void> insertStudent(Student student) async {
    final Database db = await database;


    await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );


  }

  Future<bool> _onWillPop() {
    if (!_formChanged) return Future<bool>.value(true);
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to abandon the form? Any changes will be lost."),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Abandon"),
                textColor: Colors.red,
              ),
            ],
          );
        });
  }

  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Insert Record"),
      ),
      body: Form(
        autovalidate: _formChanged,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: tecId,
            decoration: const InputDecoration(
              hintText: 'insert your id',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'id can not be empty';
              }
              return null;
            },
          ),
          TextFormField(
            controller: tecName,
            decoration: const InputDecoration(
              hintText: 'insert your name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'name can not be empty';
              }

              return null;
            },
          ),
          TextFormField(
            controller: tecMark,
            decoration: const InputDecoration(
              hintText: 'insert your mark',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'id can not be empty';
              }
              if(value.length>2)
                return' mark can not be more than 100';
              return null;
            },
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate());
            },
            child: Text('insert'),
          ),
        ],
      ),
    )
    );

  }
}

class Student {
  final int id;
  final String name;
  final int mark;

  Student({this.id, this.name, this.mark});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mark': mark,
    };
  }

  @override
  String toString() {
    return 'id: $id, name: $name, mark: $mark';
  }
}
