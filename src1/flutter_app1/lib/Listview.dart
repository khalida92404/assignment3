import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'week4/listview_json_api_task-4.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: ListViewJsonapi(),
    );
  }
}
class ListViewJsonapi extends StatefulWidget {
  _ListViewJsonapiState createState() => _ListViewJsonapiState();
}

class _ListViewJsonapiState extends State<ListViewJsonapi> {
  final String uri = 'https://nawikurdi.com/api?limit=50&offset=0';

  Future<List<names>> _fetchnames() async {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<names> listOfnames = items.map<names>((json) {
        return names.fromJson(json);
      }).toList();

      return listOfnames;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurdish names with description'),
      ),
      body: FutureBuilder<List<names>>(
        future: _fetchnames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((name) => ListTile(
              title: Text(name.name),
              subtitle: Text(name.desc),
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(name.gender,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    )),
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}

class names {
  //int id;
  String name;
  String desc;
  String gender;

  names({
    //.id,
    this.name,
    this.desc,
    this.gender,
  });

  factory names.fromJson(Map<String, dynamic> json) {
    return names(
      //id: json['id'],
      name: json['name'],
      desc: json['desc'],
      gender: json['gender'],
    );
  }
}