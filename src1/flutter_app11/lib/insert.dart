import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

/// This Widget is the main application widget.
class Inser extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
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

            },
            child: Text('insert'),
          ),
        ],
      ),
    );
  }
}
