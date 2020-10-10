import 'package:flutter/material.dart';
enum page{dashBoard, manage}

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  page _selectedpage=page.dashBoard;
  MaterialColor active=Colors.red;
  MaterialColor notActive=Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
             child: FlatButton.icon(onPressed: (){
               setState(() {
                 _selectedpage=page.dashBoard;
               });
             }, icon: Icon(Icons.dashboard,color: _selectedpage==page.dashBoard?active:notActive,),
                 label: Text('DashBoard')),
            ),
            Expanded(child: FlatButton.icon(onPressed: (){
              setState(() {
                _selectedpage=page.manage;
              });
            }, icon: Icon(Icons.sort,color:_selectedpage==page.manage?active:notActive,),
                label:Text('Manage')))
          ],
        )
      ),
      body: _loadScreen());
  }
  Widget _loadScreen(){
    switch (_selectedpage){
      case page.dashBoard:
        return Column(
          children: [
            ListTile(
              subtitle: FlatButton.icon(onPressed: null, icon: null, label: null),
            ),
            Expanded(
              child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                Padding(padding: const EdgeInsets.all(20),
                child: Card(
                  child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text('Users')),
                  ),
                ),),
                  Padding(padding: const EdgeInsets.all(20),
                  child: Card(
                    child: ListTile(
                        title: FlatButton.icon(onPressed: null, icon: Icon(Icons.category),
                            label: Text('Category')),
                  ),
                 ),
                  ),
                Padding(padding: const EdgeInsets.all(20),
                   child: Card(
                        child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text('Test')),
                     ),
                     ),
                       ),
                     Padding(padding: const EdgeInsets.all(20),
                          child: Card(
                               child: ListTile(
                   title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text('Orders')),
    ),
    ),
                     ),

              ],),
              
            )
          ],
        );
        break;
      case page.manage:return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Tests'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.change_history),
            title: Text('category history'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Sample Type'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('fasting or not'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Category'),
            onTap: (){},
          ),
        ],
      );
      break;Default:
    return Container();
    }
  }
}
